#!/bin/sh
# Link the config and enable niri's companion services for the next login.
# Does not start services or change the running compositor.
set -eu
repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
units="$config_home/systemd/user"

niri validate -c "$repo/niri/config.kdl"

# Check all destinations before writing anything; never replace existing configs.
check_link() {
    if [ -e "$2" ] || [ -L "$2" ]; then
        if [ "$(readlink -f -- "$2")" != "$1" ]; then
            printf 'Existing destination needs review: %s\n' "$2" >&2
            exit 1
        fi
    fi
}
check_link "$repo/niri" "$config_home/niri"
for source in "$repo"/niri/systemd/*.service; do
    name=$(basename "$source")
    check_link "$source" "$units/$name"
    check_link "$source" "$units/niri.service.wants/$name"
done

mkdir -p "$units/niri.service.wants"
[ -L "$config_home/niri" ] || ln -s "$repo/niri" "$config_home/niri"
for source in "$repo"/niri/systemd/*.service; do
    name=$(basename "$source")
    [ -L "$units/$name" ] || ln -s "$source" "$units/$name"
    [ -L "$units/niri.service.wants/$name" ] || ln -s "$source" "$units/niri.service.wants/$name"
done
systemctl --user daemon-reload
printf 'Niri config linked; companion services enabled for the next Niri login.\n'
