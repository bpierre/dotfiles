#!/bin/sh
# Float Firefox extension popups (e.g. Bitwarden) automatically.
#
# Firefox extension popups open as regular toplevel windows with no title,
# the same app_id as the main browser, and no distinguishing wayland property.
# The title is only set *after* creation, so sway's for_window rules can't
# catch them at the right time (causes a tiled→float flash).
#
# This script listens for new window events via sway IPC and immediately
# floats any firefox-nightly window that has no title (name == null),
# which matches extension popups at creation time.
# After a short delay (for Firefox to finish sizing), it clamps the height
# to the display height and centers the window.
#
# Started from sway config: exec ~/dotfiles/sway/float-firefox-popup.sh

swaymsg -t subscribe '["window"]' --monitor | while IFS= read -r event; do
  if printf '%s' "$event" | jq -e '
    .change == "new" and
    .container.app_id == "firefox-nightly" and
    .container.name == null
  ' > /dev/null 2>&1; then
    con_id=$(printf '%s' "$event" | jq '.container.id')
    swaymsg "[con_id=$con_id] floating enable, border pixel 2"
    sleep 0.3
    max_h=$(swaymsg -t get_outputs | jq '[.[] | select(.focused)] | .[0].rect.height - 120')
    cur_h=$(swaymsg -t get_tree | jq ".. | select(.id? == $con_id) | .rect.height")
    if [ "$cur_h" -gt "$max_h" ] 2>/dev/null; then
      swaymsg "[con_id=$con_id] resize set height ${max_h} px"
    fi
    swaymsg "[con_id=$con_id] move position center"
  fi
done
