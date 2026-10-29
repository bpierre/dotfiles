# middle-debounce

A focused Linux evdev/uinput filter for the chattering middle button on a
Pulsar 1K Dongle (`3710:5402`).

## Why it exists

The physical middle-button switch intermittently emits an extra click. During
a controlled raw-input test, 10 slow physical clicks produced 11
`BTN_MIDDLE` press/release pairs. The extra sequence contained a release and
re-press separated by only 9 ms, far faster than the user could physically
click. A later foreground run of this filter caught another real occurrence
at 9.4 ms.

This establishes that the duplication originates in the mouse or dongle,
before the desktop compositor and applications receive the event. Filtering
at evdev/uinput level prevents every application from seeing the false click.

## How it works

The physical press is forwarded immediately. A physical release is held for
the configured debounce window (50 ms by default). If the switch reports
another press during that window, the false release and re-press are both
discarded. Motion, scrolling, and every other button are passed through
unchanged.

The runtime path is:

```text
Pulsar physical evdev device
  -> exclusive grab by middle-debounce
  -> capability-matched uinput virtual mouse
  -> libinput / compositor / applications
```

The release is delayed instead of the press so middle-click actions remain
responsive. If the 50 ms window expires without a re-press, the release is
emitted normally. If a re-press arrives within the window, the logical button
simply remains down until the switch's final release.

Kernel event timestamps classify the release-to-press gap, while a separate
monotonic clock schedules deferred releases. This preserves the real spacing
of events received in one kernel batch and avoids wall-clock adjustments
affecting timers.

The program deliberately:

- requires an explicit device path;
- verifies the Pulsar USB vendor and product IDs;
- filters only `BTN_MIDDLE`;
- mirrors the physical mouse's key, relative-axis, absolute-axis, property,
  switch, and miscellaneous capabilities;
- uses each kernel event's timestamp when classifying chatter;
- fails closed if the selected device has unsupported capabilities;
- contains no installation or privilege-escalation logic in the binary.

The tradeoff is that a genuine second middle-button press less than 50 ms
after a release would also be classified as chatter. Normal releases are
visible to applications 50 ms late, but presses have no added debounce delay.

## Build and test

```sh
cd ~/dotfiles/middle-debounce
cargo test --locked
cargo clippy --locked --all-targets -- -D warnings
cargo build --release --locked
```

The filter state machine has tests for normal clicks, duplicate events, the
captured 9 ms and 32 ms chatter patterns, the 50 ms boundary, kernel batching,
and release timer rounding.

## Run manually

Find the stable physical mouse path:

```sh
ls -l /dev/input/by-id/*Pulsar*event-mouse
```

Then run the filter in the foreground:

```sh
sudo ~/dotfiles/middle-debounce/target/release/middle-debounce \
  --verbose \
  /dev/input/by-id/usb-Pulsar_1K_Dongle-event-mouse
```

Stop it with `Ctrl-C`. The kernel closes the input descriptors and removes the
virtual device when the process exits, including on termination or a crash.

## Validate before installing

Keep the filter running in the first terminal. In a second terminal, record
the events exposed to the desktop:

```sh
sudo timeout 20s libinput debug-events > /tmp/middle-debounce-test.log 2>&1
```

While that command is running, make exactly 10 slow middle clicks. Then check:

```sh
grep BTN_MIDDLE /tmp/middle-debounce-test.log
grep -c 'BTN_MIDDLE.*pressed' /tmp/middle-debounce-test.log
grep -c 'BTN_MIDDLE.*released' /tmp/middle-debounce-test.log
```

A successful run has exactly 10 `pressed` and 10 `released` lines. If the
filter's first terminal reports suppressed chatter, the raw switch bounced
but only one logical click was exposed. Do not install an autostart service
until this manual test passes and normal motion, scrolling, and other buttons
still behave correctly.

## Install the validated system service

The included unit uses the stable device path
`/dev/input/by-id/usb-Pulsar_1K_Dongle-event-mouse`. It retries after startup,
disconnects, and reconnects.

```sh
sudo install -Dm755 target/release/middle-debounce \
  /usr/local/bin/middle-debounce
sudo install -Dm644 systemd/middle-debounce.service \
  /etc/systemd/system/middle-debounce.service
sudo systemctl daemon-reload
sudo systemctl enable --now middle-debounce.service
systemctl status middle-debounce.service --no-pager
```

The unit runs as a system service because it must open the physical evdev node
and `/dev/uinput`. It has no capability set, cannot gain new privileges, has
an otherwise read-only system view, cannot access home directories, and
enables additional systemd sandboxing.
`Restart=always` makes it retry if the mouse is absent at boot, disconnected,
or reconnected.

## Operate and monitor

Check whether it is active and whether it has restarted:

```sh
systemctl status middle-debounce.service --no-pager
systemctl show middle-debounce.service \
  --property=ActiveState,SubState,NRestarts,ExecMainStatus
```

Follow live chatter detections:

```sh
journalctl -fu middle-debounce.service
```

Review detections from the current boot:

```sh
journalctl -u middle-debounce.service -b --no-pager |
  rg 'suppressed middle-button chatter'
```

Stopping the service immediately releases the physical mouse and removes the
virtual one:

```sh
sudo systemctl stop middle-debounce.service
sudo systemctl start middle-debounce.service
```

## Upgrade after changing the code

Build and validate before replacing the running binary:

```sh
cd ~/dotfiles/middle-debounce
cargo test --locked
cargo clippy --locked --all-targets -- -D warnings
cargo build --release --locked
sudo install -Dm755 target/release/middle-debounce \
  /usr/local/bin/middle-debounce
sudo systemctl restart middle-debounce.service
systemctl status middle-debounce.service --no-pager
```

If the unit file changes, reinstall it and reload systemd before restarting:

```sh
sudo install -Dm644 systemd/middle-debounce.service \
  /etc/systemd/system/middle-debounce.service
sudo systemctl daemon-reload
sudo systemctl restart middle-debounce.service
```

## Troubleshooting

Start with:

```sh
systemctl status middle-debounce.service --no-pager
journalctl -u middle-debounce.service -b --no-pager
ls -l /dev/input/by-id/usb-Pulsar_1K_Dongle-event-mouse
```

Common cases:

- `cannot open ... No such file or directory`: the dongle is disconnected or
  its stable udev symlink changed. The service retries every two seconds.
- `cannot exclusively grab`: another process already holds the physical input
  device. Stop the other filter before restarting this service.
- No pointer or button input after an update: stop the service from the
  keyboard with `sudo systemctl stop middle-debounce.service`; device cleanup
  happens automatically when the process exits.
- No chatter messages: this is normal when the intermittent switch fault is
  not occurring. `--verbose` logs only suppressed pairs.

## Remove

Disable the service before deleting its files:

```sh
sudo systemctl disable --now middle-debounce.service
sudo rm /etc/systemd/system/middle-debounce.service
sudo rm /usr/local/bin/middle-debounce
sudo systemctl daemon-reload
```

This removes the installed copies only. The source and tests remain in
`~/dotfiles/middle-debounce`.
