#!/bin/env sh

mic_source="alsa_input.pci-0000_c3_00.6.HiFi__hw_acp63__source"
mute_status=$(pactl get-source-mute $mic_source | awk '{printf $2}')
led_path=/sys/class/leds/platform::micmute/brightness

if [[ $mute_status = "yes" ]]; then
    echo "1" > $led_path
else
    echo "0" > $led_path
fi
