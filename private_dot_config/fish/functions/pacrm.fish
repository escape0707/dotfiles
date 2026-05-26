function pacrm
    paru --remove --recursive --nosave --unneeded (pacman --query --quiet --deps)
end
