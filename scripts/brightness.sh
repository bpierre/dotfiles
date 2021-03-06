#!/usr/bin/env bash

# You can call this script like this:
# $ ./brightness.sh up
# $ ./brightness.sh down

# Script modified from:
# From https://gist.github.com/Blaradox/030f06d165a82583ae817ee954438f2e
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

# The brightness actual value is between 0 and 255, but we set it using a
# 0-100, which means that some precision is lost along the way. This is why we
# round the actual value to the nearest 10, and set it manually (-S) rather
# than using brillo’s incremental increases (-A / -U).
function get_brightness {
  brillo -G | awk '{printf ("%.0f", ($1/10))}' | awk '{print $1*10}'
}

function notify_brightness {
  dunstify \
    --replace 1111 \
    --timeout 1000 \
    --hints int:value:$1 \
    --urgency normal "Brightness $1"
}

case $1 in
  up)
    value=$(get_brightness | awk '{print $1 + 10}')
    value=$(($value > 100 ? 100 : $value))

    notify_brightness $value
    brillo -u 100000 -S $value
    ;;
  down)
    value=$(get_brightness | awk '{print $1 - 10}')
    value=$(($value < 0 ? 0 : $value))

    notify_brightness $value
    brillo -u 100000 -S $value
    ;;
esac
