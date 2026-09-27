function pacup
    if test (uname -o 2>/dev/null) = Android
        pkg upgrade
    else
        paru --sync --refresh --sysupgrade
    end

    pnpm update --global
    skills update --global
end
