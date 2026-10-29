mod filter;

use std::{
    error::Error,
    io,
    os::fd::AsFd,
    path::{Path, PathBuf},
    time::{Duration, Instant, UNIX_EPOCH},
};

use clap::Parser;
use evdev::{
    BusType, Device, EventType, InputEvent, InputId, KeyCode, SynchronizationCode, UinputAbsSetup,
    uinput::VirtualDevice,
};
use filter::Debouncer;
use nix::poll::{PollFd, PollFlags, PollTimeout, poll};

const EXPECTED_VENDOR: u16 = 0x3710;
const EXPECTED_PRODUCT: u16 = 0x5402;
const MIDDLE: KeyCode = KeyCode::BTN_MIDDLE;

#[derive(Debug, Parser)]
#[command(
    version,
    about = "Debounce BTN_MIDDLE on a Pulsar 1K Dongle",
    after_help = "Run in the foreground first. Stop with Ctrl-C."
)]
struct Args {
    /// Stable physical device path, preferably /dev/input/by-id/*event-mouse
    device: PathBuf,

    /// Deferred-release debounce window in milliseconds
    #[arg(long, default_value_t = 50, value_parser = clap::value_parser!(u64).range(1..=250))]
    debounce_ms: u64,

    /// Log each suppressed release/re-press pair
    #[arg(short, long)]
    verbose: bool,
}

fn main() {
    if let Err(error) = run(Args::parse()) {
        eprintln!("middle-debounce: {error}");
        std::process::exit(1);
    }
}

fn run(args: Args) -> Result<(), Box<dyn Error>> {
    let mut device = Device::open(&args.device).map_err(|error| {
        format!(
            "cannot open {}: {error} (run as root for the manual test)",
            args.device.display()
        )
    })?;
    validate_device(&device, &args.device)?;

    let name = device.name().unwrap_or("Pulsar mouse").to_owned();
    let mut virtual_device = create_virtual_device(&device, &name)?;
    device
        .grab()
        .map_err(|error| format!("cannot exclusively grab {}: {error}", args.device.display()))?;
    device.set_nonblocking(true)?;

    let window = Duration::from_millis(args.debounce_ms);
    let started = Instant::now();
    let mut debouncer = Debouncer::new(window);
    let mut frame = Vec::with_capacity(32);
    let mut chatter_count = 0_u64;

    eprintln!(
        "Filtering {name} ({EXPECTED_VENDOR:04x}:{EXPECTED_PRODUCT:04x}) at {}",
        args.device.display()
    );
    eprintln!(
        "BTN_MIDDLE release debounce: {} ms; all other events pass through",
        window.as_millis()
    );
    eprintln!("Press Ctrl-C to stop.");

    loop {
        let received_now = started.elapsed();
        if debouncer.flush(received_now) {
            emit_frame(&mut virtual_device, &mut frame)?;
            emit_middle_release(&mut virtual_device)?;
        }

        let timeout = poll_timeout(debouncer.remaining(started.elapsed()))?;
        let readiness = {
            let mut descriptors = [PollFd::new(device.as_fd(), PollFlags::POLLIN)];
            poll(&mut descriptors, timeout)?;
            descriptors[0].revents().unwrap_or(PollFlags::empty())
        };

        if readiness.intersects(PollFlags::POLLERR | PollFlags::POLLHUP | PollFlags::POLLNVAL) {
            return Err(format!("input device {} disconnected", args.device.display()).into());
        }
        if !readiness.contains(PollFlags::POLLIN) {
            continue;
        }

        let events: Vec<InputEvent> = match device.fetch_events() {
            Ok(events) => events.collect(),
            Err(error) if error.kind() == io::ErrorKind::WouldBlock => continue,
            Err(error) => return Err(error.into()),
        };
        let batch_received_at = started.elapsed();

        for event in events {
            if is_report(&event) {
                emit_frame(&mut virtual_device, &mut frame)?;
                continue;
            }

            if event.event_type() != EventType::KEY || event.code() != MIDDLE.0 {
                frame.push(event);
                continue;
            }

            let outcome = debouncer.handle(event_time(&event), batch_received_at, event.value());

            if outcome.emit_deferred_release {
                emit_frame(&mut virtual_device, &mut frame)?;
                emit_middle_release(&mut virtual_device)?;
            }
            if outcome.emit_current {
                frame.push(event);
            }
            if let Some(gap) = outcome.chatter_gap {
                chatter_count += 1;
                if args.verbose {
                    eprintln!(
                        "suppressed middle-button chatter #{chatter_count}: {:.1} ms release→press",
                        gap.as_secs_f64() * 1000.0
                    );
                }
            }
        }

        // A fetched kernel batch should end in SYN_REPORT, but flushing here
        // fails safe if a malformed device omits it.
        emit_frame(&mut virtual_device, &mut frame)?;
    }
}

