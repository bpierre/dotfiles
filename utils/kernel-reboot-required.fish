#!/usr/bin/env fish

set --local notify_only false

if test (count $argv) -gt 0
    if test "$argv[1]" = --notify; and test (count $argv) -eq 1
        set notify_only true
    else
        echo 'Usage: kernel-reboot-required.fish [--notify]' >&2
        exit 2
    end
end

set --local kernel_package linux
set --local running_kernel (uname -r)
set --local installed_kernel (
    pacman -Ql $kernel_package 2>/dev/null \
        | string match --regex '/usr/lib/modules/[^/]+/vmlinuz$' \
        | string replace --regex '.*/modules/([^/]+)/vmlinuz$' '$1'
)

if test (count $installed_kernel) -ne 1
    echo "Could not determine the kernel installed by '$kernel_package'." >&2
    exit 2
end

if not $notify_only
    printf 'Running:   %s\n' $running_kernel
    printf 'Installed: %s\n' $installed_kernel
end

if test "$running_kernel" = "$installed_kernel"
    if not $notify_only
        echo 'Kernel is current; no kernel reboot is required.'
    end
    exit 0
end

if $notify_only
    printf 'Kernel reboot needed: %s → %s\n' $running_kernel $installed_kernel
else
    echo 'A newer kernel is installed; reboot when convenient.'
end
exit 1
