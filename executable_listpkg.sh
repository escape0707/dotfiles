installed_groups=('gnome' 'fcitx5-im')
comm -23 <({ pacman -Qqe; printf "%s\n" "${installed_groups[@]}"; } | sort) <(pacman -Qqg $(printf " %s" "${installed_groups[@]}") | sort)

