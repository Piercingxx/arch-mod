#!/bin/bash
# GitHub.com/PiercingXX



# Blender
    paru -S blender --noconfirm
# Kdenlive
    paru -S kdenlive-git --noconfirm
# Steam
    sudo pacman -S steam --noconfirm
# Discord
    paru -S vesktop-bin --noconfirm
# Input Remapper
    paru -S input-remapper --noconfirm
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
