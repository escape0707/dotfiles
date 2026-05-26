#!/usr/bin/env bash
set -euo pipefail

configured_groups=('gnome' 'fcitx5-im')
installed_groups=()
group_packages=()

for group in "${configured_groups[@]}"; do
    mapfile -t packages < <(pacman -Qqg "$group" 2>/dev/null || true)
    if ((${#packages[@]} > 0)); then
        installed_groups+=("$group")
        group_packages+=("${packages[@]}")
    fi
done

comm -23 \
    <({ pacman -Qqe; printf '%s\n' "${installed_groups[@]}"; } | sort -u) \
    <(printf '%s\n' "${group_packages[@]}" | sort -u)
