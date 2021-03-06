#!/usr/bin/env bash

# You can call this script like this:
# $ ./volume.sh up
# $ ./volume.sh down
# $ ./volume.sh mute

# Script modified from:
# From https://gist.github.com/Blaradox/030f06d165a82583ae817ee954438f2e
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

function get_volume {
  amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
  amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function notify_volume {

  if is_mute ; then
    volume="0"
    label="Volume muted"
  else
    volume=$(get_volume)
    label="Volume $volume%"
  fi

  dunstify \
    --replace 1111 \
    --timeout 1000 \
    --hints int:value:$volume \
    --urgency normal "$label"
}

case $1 in
  up)
    # set the volume on (if it was muted)
    amixer -D pulse set Master on > /dev/null
    # up the volume (+ 5%)
    amixer -D pulse sset Master 5%+ > /dev/null
    notify_volume
    ;;
  down)
    # lower the volume (- 5%)
    amixer -D pulse set Master on > /dev/null
    amixer -D pulse sset Master 5%- > /dev/null
    notify_volume
    ;;
  mute)
    # toggle mute
    amixer -D pulse set Master 1+ toggle > /dev/null
    notify_volume
    ;;
esac