fn validate_device(device: &Device, path: &Path) -> Result<(), Box<dyn Error>> {
    let id = device.input_id();
    if id.vendor() != EXPECTED_VENDOR || id.product() != EXPECTED_PRODUCT {
        return Err(format!(
            "{} is {} ({:04x}:{:04x}), expected the Pulsar dongle ({EXPECTED_VENDOR:04x}:{EXPECTED_PRODUCT:04x})",
            path.display(),
            device.name().unwrap_or("an unknown device"),
            id.vendor(),
            id.product()
        )
        .into());
    }

    let keys = device
        .supported_keys()
        .ok_or("the selected device has no button capabilities")?;
    if !keys.contains(MIDDLE) {
        return Err("the selected device does not expose BTN_MIDDLE".into());
    }
    if device.supported_relative_axes().is_none() {
        return Err("the selected device is not a relative mouse".into());
    }

    for event_type in device.supported_events().iter() {
        if !matches!(
            event_type,
            EventType::SYNCHRONIZATION
                | EventType::KEY
                | EventType::RELATIVE
                | EventType::ABSOLUTE
                | EventType::MISC
                | EventType::SWITCH
        ) {
            return Err(format!(
                "refusing to grab a device with unsupported event type {event_type:?}"
            )
            .into());
        }
    }

    Ok(())
}

fn create_virtual_device(
    device: &Device,
    physical_name: &str,
) -> Result<VirtualDevice, Box<dyn Error>> {
    let id = device.input_id();
    let virtual_id = InputId::new(
        BusType::BUS_VIRTUAL,
        id.vendor(),
        id.product(),
        id.version(),
    );
    let virtual_name = format!("{physical_name} (middle-debounced)");

    let mut builder = VirtualDevice::builder()?
        .name(&virtual_name)
        .input_id(virtual_id)
        .with_properties(device.properties())?;

    if let Some(keys) = device.supported_keys() {
        builder = builder.with_keys(keys)?;
    }
    if let Some(axes) = device.supported_relative_axes() {
        builder = builder.with_relative_axes(axes)?;
    }
    if let Some(misc) = device.misc_properties() {
        builder = builder.with_msc(misc)?;
    }
    if let Some(switches) = device.supported_switches() {
        builder = builder.with_switches(switches)?;
    }
    for (axis, info) in device.get_absinfo()? {
        builder = builder.with_absolute_axis(&UinputAbsSetup::new(axis, info))?;
    }

    Ok(builder.build()?)
}

fn event_time(event: &InputEvent) -> Duration {
    event
        .timestamp()
        .duration_since(UNIX_EPOCH)
        .unwrap_or(Duration::ZERO)
}

fn is_report(event: &InputEvent) -> bool {
    event.event_type() == EventType::SYNCHRONIZATION
        && event.code() == SynchronizationCode::SYN_REPORT.0
}

fn emit_frame(device: &mut VirtualDevice, frame: &mut Vec<InputEvent>) -> io::Result<()> {
    if frame.is_empty() {
        return Ok(());
    }
    device.emit(frame)?;
    frame.clear();
    Ok(())
}

fn emit_middle_release(device: &mut VirtualDevice) -> io::Result<()> {
    device.emit(&[InputEvent::new_now(EventType::KEY.0, MIDDLE.0, 0)])
}

fn poll_timeout(remaining: Option<Duration>) -> Result<PollTimeout, Box<dyn Error>> {
    let Some(remaining) = remaining else {
        return Ok(PollTimeout::NONE);
    };
    if remaining.is_zero() {
        return Ok(PollTimeout::ZERO);
    }

    // poll(2) uses integer milliseconds. Round upward so a release is never
    // emitted before its debounce window has fully elapsed.
    let rounded_ms = remaining.as_millis() + u128::from(remaining.subsec_nanos() % 1_000_000 != 0);
    Ok(PollTimeout::try_from(rounded_ms)?)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn poll_timeout_rounds_up() {
        assert_eq!(
            poll_timeout(Some(Duration::from_micros(1)))
                .unwrap()
                .as_millis(),
            Some(1)
        );
        assert_eq!(
            poll_timeout(Some(Duration::from_micros(1_001)))
                .unwrap()
                .as_millis(),
            Some(2)
        );
    }

    #[test]
    fn no_pending_release_waits_forever() {
        assert!(poll_timeout(None).unwrap().is_none());
    }
}
