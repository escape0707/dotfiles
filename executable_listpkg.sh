installed_groups=('gnome' 'fcitx5-im' 'texlive-most')
comm -23 <({ pacman -Qqtt; printf "%s\n" "${installed_groups[@]}"; } | sort) <(pacman -Qqg $(printf " %s" "${installed_groups[@]}") | sort)

