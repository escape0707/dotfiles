function pacup
    sudo pacman --sync --refresh --sysupgrade
    pnpm update --global --latest
    skills update --global
end
