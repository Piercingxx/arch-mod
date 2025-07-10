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
    # config directory
        if [ ! -d "$HOME/.config" ]; then
            mkdir -p /home/"$username"/.config
        fi
        chown -R "$username":"$username" /home/"$username"/.config
    # icons directory
        if [ ! -d "$HOME/.icons" ]; then
            mkdir -p /home/"$username"/.icons
        fi
        chown -R "$username":"$username" /home/"$username"/.icons
    # Background and Profile Image Directories
        if [ ! -d "$HOME/$username/Pictures/backgrounds" ]; then
            mkdir -p /home/"$username"/Pictures/backgrounds
        fi
        chown -R "$username":"$username" /home/"$username"/Pictures/backgrounds
        if [ ! -d "$HOME/$username/Pictures/profile-image" ]; then
            mkdir -p /home/"$username"/Pictures/profile-image
        fi
        chown -R "$username":"$username" /home/"$username"/Pictures/profile-image
    # fstab external drive mounting directory
        if [ ! -d "$HOME/.media/Working-Storage" ]; then
            mkdir -p /media/Working-Storage
        fi
        chown "$username":"$username" /home/"$username"/media/Working-Storage
        if [ ! -d "$HOME/.media/Archived-Storage" ]; then
            mkdir -p /media/Archived-Storage
        fi
        chown "$username":"$username" /home/"$username"/media/Archived-Storage

# Apps to Install
            flatpak install flathub com.mattjakeman.ExtensionManager -y
            flatpak install flathub net.waterfox.waterfox -y
            paru -S dconf --noconfirm
            paru -S pacseek --noconfirm
            paru -S mpd --noconfirm
            paru -S mpv --noconfirm
            paru -S fuzzel --noconfirm
            paru -S ranger --noconfirm
            paru -S kitty --noconfirm
            paru -S mission-center --noconfirm
            paru -S python --noconfirm
            paru -S obsidian --noconfirm
            paru -S libreoffice-fresh --noconfirm
            paru -S code-nautilus-git --noconfirm
            paru -S nautilus-open-any-terminal --noconfirm
            paru -S nautilus-renamer --noconfirm
            paru -S ulauncher --noconfirm
            #H265 support
                sudo pacman -S libde265 meson gst-plugins-bad ffnvcodec-headers --noconfirm
                # nvidia-vaapi-driver
                    git clone https://github.com/elFarto/nvidia-vaapi-driver.git
                    cd nvidia-vaapi-driver
                    meson setup build
                    meson install -C build
            # Install fonts and Themes
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
                paru -S papirus-icon-theme-git --noconfirm
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
# Gimp
            paru -S gimp --noconfirm
            paru -S darktable --noconfirm
            paru -S opencl-amd --noconfirm
# Synology
            paru -S synochat --noconfirm
            paru -S synology-drive --noconfirm
            #Synology Drive doesnt support wayland so run this..
            QT_QPA_PLATFORM=xcb
# VScode
            paru -S visual-studio-code-bin --noconfirm
            paru -S github-desktop-bin --noconfirm
# Blender
            paru -S blender --noconfirm
# Kdenlive
            paru -S kdenlive --noconfirm
# Steam
            sudo pacman -S steam --noconfirm
            paru -S discord --noconfirm
            paru -S input-remapper --noconfirm
# Tailscale
    curl -fsSL https://tailscale.com/install.sh | sh
# Ollama
    curl -fsSL https://ollama.com/install.sh | sh
# Docker
            # Docker
                wget https://download.docker.com/linux/static/stable/x86_64/docker-28.0.4.tgz -qO- | tar xvfz - docker/docker --strip-components=1
                sudo mv ./docker /usr/local/bin
                ##Download the latest from https://docs.docker.com/desktop/release-notes/
                git clone https://desktop.docker.com/linux/main/amd64/187762/docker-desktop-x86_64.pkg.tar.zst
                sudo pacman -U ./docker-desktop-x86_64.pkg.tar.zst --noconfirm
                #AI 
                curl -fsSL https://ollama.com/install.sh | sh
                #ollama pull gemma3:27b 
                #ollama pull deepseek-r1:7b
            #OpenWebUi
                docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
