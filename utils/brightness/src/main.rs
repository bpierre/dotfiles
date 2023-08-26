extern crate getopts;
use async_std;
use getopts::Options;
use std::env;
use std::fs;
mod notify;

enum UpdateCommand {
    Up,
    Down,
}

const BACKLIGHT_PATH: &str = "/sys/class/backlight";
const PROFILE: [i32; 13] = [1, 4, 6, 8, 12, 16, 20, 24, 32, 40, 50, 70, 100];

// get the first device path found in /sys/class/backlight
fn get_device_path() -> Result<String, std::io::Error> {
    match fs::read_dir(BACKLIGHT_PATH)?.next() {
        Some(entry) => Ok(entry?.path().to_str().unwrap().to_string()),
        None => Err(std::io::Error::new(
            std::io::ErrorKind::NotFound,
            "No backlight device found on the system",
        )),
    }
}

// get the brightness_max value and return it as a float
fn get_brightness_max(device_path: &str) -> Result<f64, Box<dyn std::error::Error>> {
    let brightness_max_str: String = fs::read_to_string(format!("{}/max_brightness", device_path))?;
    let brightness_max_value: f64 = brightness_max_str.trim().parse()?;
    Ok(brightness_max_value)
}

fn print_usage(program: &str, opts: Options) {
    let brief = format!("\nUsage: {} up|down [-d device]", program);
    print!("{}", opts.usage(&brief));
    print!("\n");
}

fn closest_profile_index(pct: i32) -> usize {
    let mut index = 0;
    return loop {
        if PROFILE[index] >= pct {
            if index == 0 {
                break 0;
            }
            if (PROFILE[index] - pct).abs() < (PROFILE[index - 1] - pct).abs() {
                break index;
            }
            break index - 1;
        }
        if index >= PROFILE.len() - 1 {
            break index;
        }
        index += 1;
    };
}

fn brightness_val_to_pct(value: f64, max: f64) -> i32 {
    (value / max * 100.).round() as i32
}

fn brightness_pct_to_val(pct: i32, max: f64) -> f64 {
    ((pct as f64) / 100.0 * max).round()
}

fn get_brightness(
    device_path: &str,
    brightness_value_max: f64,
) -> Result<i32, Box<dyn std::error::Error>> {
    let brightness_str: String = fs::read_to_string(format!("{}/brightness", device_path))?;
    let brightness_value: f64 = brightness_str.trim().parse()?;
    let brightness_percent = brightness_val_to_pct(brightness_value, brightness_value_max);
    Ok(brightness_percent)
}

fn update_brightness(
    command: UpdateCommand,
    device_path: &str,
) -> Result<i32, Box<dyn std::error::Error>> {
    let brightness_max = get_brightness_max(device_path)?;
    let brightness = get_brightness(device_path, brightness_max)?;

    let profile_index = closest_profile_index(brightness);
    let new_profile_index = match command {
        UpdateCommand::Up => profile_index.min(PROFILE.len() - 2) + 1,
        UpdateCommand::Down => profile_index.max(1) - 1,
    };

    let new_brightness = PROFILE[new_profile_index];
    fs::write(
        format!("{}/brightness", device_path),
        brightness_pct_to_val(new_brightness, brightness_max).to_string(),
    )?;

    Ok(new_brightness)
}

#[async_std::main]
async fn main() {
    let args: Vec<String> = env::args().collect();
    let program = args[0].clone();

    let mut opts = Options::new();
    opts.optflag("h", "help", "Prints help information");
    opts.optflagopt(
        "d",
        "device",
        "Define or print the path of the backlight device",
        "DEVICE",
    );

    let matches = match opts.parse(&args[1..]) {
        Ok(m) => m,
        Err(f) => {
            panic!("{}", f.to_string())
        }
    };

    if matches.opt_present("h") {
        print_usage(&program, opts);
        return;
    }

    let device_path = match matches.opt_str("d") {
        Some(device_path) => device_path,
        None => get_device_path().unwrap().to_string(),
    };

    if matches.opt_present("d") && matches.opt_str("d").is_none() {
        println!("{}", device_path);
        return;
    }

    let command = if !matches.free.is_empty() {
        matches.free[0].clone()
    } else {
        print_usage(&program, opts);
        return;
    };

    let update_command = match command.as_str() {
        "up" => UpdateCommand::Up,
        "down" => UpdateCommand::Down,
        _ => {
            panic!("Invalid command");
        }
    };

    if let Ok(brightness) = update_brightness(update_command, &device_path) {
        let _ = notify::notify(brightness).await;
    };
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_closest_profile_index() {
        assert_eq!(closest_profile_index(1), 0);
        assert_eq!(closest_profile_index(3), 0);
        assert_eq!(closest_profile_index(4), 1);
        assert_eq!(closest_profile_index(5), 1);
        assert_eq!(closest_profile_index(25), 5);
        assert_eq!(closest_profile_index(27), 5);
        assert_eq!(closest_profile_index(28), 6);
        assert_eq!(closest_profile_index(40), 6);
        assert_eq!(closest_profile_index(41), 7);
    }
}
