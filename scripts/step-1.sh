#!/bin/bash
# GitHub.com/PiercingXX

username=$(id -u -n 1000)
builddir=$(pwd)

install_starship_and_fzf() {
    if ! command_exists starship; then
        if ! curl -sS https://starship.rs/install.sh | sh; then
            print_colored "$RED" "Something went wrong during starship install!"
            exit 1
        fi
    else
        printf "Starship already installed\n"
    fi

    if ! command_exists fzf; then
        if [ -d "$HOME/.fzf" ]; then
            print_colored "$YELLOW" "FZF directory already exists. Skipping installation."
        else
            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
            ~/.fzf/install
        fi
    else
        printf "Fzf already installed\n"
    fi
}

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
# Check if reflector is installed
    if ! command_exists reflector; then
        echo "Reflector is not installed. Installing now..."
        # Attempt to install reflector using pacman
        sudo pacman -S reflector --noconfirm
        # Check if the installation was successful
        if ! command_exists reflector; then
        echo "Failed to install reflector. Please check your pacman configuration and internet connection."
        exit 1  # Exit with an error code
        else
        echo "Reflector installed successfully."
        fi
    fi
    echo -e "${YELLOW}Finding The Fastest Mirrors then Updating, Be Patient...${NC}"
# Update mirrors
    sudo reflector --verbose --sort rate -l 75 --save /etc/pacman.d/mirrorlist
    echo -e "${GREEN}Mirrors Updated${NC}"
# System Update
    echo -e "${YELLOW}Updating System...${NC}"
    # Check if paru is installed
        if command_exists paru; then
            echo "Using paru for system update..."
            paru -Syu --noconfirm
        else
            echo "Paru not found, using pacman instead..."
            sudo pacman -Syu --noconfirm
        fi
        wait
    # Check if flatpak is installed and update it
        if command_exists flatpak; then
            echo "Updating flatpak packages..."
            flatpak update -y
        else
            echo "Flatpak is not installed."
        fi
        wait
    # Which DE are we in?
        if pgrep -x "Hyprland" > /dev/null; then
        # We are in Hyprland
            echo "Running Hyprland updates..."
            hyprpm update
            wait
            hyprpm reload
        fi
    echo -e "${GREEN}System Updated Successfully!${NC}"
# Add Paru, Flatpak, & Dependencies if needed
    echo -e "${YELLOW}Installing Paru, Flatpak, & Dependencies...${NC}"
        # Install dependencies
        echo "# Installing dependencies..."
        sudo pacman -S zip unzip gzip tar make wget bash bash-completion tar bat tree multitail fastfetch fontconfig trash-cli --noconfirm
        # Clone and install Paru
        echo "# Cloning and installing Paru..."
        git clone https://aur.archlinux.org/paru-bin.git && cd paru-bin && makepkg -si --noconfirm && cd ..
        # Add Flatpak
        echo "# Installing Flatpak..."
        sudo pacman -S flatpak --noconfirm
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
    echo "# Enabling Bluetooth and Printer services..."
# System Control Services
    # Enable Bluetooth
        sudo systemctl start bluetooth
        systemctl enable bluetooth
    # Enable Printer 
        sudo pacman -S cups gutenprint cups-pdf gtk3-print-backends nmap net-tools cmake meson cpio --noconfirm
        sudo systemctl enable cups.service
        sudo systemctl start cups
    # Install bash stuff
        install_starship_and_fzf
        install_zoxide
    # Install dconf
        paru -S dconf --noconfirm
# Extensions Install
    echo -e "${YELLOW}Installing Gnome Extensions...${NC}"
        paru -S gnome-shell-extension-appindicator-git --noconfirm
        #paru -S gnome-shell-extension-app-icons-taskbar --noconfirm
        paru -S gnome-shell-extension-blur-my-shell-git --noconfirm
        paru -S gnome-shell-extension-just-perfection-desktop --noconfirm
        paru -S gnome-shell-extension-pop-shell-git --noconfirm
        paru -S gnome-shell-extension-useless-gaps-git --noconfirm
        paru -S gnome-shell-extension-caffeine-git --noconfirm
        paru -S gnome-shell-extension-gsconnect --noconfirm
        paru -S gnome-shell-extension-vitals --noconfirm
        # Workspaces Buttons with App Icons
            git clone https://codeload.github.com/Favo02/workspaces-by-open-apps/zip/refs/heads/main
            unzip workspaces-by-open-apps-main.zip
            chmod -R u+x workspaces-by-open-apps-main
            cd workspaces-by-open-apps-main || exit
            sudo ./install.sh local-install
            cd "$builddir" || exit
            rm -rf workspaces-by-open-apps-main
        # Nautilus Customization
            git clone https://github.com/Stunkymonkey/nautilus-open-any-terminal.git
            cd nautilus-open-any-terminal || exit
            make
            sudo make install schema
            glib-compile-schemas /usr/share/glib-2.0/schemas
            cd "$builddir" || exit
            rm -rf nautilus-open-any-terminal
        # Super Key
            git clone https://github.com/Tommimon/super-key.git
            chmod -R u+x super-key
            cd super-key || exit
            ./build.sh -i
            cd "$builddir" || exit
            rm -rf super-key
    echo -e "${GREEN}Gnome Extensions Installed Successfully!${NC}"
# Fonts
    echo -e "${YELLOW}Installing Fonts...${NC}"
        cd scripts || exit
        chmod u+x fonts.sh
        ./fonts.sh
        wait
        cd "$builddir" || exit
# Apply Piercing Rice
    echo -e "${YELLOW}Applying PiercingXX Gnome Customizations...${NC}"
        rm -rf piercing-dots
        git clone --depth 1 https://github.com/Piercingxx/piercing-dots.git
        chmod -R u+x piercing-dots
        cd piercing-dots || exit
        ./install.sh
        cd "$builddir" || exit
        rm -rf piercing-dots