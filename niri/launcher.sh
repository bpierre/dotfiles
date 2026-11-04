#!/bin/sh
exec j4-dmenu-desktop --display-binary \
    --usage-log "$HOME/.config/j4-dmenu-desktop-usage-log.json" \
    --dmenu="bemenu --ignorecase --list 5 --no-overlap --width-factor 1 --line-height 24 -p '' --fn 'Iosevka Term 10' --hb '#000000FF' --ab '#000000FF' --fbb '#000000FF' --fb '#000000FF' --nb '#000000FF' --nf '#999999FF' --af '#999999FF' --hf '#FFFFFFFF'"
