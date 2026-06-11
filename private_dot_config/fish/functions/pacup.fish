function pacup
    if test (uname -o 2>/dev/null) = Android
        pkg upgrade
    else
        sudo pacman --sync --refresh --sysupgrade
    end

    pnpm update --global --latest
    skills update --global
end
