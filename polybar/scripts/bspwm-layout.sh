#!/usr/bin/env sh

# bspc subscribe desktop_layout | while read -r line; do
#   if [ $(echo $line | awk '{print $(NF)}') == "monocle" ]; then
#     echo "M"
#   else
#     echo ""
#   fi
# done

bspc subscribe desktop_focus desktop_layout | while read -r line; do
  bspc query --tree --desktop \
    | jq -r 'if .layout == "monocle" then "M" else "" end'
done
