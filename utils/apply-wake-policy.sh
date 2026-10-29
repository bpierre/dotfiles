#!/usr/bin/env bash
# Install and apply the ThinkPad Z13 Gen 2 wake policy without suspending it.
set -euo pipefail

if (( EUID != 0 )); then
    echo 'Run with sudo: sudo bash ~/dotfiles/utils/apply-wake-policy.sh' >&2
    exit 1
fi

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for command in udevadm ethtool iw install; do
    command -v "$command" >/dev/null || {
        printf 'Required command is missing: %s\n' "$command" >&2
        exit 1
    }
done

touchpad=/sys/bus/i2c/devices/i2c-SNSL0028:00/power/wakeup
touchscreen=/sys/bus/i2c/devices/i2c-WACF2200:00/power/wakeup
audio=/sys/bus/pci/devices/0000:c3:00.5
for attribute in "$touchpad" "$touchscreen" "$audio/power/wakeup"; do
    [[ -w "$attribute" ]] || {
        printf 'Expected wake attribute is unavailable: %s\n' "$attribute" >&2
        exit 1
    }
done
if [[ $(< "$audio/vendor") != 0x1022 || $(< "$audio/device") != 0x15e2 ]]; then
    echo 'Audio device identity differs from the documented AMD coprocessor.' >&2
    exit 1
fi

rules=(80-disable-touch-wake.rules 80-disable-audio-wake.rules 90-disable-ethernet-wake.rules)
for rule in "${rules[@]}"; do
    udevadm verify "$repo_dir/udev/$rule"
done
for rule in "${rules[@]}"; do
    install -m 0644 "$repo_dir/udev/$rule" "/etc/udev/rules.d/$rule"
done
udevadm control --reload-rules

for attribute in "$touchpad" "$touchscreen" "$audio/power/wakeup"; do
    printf 'disabled\n' > "$attribute"
done

shopt -s nullglob
for interface in /sys/class/net/*; do
    driver=$(readlink -f "$interface/device/driver" || true)
    if [[ ${driver##*/} == r8152 ]]; then
        name=${interface##*/}
        ethtool -s "$name" wol d
        printf '\nEthernet %s:\n' "$name"
        ethtool "$name" | awk '/Wake-on:/'
    fi
done
for phy in /sys/class/ieee80211/phy*; do
    iw phy "${phy##*/}" wowlan disable
    iw phy "${phy##*/}" wowlan show
done

printf '\nWake permissions:\n'
printf 'Touchpad: %s\n' "$(< "$touchpad")"
printf 'Touchscreen/pen: %s\n' "$(< "$touchscreen")"
printf 'Audio coprocessor: %s\n' "$(< "$audio/power/wakeup")"
printf 'Built-in keyboard: %s\n' "$(< /sys/bus/serio/devices/serio0/power/wakeup)"
printf 'Lid: %s\n' "$(< /sys/bus/platform/devices/PNP0C0D:00/power/wakeup)"
printf 'Power button: %s\n' "$(< /sys/bus/platform/devices/PNP0C0C:00/power/wakeup)"
