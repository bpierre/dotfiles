extern crate getopts;
use anyhow::Result;
use async_std;
use getopts::Options;
use std::env;
use std::fs;
mod notify;

enum UpdateCommand {
    Up,
    Down,
}

const PROFILE: [i32; 13] = [1, 4, 6, 8, 12, 16, 20, 24, 32, 40, 50, 70, 100];
const DEVICE_PATH_DEFAULT: &str = "/sys/class/backlight/amdgpu_bl0/brightness";

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

fn brightness_val_to_pct(value: f64) -> i32 {
    (value / 255. * 100.).round() as i32
}

fn brightness_pct_to_val(pct: i32) -> f64 {
    ((pct as f64) / 100.0 * 255.).round()
}

fn get_brightness(device_path: &str) -> Result<i32> {
    let brightness_str: String = fs::read_to_string(device_path)?;
    let brightness_value: f64 = brightness_str.trim().parse()?;
    let brightness_percent = brightness_val_to_pct(brightness_value);
    Ok(brightness_percent)
}

fn update_brightness(command: UpdateCommand, device_path: &str) -> Result<i32> {
    let brightness = get_brightness(device_path)?;

    let profile_index = closest_profile_index(brightness);
    let new_profile_index = match command {
        UpdateCommand::Up => profile_index.min(PROFILE.len() - 2) + 1,
        UpdateCommand::Down => profile_index.max(1) - 1,
    };

    let new_brightness = PROFILE[new_profile_index];
    fs::write(
        device_path,
        brightness_pct_to_val(new_brightness).to_string(),
    )?;

    Ok(new_brightness)
}

#[async_std::main]
async fn main() {
    let args: Vec<String> = env::args().collect();
    let program = args[0].clone();

    let mut opts = Options::new();
    opts.optflag("h", "help", "Prints help information");
    opts.optflag("d", "device", "Change the path of the brightness device");

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

    let command = if !matches.free.is_empty() {
        matches.free[0].clone()
    } else {
        print_usage(&program, opts);
        return;
    };

    let device_path = match matches.opt_str("d") {
        Some(device_path) => device_path,
        None => DEVICE_PATH_DEFAULT.to_string(),
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
