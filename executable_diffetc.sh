#!/bin/bash
cd ~/.local/share/chezmoi/private_dot_config/etc 
find . -type f -exec nvim -d '{}' '/etc/{}' \;
