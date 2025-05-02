#!/bin/bash
# GitHub.com/PiercingXX

username=$(id -u -n 1000)
builddir=$(pwd)



# All Core Applications
    sudo pacman -S mpd --noconfirm
    paru -S mpv --noconfirm
    flatpak install flathub com.mattjakeman.ExtensionManager -y
    paru -S waterfox-bin --noconfirm
    paru -S pacseek --noconfirm
    paru -S dconf --noconfirm
    paru -S fuzzel --noconfirm
    paru -S ranger --noconfirm
    paru -S nautilus-renamer --noconfirm
    paru -S nautilus-open-any-terminal --noconfirm
    paru -S code-nautilus-git --noconfirm
    paru -S kitty --noconfirm
    paru -S mission-center --noconfirm
    sudo pacman -S python --noconfirm
    sudo pacman -S reflector --noconfirm
    paru -S obsidian --noconfirm
    paru -S libreoffice-fresh --noconfirm
# Gimp & Darktable
    paru -S gimp --noconfirm
    paru -S darktable --noconfirm
    paru -S opencl-amd --noconfirm
# Synology
    paru -S synochat --noconfirm
    paru -S synology-drive --noconfirm
    #Synology Drive doesnt support wayland so run this..
    # shellcheck disable=SC2034
    QT_QPA_PLATFORM=xcb
# VS Code")
    paru -S visual-studio-code-bin --noconfirm
    paru -S github-desktop-bin --noconfirm
# Fonts/Icons/Cursors
    echo -e "${YELLOW}Installing fonts, icons, and cursors...${NC}"
        mkdir -p "$HOME"/.fonts
        chmod -R u+x "$HOME"/.fonts
        chown -R "$username":"$username" "$HOME"/.fonts
        cd "$HOME"/.fonts || exit
        wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
        unzip FiraCode.zip
        wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
        unzip Meslo.zip
        rm Firacode.zip
        rm Meslo.zip
        cd "$builddir" || exit
    paru -S papirus-icon-theme --noconfirm
    paru -S ttf-firacode --noconfirm
    paru -S awesome-terminal-fonts --noconfirm
    paru -S ttf-ms-fonts --noconfirm
    paru -S terminus-font-ttf --noconfirm
    paru -S noto-color-emoji-fontconfig --noconfirm
    paru -S wtype-git --noconfirm
    paru -S xcursor-simp1e-gruvbox-light --noconfirm
    # Fuzzmoji
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