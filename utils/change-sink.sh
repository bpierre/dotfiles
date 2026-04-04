#!/bin/bash

speaker_sink="alsa_output.pci-0000_c3_00.6"

switch_audio() {
    local search_term="$1"
    local sink_nickname="$2"
    local sink_index

    sink_index=$(pactl -f json list short sinks | jq -r ".[] | select(.name | contains(\"$search_term\")) | .index" | head -n1)

    if [ -z "$sink_index" ]; then
        echo "No sink found matching '$search_term'"
        exit 1
    fi

    pactl set-default-sink "$sink_index"

    echo "Switched to sink $sink_index ($sink_nickname)"
}

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 [bluetooth|speaker]"
    exit 1
fi

# Switch based on the argument
case "$1" in
    bluetooth)
        switch_audio "bluez" "bluetooth"
        ;;
    speaker)
        switch_audio "$speaker_sink" "speaker"
        ;;
    *)
        echo "Invalid argument. Use 'bluetooth' or 'speaker'."
        exit 1
        ;;
esac
