#!/bin/bash
# GitHub.com/PiercingXX

# Define colors for whiptail

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to cache sudo credentials
cache_sudo_credentials() {
    echo "Caching sudo credentials for script execution..."
    sudo -v
    # Keep sudo credentials fresh for the duration of the script
    (while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &)
}

# Checks for active network connection
if [[ -n "$(command -v nmcli)" && "$(nmcli -t -f STATE g)" != connected ]]; then
    awk '{print}' <<<"Network connectivity is required to continue."
    exit
fi

# Install required tools for TUI
if ! command -v whiptail &> /dev/null; then
    echo -e "${YELLOW}Installing whiptail...${NC}"
    pacman -S whiptail --noconfirm
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Cache sudo credentials
cache_sudo_credentials

# Function to display a message box
function msg_box() {
    whiptail --msgbox "$1" 0 0 0
}

# Function to display menu
function menu() {
    whiptail --backtitle "GitHub.com/PiercingXX" --title "Main Menu" \
        --menu "Run Options In Order:" 0 0 0 \
        "Step 1"                                "Will Automatically Reboot After" \
        "Step 2"                                "Apps, Utils, & Exts, Rice, GIMP-dots" \
        "Optional Surface Kernel"               "Install Microsoft Surface Kernal" \
        "Reboot System"                         "Reboot the system" \
        "Exit"                                  "Exit the script" 3>&1 1>&2 2>&3
}
# Main menu loop
while true; do
    clear
    echo -e "${BLUE}PiercingXX's Arch Mod Script${NC}"
    echo -e "${GREEN}Welcome ${username}${NC}\n"
    choice=$(menu)
    case $choice in
        "Step 1")
            echo -e "${YELLOW}Updating System...${NC}"
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
            # Copy maintenance-arch.sh to home directory
                cd scripts || exit
                cp -f maintenance-arch.sh /home/"$username"
                chown "$username":"$username" /home/"$username"/maintenance-arch.sh
                cd "$builddir" || exit
            echo -e "${GREEN}maintenance-arch.sh Copied To Home Directory${NC}"
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
            # Add Paru, Flatpak, & Dependencies
            echo -e "${YELLOW}Installing Paru, Flatpak, & Dependencies...${NC}"
                # Install dependencies
                echo "# Installing dependencies..."
                sudo pacman -S zip unzip gzip tar make --noconfirm
                # Clone and install Paru
                echo "# Cloning and installing Paru..."
                git clone https://aur.archlinux.org/paru-bin.git && cd paru-bin && makepkg -si --noconfirm && cd ..
                # Add Flatpak
                echo "# Installing Flatpak..."
                sudo pacman -S flatpak --noconfirm
                flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
                flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
            echo "# Enabling Bluetooth and Printer services..."
                # Enable Bluetooth
                sudo systemctl start bluetooth
                systemctl enable bluetooth
                # Enable Printer 
                sudo pacman -S cups gutenprint cups-pdf gtk3-print-backends nmap net-tools cmake meson cpio --noconfirm
                sudo systemctl enable cups.service
                sudo systemctl start cups
            # Install dconf
                paru -S dconf --noconfirm
            # Extensions Install
            echo -e "${YELLOW}Installing Gnome Extensions...${NC}"
                paru -S gnome-shell-extension-appindicator-git --noconfirm
                paru -S gnome-shell-extension-app-icons-taskbar --noconfirm
                paru -S gnome-shell-extension-blur-my-shell-git --noconfirm
                paru -S gnome-shell-extension-just-perfection-desktop --noconfirm
                paru -S gnome-shell-extension-pop-shell-git --noconfirm
                paru -S gnome-shell-extension-useless-gaps-git --noconfirm
                paru -S gnome-shell-extension-caffeine-git --noconfirm
                paru -S gnome-shell-extension-gsconnect --noconfirm
                paru -S gnome-shell-extension-vitals --noconfirm
                # Super Key
                # Workspace buttons with App Icons
            # Fonts
            echo -e "${YELLOW}Installing Fonts...${NC}"
                cd scripts || exit
                chmod u+x fonts.sh
                ./fonts.sh
                wait
                cd "$builddir" || exit
            # Piercings Gnome Customizations
                echo -e "${YELLOW}Applying PiercingXX Gnome Customizations...${NC}"
                if [ ! -d "piercing-dots" ] ; then
                    git clone https://github.com/Piercingxx/piercing-dots.git
                else
                    rm -rf piercing-dots
                    git clone https://github.com/Piercingxx/piercing-dots.git
                fi
                    chmod -R u+x piercing-dots
                    chown -R "$username":"$username" piercing-dots
                    cd piercing-dots || exit
                    cd scripts || exit
                    ./gnome-customizations.sh
                    wait
                    cd "$builddir" || exit
                    rm -rf piercing-dots
            msg_box "System will reboot now. Re-run the script after reboot to continue."
            sudo reboot
            ;;
        "Step 2")
            # App install
            echo -e "${YELLOW}Installing Core Applications...${NC}"
                cd scripts || exit
                chmod u+x apps.sh
                ./apps.sh
                wait
                cd "$builddir" || exit
            echo -e "${GREEN}Core Apps Installed successfully!${NC}"
            # Hyprland install
            echo -e "${YELLOW}Installing Hyprland & Dependencies...${NC}"
                cd scripts || exit
                chmod u+x hyprland-install.sh
                ./hyprland-install.sh
                cd "$builddir" || exit
            # Enable Bluetooth again
            sudo systemctl start bluetooth
            systemctl enable bluetooth
            echo -e "${GREEN}Installed successfully!${NC}"
            # Apply Piercing Rice
                echo -e "${YELLOW}Downloading and Applying PiercingXX Rice...${NC}"
                # .config Files
                echo -e "${YELLOW}Downloading PiercingXX Dot Files...${NC}"
                    git clone https://github.com/Piercingxx/piercing-dots.git
                        chmod -R u+x piercing-dots
                        chown -R "$username":"$username" piercing-dots
                        cd piercing-dots || exit
                        cp -Rf dots/* /home/"$username"/.config/
                        chown "$username":"$username" -R /home/"$username"/.config/*
                        cd "$builddir" || exit      
                    echo -e "${GREEN}PiercingXX Dot Files Applied Successfully!${NC}"
                # Piercings Gnome Customizations
                    echo -e "${YELLOW}Applying PiercingXX Gnome Customizations...${NC}"
                        cd piercing-dots || exit
                        cd scripts || exit
                        ./gnome-customizations.sh
                        wait
                        cd "$builddir" || exit
                # Add in backgrounds and themes and apply them
                    mkdir -p /home/"$username"/Pictures/backgrounds
                    chown -R "$username":"$username" /home/"$username"/Pictures/backgrounds
                    cp -Rf piercing-dots/backgrounds/* /home/"$username"/Pictures/backgrounds
                    chown -R "$username":"$username" /home/"$username"/Pictures/backgrounds
                    mkdir -p /home/"$username"/Pictures/profile-image
                    chown -R "$username":"$username" /home/"$username"/Pictures/profile-image
                    cp -Rf piercing-dots/profile-image/* /home/"$username"/Pictures/profile-image
                    chown -R "$username":"$username" /home/"$username"/Pictures/profile-images
                    cd "$builddir" || exit
                # Copy Refs to Download folder
                    cp -Rf piercing-dots/refs/* /home/"$username"/Downloads
                # Apply Gimp Dots
                    echo -e "${YELLOW}Installing Piercing Gimp Presets...${NC}"
                    rm -rf gimp-dots
                    if git clone https://github.com/Piercingxx/gimp-dots.git; then
                        chmod -R u+x gimp-dots
                        chown -R "$username":"$username" gimp-dots
                        cd ./gimp-dots || exit
                        ./gimp-mod.sh
                        cd "$builddir" || exit
                        rm -Rf gimp-dots
                        echo -e "${GREEN}Piercing Gimp Presets Installed Successfully!${NC}"
                    else
                        echo -e "${RED}Failed to clone gimp-dots repository${NC}"
                    fi
                # Apply Beautiful Bash
                    echo -e "${YELLOW}Installing Beautiful Bash...${NC}"
                    git clone https://github.com/christitustech/mybash
                        chmod -R u+x mybash
                        chown -R "$username":"$username" mybash
                        cd mybash || exit
                        ./setup.sh
                        wait
                        cd "$builddir" || exit
                        rm -rf mybash
                # Replace .bashrc
                    cp -Rf piercing-dots/bash/.bashrc /home/"$username"/
                    chown -R "$username":"$username" /home/"$username"/.bashrc
                    rm -Rf piercing-dots
                echo -e "${GREEN}PiercingXX Rice Applied Successfully!${NC}"
            msg_box "System will reboot now. Re-run the script after reboot to continue."
            sudo reboot
            ;;
        "Step 3")
            echo -e "${YELLOW}Reapplying Gnome Customizations...${NC}"
            # Piercings Gnome Customizations
                echo -e "${YELLOW}Applying PiercingXX Gnome Customizations...${NC}"
                if [ ! -d "piercing-dots" ] ; then
                    git clone https://github.com/Piercingxx/piercing-dots.git
                else
                    rm -rf piercing-dots
                    git clone https://github.com/Piercingxx/piercing-dots.git
                fi
                    chmod -R u+x piercing-dots
                    chown -R "$username":"$username" piercing-dots
                    cd piercing-dots || exit
                    cd scripts || exit
                    ./gnome-customizations.sh
                    wait
                    cd "$builddir" || exit
                    rm -rf piercing-dots
            ;;
        "Optional Surface Kernel")
            echo -e "${YELLOW}Microsoft Surface Kernel...${NC}"            
                curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
                    | sudo pacman-key --add -
                sudo pacman-key --finger 56C464BAAC421453
                sudo pacman-key --lsign-key 56C464BAAC421453
                    if [ -f "/etc/pacman.conf" ]; then
                        cat /etc/pacman.conf >> /etc/pacman.conf
                        echo "Server = https://pkg.surfacelinux.com/arch/" >> /etc/pacman.conf
                    else
                        echo "The file does not exist."
                    fi
                paru -Syu --noconfirm
                paru -Sy libwacom-surface --noconfirm
                sudo pacman -Syu --noconfirm
                sudo pacman -S linux-surface linux-surface-headers iptsd --noconfirm
                sudo pacman -S linux-firmware-marvell --noconfirm
                sudo pacman -S linux-surface-secureboot-mok --noconfirm
                paru -S surface-dtx-daemon --noconfirm
                systemctl enable surface-dtx-daemon.service
                systemctl --user surface-dtx-userd.service
                sudo touch /boot/loader/entries/surface.conf
                    cat /boot/loader/entries/surface.conf >> /boot/loader/entries/surface.conf
                    echo "
                    title Arch Surface
                    linux /vmlinuz-linux-surface
                    initrd  /initramfs-linux-surface.img
                    options root=LABEL=arch rw"
                echo -e "${GREEN}Microsoft Kernal Installed. Manually create a Boot Loader Entry then reboot!${NC}"
            ;;
        "Reboot System")
            echo -e "${YELLOW}Rebooting system in 3 seconds...${NC}"
            sleep 1
            reboot
            ;;
        "Exit")
            clear
            echo -e "${BLUE}Thank You Handsome!${NC}"
            exit 0
            ;;
    esac
    # Prompt to continue
    while true; do
        read -p "Press [Enter] to continue..." 
        break
    done
done
