#!/bin/bash
# GitHub.com/PiercingXX

username=$(id -u -n 1000)
builddir=$(pwd)

# Define the whiptail checklist options
CHOICES=$(whiptail --title "Applications Installation" --checklist \
"Select applications to install" 0 0 0 \
"Core Apps" "Obsidian, Office, etc" ON \
"GIMP" "GIMP, Darktable" ON \
"Synology" "SynoChat & Synology Drive" ON \
"VSCode" "VS Code & GitHub Desktop" ON \
"Blender" "Blender" OFF \
"Kdenlive" "KdenLive" OFF \
"Steam" "Steam & Discord, etc" OFF \
"Docker" "Docker Desktop & Tools" OFF 3>&1 1>&2 2>&3)

# Check if user canceled the dialog
if [ $? -ne 0 ]; then
    echo "User canceled application selection"
    exit 1
fi

# Process the selections
for CHOICE in $CHOICES; do
    case $CHOICE in
        '"Core Apps"')
            flatpak install flathub com.mattjakeman.ExtensionManager -y
            paru -S dconf waterfox-bin pacseek mpd mpv fuzzel ranger kitty mission-center python obsidian libreoffice-fresh code-nautilus-git nautilus-open-any-terminal nautilus-renamer --noconfirm
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
                paru -S papirus-icon-theme ttf-firacode awesome-terminal-fonts ttf-ms-fonts terminus-font-ttf noto-color-emoji-fontconfig wtype-git xcursor-simp1e-gruvbox-light --noconfirm
            # Reload Font
                fc-cache -vf
                wait
            ;;
        '"GIMP"')
            paru -S gimp darktable opencl-amd --noconfirm
            ;;
        '"Synology"')
            paru -S synochat synology-drive --noconfirm
            #Synology Drive doesnt support wayland so run this..
            QT_QPA_PLATFORM=xcb
            ;;
        '"VSCode"')
            paru -S visual-studio-code-bin github-desktop-bin --noconfirm
            ;;
        '"Blender"')
            paru -S blender --noconfirm
            ;;
        '"Kdenlive"')
            paru -S kdenlive --noconfirm
            ;;
        '"Steam"')
            sudo pacman -S steam --noconfirm
            paru -S discord vesktop-bin input-remapper --noconfirm
            ;;
        '"Docker"')
            # Docker
                wget https://download.docker.com/linux/static/stable/x86_64/docker-28.0.4.tgz -qO- | tar xvfz - docker/docker --strip-components=1
                sudo mv ./docker /usr/local/bin
                ##Download the latest from https://docs.docker.com/desktop/release-notes/
                git clone https://desktop.docker.com/linux/main/amd64/187762/docker-desktop-x86_64.pkg.tar.zst
                sudo pacman -U ./docker-desktop-x86_64.pkg.tar.zst
                #AI 
                curl -fsSL https://ollama.com/install.sh | sh
                #ollama pull gemma3:27b 
                #ollama pull deepseek-r1:7b
            #OpenWebUi
                docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
            ;;
    esac
done
