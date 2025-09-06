#!/bin/bash
# GitHub.com/PiercingXX

username=$(id -u -n 1000)
builddir=$(pwd)


install_zoxide() {
    if ! command_exists zoxide; then
        if ! curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh; then
            print_colored "$RED" "Something went wrong during zoxide install!"
            exit 1
        fi
    else
        printf "Zoxide already installed\n"
    fi
}

# Create Directories if needed
    echo -e "${YELLOW}Creating Necessary Directories...${NC}"
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
# System Update
        sudo pacman -Syu --noconfirm
# Install dependencies
        echo "# Installing dependencies..."
        sudo pacman -S reflector --noconfirm
        sudo pacman -S zip unzip gzip tar make wget tar fontconfig --noconfirm
# Add Paru, Flatpak, & Dependencies if needed
    echo -e "${YELLOW}Installing Paru, Flatpak, & Dependencies...${NC}"
        # Clone and install Paru
        echo "# Cloning and installing Paru..."
        git clone https://aur.archlinux.org/paru-bin.git && cd paru-bin && makepkg -si --noconfirm && cd ..
        # Add Flatpak
        echo "# Installing Flatpak..."
        sudo pacman -S flatpak --noconfirm
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
# Installing more Depends
        echo "# Installing more dependencies..."
        paru -S multitail --noconfirm
        paru -S dconf --noconfirm
        paru -S cpio cmake meson --nocofirm
    # Install bash stuff
        paru -S fastfetch --noconfirm
        paru -S tree --noconfirm
        paru -s bat --noconfirm
        paru -S bash-completion --noconfirm
        paru -S trash-cli --noconfirm
        paru -S fzf --noconfirm
        paru -S zoxide --noconfirm
        curl -sS https://starship.rs/install.sh | sh
        paru -S exa --noconfirm
# System Control Services
    echo "# Enabling Bluetooth and Printer services..."
    # Enable Bluetooth
        sudo systemctl start bluetooth
        systemctl enable bluetooth
    # Enable Printer 
        sudo pacman -S cups gutenprint cups-pdf gtk3-print-backends nmap net-tools cmake meson cpio --noconfirm
        sudo systemctl enable cups.service
        sudo systemctl start cups
# Fonts
    echo -e "${YELLOW}Installing Fonts...${NC}"
        cd scripts || exit
        chmod u+x fonts.sh
        ./fonts.sh
        wait
        cd "$builddir" || exit
# Extensions Install
    echo -e "${YELLOW}Installing Gnome Extensions...${NC}"
        paru -S gnome-shell-extension-appindicator-git --noconfirm
        paru -S gnome-shell-extension-blur-my-shell-git --noconfirm
        paru -S gnome-shell-extension-just-perfection-desktop --noconfirm
        paru -S gnome-shell-extension-pop-shell-git --noconfirm
        paru -S gnome-shell-extension-useless-gaps-git --noconfirm
        paru -S gnome-shell-extension-caffeine-git --noconfirm
        paru -S gnome-shell-extension-gsconnect --noconfirm
        paru -S gnome-shell-extension-vitals --noconfirm
        # Workspaces Buttons with App Icons
            curl -L https://codeload.github.com/Favo02/workspaces-by-open-apps/zip/refs/heads/main -o workspaces.zip
            unzip workspaces.zip -d workspaces-by-open-apps-main
            chmod -R u+x workspaces-by-open-apps-main
            cd workspaces-by-open-apps-main/workspaces-by-open-apps-main || exit
            sudo ./install.sh local-install
            cd "$builddir" || exit
            rm -rf workspaces-by-open-apps-main
        # Nautilus Customization
            git clone https://github.com/Stunkymonkey/nautilus-open-any-terminal.git
            cd nautilus-open-any-terminal || exit
            make
            sudo make install schema
            sudo glib-compile-schemas /usr/share/glib-2.0/schemas
            cd "$builddir" || exit
            rm -rf nautilus-open-any-terminal
        # Super Key
            echo -e "${YELLOW}Installing Super‑Key extension...${NC}"
            git clone https://github.com/Tommimon/super-key.git
            cd super-key || exit
            ./build.sh -i
            EXT_BUILD_DIR="$builddir/super-key"
                if [ ! -d "$EXT_BUILD_DIR" ]; then
                    echo "Build output not found in $EXT_BUILD_DIR"
                    exit 1
                fi
            EXT_DIR="$HOME/.local/share/gnome-shell/extensions"
            EXT_ID="super-key@tommimon"   # <-- adjust if the folder name differs
            mkdir -p "$EXT_DIR"
            cp -r "$EXT_BUILD_DIR" "$EXT_DIR/$EXT_ID"
            cd "$builddir" || exit
            rm -rf super-key
    echo -e "${GREEN}Gnome Extensions Installed Successfully!${NC}"
# Apply Piercing Rice
    echo -e "${YELLOW}Applying PiercingXX Gnome Customizations...${NC}"
        rm -rf piercing-dots
        git clone --depth 1 https://github.com/Piercingxx/piercing-dots.git
        cd piercing-dots || exit
        chmod u+x install.sh
        ./install.sh
        cd "$builddir" || exit
        rm -rf piercing-dots
