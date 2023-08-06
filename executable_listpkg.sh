installed_groups=('gnome' 'fcitx5-im')
comm -23 <({ pacman -Qqtt; printf "%s\n" "${installed_groups[@]}"; } | sort) <(pacman -Qqg $(printf " %s" "${installed_groups[@]}") | sort)

