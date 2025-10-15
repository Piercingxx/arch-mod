#!/bin/bash
# GitHub.com/PiercingXX

username=$(id -u -n 1000)
builddir=$(pwd)

# Apps to Install
    paru -S fwupd --noconfirm
    paru -S w3m --noconfirm
    paru -Rs firefox --noconfirm
    paru -S dconf --noconfirm
    paru -S fuzzel --noconfirm
    paru -S kitty --noconfirm
    paru -S python --noconfirm
    paru -S npm --noconfirm
    paru -S nautilus-open-any-terminal --noconfirm
    paru -S nautilus-renamer --noconfirm
    paru -S ulauncher --noconfirm
    paru -S vlc --noconfirm
    paru -S ventoy-bin --noconfirm
    paru -S proton-vpn-gtk-app --noconfirm
    flatpak install flathub net.waterfox.waterfox -y
    flatpak install flathub md.obsidian.Obsidian -y
    flatpak install flathub org.libreoffice.LibreOffice -y
    flatpak install flathub org.gnome.SimpleScan -y
    flatpak install flathub org.blender.Blender -y
    flatpak install flathub com.mattjakeman.ExtensionManager -y
    flatpak install flathub org.qbittorrent.qBittorrent -y
    flatpak install flathub io.missioncenter.MissionCenter -y
    flatpak install flathub io.github.shiftey.Desktop -y
    flatpak install --noninteractive flathub io.github.realmazharhussain.GdmSettings -y
    flatpak install flathub com.flashforge.FlashPrint -y
    flatpak install flathub org.gnome.meld -y # For file comparison
    flatpak install flathub com.nextcloud.desktopclient.nextcloud -y
    flatpak install flathub com.github.xournalpp.xournalpp -y # For PDF annotation

# Firewall
    paru -S ufw --noconfirm
    sudo ufw allow OpenSSH

# Tailscale
    paru -S tailscale --noconfirm

# Yazi
    paru -S yazi-nightly-bin ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick --noconfirm
    ya pkg add dedukun/bookmarks
    ya pkg add yazi-rs/plugins:mount
    ya pack -a grappas/wl-clipboard

# Apps to uninstall
    sudo pacman -Rs gnome-console --noconfirm
    sudo pacman -Rs firefox --noconfirm

# Theme stuffs
    paru -S papirus-icon-theme-git --noconfirm

# Gimp
    flatpak install flathub org.gimp.GIMP -y
    flatpak install flathub org.darktable.Darktable -y
    paru -S opencl-amd --noconfirm

# Synology
    paru -S synochat --noconfirm
    paru -S synology-drive --noconfirm
    flatpak install flathub com.synology.synology-note-station -y
    #Synology Drive doesnt support wayland so run this...
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
    paru -S python-pynvim --noconfirm
    paru -S ueberzug --noconfirm
    paru -S lazygit --noconfirm
    paru -S sqlite --noconfirm
    sudo pacman -Fy pdflatex --noconfirm
    sudo npm install -g @mermaid-js/mermaid-cli
    sudo npm install -g  neovim
    python3 -m pip install --user --upgrade pynvim

# VScode
    paru -S visual-studio-code-bin --noconfirm
    paru -S code-nautilus-git --noconfirm

# Blender
    flatpak install flathub org.blender.Blender -y

# Kdenlive
    flatpak install flathub org.kde.kdenlive -y

# Steam
    sudo pacman -S steam --noconfirm
    paru -S discord-canary --noconfirm
    flatpak install flathub com.discordapp.Discord -y
    paru -S input-remapper --noconfirm

# Ollama
    curl -fsSL https://ollama.com/install.sh | sh
    #ollama pull gpt-oss:20b
    #ollama pull codellama:34b 
    #ollama pull mistral:7b 
    #ollama pull gemma3:27b-it-qat
    #ollama pull gemma3:12b

# Tailscale
    curl -fsSL https://tailscale.com/install.sh | sh
    wait

# Docker
    paru -S docker docker-compose --noconfirm
    sudo systemctl enable --now docker
    sudo usermod -aG docker $username

# OpenWebUi
#    docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
