extern crate getopts;
use async_std;
use getopts::Options;
use std::env;
use std::process::Command;
mod notify;

enum UpdateCommand {
    Up,
    Down,
    Mute,
}

enum MuteCommand {
    Unmute,
    Toggle,
}

fn print_usage(program: &str, opts: Options) {
    let brief = format!("\nUsage: {} up|down [-d device]", program);
    print!("{}", opts.usage(&brief));
    print!("\n");
}

fn get_volume() -> Result<i32, Box<dyn std::error::Error>> {
    let output = String::from_utf8(
        Command::new("pactl")
            .arg("get-sink-volume")
            .arg("0")
            .output()
            .expect("failed to execute pactl")
            .stdout,
    )?;

    let output = output.split("/").collect::<Vec<&str>>()[1];
    let output = output.split("%").collect::<Vec<&str>>()[0];
    let output = output.trim();
    let volume = output.trim().parse::<i32>()?;

    Ok(volume)
}

fn change_volume(volume_diff: i32) -> Result<i32, Box<dyn std::error::Error>> {
    let volume = constrain_volume(get_volume()? + volume_diff);

    set_mute(MuteCommand::Unmute)?;

    Command::new("pactl")
        .arg("set-sink-volume")
        .arg("0")
        .arg(format!("{}%", volume))
        .output()
        .expect("failed to execute pactl");

    Ok(volume)
}

fn get_mute() -> Result<bool, Box<dyn std::error::Error>> {
    let output = String::from_utf8(
        Command::new("pactl")
            .arg("get-sink-mute")
            .arg("0")
            .output()
            .expect("failed to execute pactl")
            .stdout,
    )?;

    let output = output.split(":").collect::<Vec<&str>>()[1];
    let output = output.trim();

    Ok(output == "yes")
}

fn set_mute(mute: MuteCommand) -> Result<bool, Box<dyn std::error::Error>> {
    Command::new("pactl")
        .arg("set-sink-mute")
        .arg("0")
        .arg(match mute {
            MuteCommand::Unmute => "no",
            MuteCommand::Toggle => "toggle",
        })
        .output()
        .expect("failed to execute pactl");

    Ok(get_mute()?)
}

async fn notify_state() -> Result<(), Box<dyn std::error::Error>> {
    if get_mute()? {
        notify::notify("Volume muted", 0).await?;
    } else {
        let volume = get_volume()?;
        notify::notify(format!("Volume {}%", volume).as_str(), volume).await?;
    }
    Ok(())
}

async fn update(command: UpdateCommand) -> Result<(), Box<dyn std::error::Error>> {
    match command {
        UpdateCommand::Mute => {
            set_mute(MuteCommand::Toggle)?;
        }
        UpdateCommand::Up => {
            change_volume(5)?;
        }
        UpdateCommand::Down => {
            change_volume(-5)?;
        }
    }
    notify_state().await?;
    Ok(())
}

#[async_std::main]
async fn main() {
    let args: Vec<String> = env::args().collect();
    let program = args[0].clone();

    let mut opts = Options::new();
    opts.optflag("h", "help", "Prints help information");

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

    let update_command = match command.as_str() {
        "up" => UpdateCommand::Up,
        "down" => UpdateCommand::Down,
        "mute" => UpdateCommand::Mute,
        _ => {
            panic!("Invalid command");
        }
    };

    match update(update_command).await {
        Ok(()) => {}
        Err(e) => println!("Error: {}", e),
    }
}

// make sure the volume is a multiple of 5 and between 0 and 100
fn constrain_volume(value: i32) -> i32 {
    let value = (value / 5) * 5;
    if value < 0 {
        0
    } else if value > 100 {
        100
    } else {
        value
    }
}
