#!/bin/bash
# GitHub.com/PiercingXX

username=$(id -u -n 1000)
builddir=$(pwd)

# Create Directories if needed
    # font directory
        if [ ! -d "$HOME/.fonts" ]; then
            mkdir -p "$HOME/.fonts"
        fi
        chown -R "$username":"$username" "$HOME"/.fonts
    # icons directory
        if [ ! -d "$HOME/.icons" ]; then
            mkdir -p /home/"$username"/.icons
        fi
        chown -R "$username":"$username" /home/"$username"/.icons

# Install fonts
    cd "$HOME"/.fonts || exit
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
    unzip FiraCode.zip Meslo.zip
    sudo rm FiraCode.zip Meslo.zip
    cd "$builddir" || exit
    git clone https://codeberg.org/codingotaku/fuzzmoji.git
        cd fuzzmoji || exit
        sudo mkdir -p /usr/share/fuzzmoji/emoji-list
        chmod -R 777 /usr/share/fuzzmoji/emoji-list
        chown -R "$username":"$username" /usr/share/fuzzmoji/emoji-list
        sudo cp emoji-list /usr/share/fuzzmoji/emoji-list
        chmod -R 777 /usr/share/fuzzmoji/emoji-list
        chown -R "$username":"$username" /usr/share/fuzzmoji/emoji-list
        sudo cp fuzzmoji /usr/bin/fuzzmoji
        chmod -R 777 /usr/bin/fuzzmoji
        chown -R "$username":"$username" /usr/bin/fuzzmoji
        cd "$builddir" || exit
        sudo rm -R fuzzmoji
    paru -S ttf-firacode --noconfirm
    paru -S awesome-terminal-fonts-patched --noconfirm
    paru -S ttf-ms-fonts --noconfirm
    paru -S terminus-font-ttf --noconfirm
    paru -S noto-color-emoji-fontconfig --noconfirm
    paru -S wtype-git --noconfirm
    paru -S xcursor-simp1e-gruvbox-light --noconfirm
    # Reload Font
    fc-cache -vf
    wait


