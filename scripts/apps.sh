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
            mkdir -p /home/"$username"/media/Working-Storage
        fi
        chown "$username":"$username" /home/"$username"/media/Working-Storage
        if [ ! -d "$HOME/.media/Archived-Storage" ]; then
            mkdir -p /home/"$username"/media/Archived-Storage
        fi
        chown "$username":"$username" /home/"$username"/media/Archived-Storage

# Apps to Install
    paru -Rs firefox --noconfirm
    paru -S dconf --noconfirm
    paru -S pacseek --noconfirm
    paru -S mpd --noconfirm
    paru -S mpv --noconfirm
    paru -S fuzzel --noconfirm
    paru -S kitty --noconfirm
    paru -S python --noconfirm
    paru -S npm --noconfirm
    paru -S ranger --noconfirm
    paru -S code-nautilus-git --noconfirm
    paru -S nautilus-open-any-terminal --noconfirm
    paru -S nautilus-renamer --noconfirm
    paru -S ulauncher --noconfirm
    flatpak install flathub com.mattjakeman.ExtensionManager -y
    flatpak install flathub net.waterfox.waterfox -y
    flatpak install flathub md.obsidian.Obsidian -y
    flatpak install flathub org.libreoffice.LibreOffice -y
    flatpak install flathub org.darktable.Darktable -y
    flatpak install flathub org.qbittorrent.qBittorrent -y
    flatpak install flathub io.missioncenter.MissionCenter -y
    flatpak install flathub com.flashforge.FlashPrint -y

# Theme stuffs
    paru -S papirus-icon-theme-git --noconfirm
    paru -S xcursor-simp1e-gruvbox-light --noconfirm

###trialing installing fonts in step 1 instead of step 2
## Install fonts
#    echo "Installing Fonts"
#    cd "$builddir" || exit
#    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
#    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
#    wget http://www.i18nguy.com/unicode/andagii.zip
#    unzip FiraCode.zip -d /home/"$username"/.fonts
#    unzip Meslo.zip -d /home/"$username"/.fonts
#    unzip andagii.zip -d /home/"$username"/.fonts
#    sudo rm FiraCode.zip Meslo.zip andagii.zip
#    paru -S ttf-firacode --noconfirm
#    paru -S awesome-terminal-fonts-patched --noconfirm
#    paru -S ttf-ms-fonts --noconfirm
#    paru -S terminus-font-ttf --noconfirm
#    paru -S noto-color-emoji-fontconfig --noconfirm
#    paru -S wtype-git --noconfirm
#    paru -S xcursor-simp1e-gruvbox-light --noconfirm
#    # Reload Font
#    fc-cache -vf
#    wait

# Gimp
    flatpak install https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y
    flatpak install flathub org.darktable.Darktable -y
    paru -S opencl-amd --noconfirm

# Synology
    paru -S synochat --noconfirm
    paru -S synology-drive --noconfirm
    #Synology Drive doesnt support wayland so run this..
    QT_QPA_PLATFORM=xcb

# Nvim & Depends
    paru -Rs neovim --noconfirm
    paru -S neovim-nightly-bin --noconfirm
    sudo pacman -S nodejs npm --noconfirm
    sudo pacman -S ruby --noconfirm
    sudo pacman -S ripgrep --noconfirm
    paru -S luarocks --noconfirm
    paru -S lua51 --noconfirm
    paru -S python --noconfirm
    paru -S python-pip --noconfirm
    paru -S lazygit --noconfirm
    paru -S sqlite --noconfirm
    sudo pacman -Fy pdflatex --noconfirm
    sudo npm install -g @mermaid-js/mermaid-cli
    sudo npm install -g neovim
    python3 -m pip install --user --upgrade pynvim

# VScode
    paru -S visual-studio-code-bin --noconfirm
    paru -S github-desktop-bin --noconfirm

# Blender
    flatpak install flathub org.blender.Blender -y

# Kdenlive
    flatpak install flathub org.kde.kdenlive -y

# Steam
    sudo pacman -S steam --noconfirm
    flatpak install flathub com.discordapp.Discord -y
    paru -S input-remapper --noconfirm

# Ollama
    curl -fsSL https://ollama.com/install.sh | sh
    #ollama pull codellama:latest
    #ollama pull gemma3:12b
    #ollama pull gemma3n:latest

# Tailscale
#    curl -fsSL https://tailscale.com/install.sh | sh
#    wait

# Docker
#            # Docker
#                wget https://download.docker.com/linux/static/stable/x86_64/docker-28.0.4.tgz -qO- | tar xvfz - docker/docker --strip-components=1
#                sudo mv ./docker /usr/local/bin
#                ##Download the latest from https://docs.docker.com/desktop/release-notes/
#                git clone https://desktop.docker.com/linux/main/amd64/187762/docker-desktop-x86_64.pkg.tar.zst
#                sudo pacman -U ./docker-desktop-x86_64.pkg.tar.zst --noconfirm
#                #AI 
#                curl -fsSL https://ollama.com/install.sh | sh
#                #ollama pull gemma3:27b 
#                #ollama pull deepseek-r1:7b
#            #OpenWebUi
#                docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
