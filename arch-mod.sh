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
        "Update Mirrors"                        "Update Mirrors" \
        "Update System"                         "Update System" \
        "Add Paru, Flatpak, & Dependencies"     "Will Automatically Reboot After" \
        "Applications"                     "Install Applications and Utilities" \
        "Hyprland"                              "This Will Install Hyprland & All Dependencies" \
        "Gnome Extensions"                      "My Favorite Gnome Shell Extensions" \
        "Piercing Gimp"                         "Piercing Gimp Presets (Distro Agnostic)" \
        "PiercingXX Rice"                       "Apply Piercing Rice (Distro Agnostic)" \
        "Beautiful Bash"                        "Chris Titus' Beautiful Bash Script" \
        "Surface Kernel"                        "Install Surface Kernal" \
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
        "Update Mirrors")
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
            ;;
        "Update System")
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
            #Which DE are we in?
                if pgrep -x "Hyprland" > /dev/null; then
                # We are in Hyprland
                    echo "Running Hyprland updates..."
                    hyprpm update
                    wait
                    hyprpm reload
                fi
            echo -e "${GREEN}System Updated Successfully!${NC}"
            ;;
        "Add Paru, Flatpak, & Dependencies"*)
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
            echo "# Enabling Bluetooth and Printer services..."
            # Enable Bluetooth
            sudo systemctl start bluetooth
            systemctl enable bluetooth
            # Enable Printer 
            sudo pacman -S cups gutenprint cups-pdf gtk3-print-backends nmap net-tools cmake meson cpio --noconfirm
            systemctl enable cups.service
            systemctl start cups
            msg_box "System will reboot now. Re-run the script after reboot to continue."
            sudo reboot
            ;;
        "Hyprland"*)
            echo -e "${YELLOW}Installing Hyprland & Dependencies...${NC}"
                cd scripts || exit
                chmod u+x hyprland-install.sh
                ./hyprland-install.sh
                cd "$builddir" || exit
            echo -e "${GREEN}Installed successfully!${NC}"
            ;;     
        "Applications")
            echo -e "${YELLOW}Installing Core Applications...${NC}"
                cd scripts || exit
                chmod u+x apps.sh
                ./apps.sh
                cd "$builddir" || exit
            echo -e "${GREEN}Core Apps Installed successfully!${NC}"
            ;;
        "Gnome Extensions"*)
            echo -e "${YELLOW}Installing Gnome Extensions...${NC}"
                paru -S gnome-shell-extension-appindicator-git --noconfirm
                paru -S gnome-shell-extension-app-icons-taskbar --noconfirm
                paru -S gnome-shell-extension-blur-my-shell-git --noconfirm
                paru -S gnome-shell-extension-just-perfection-desktop --noconfirm
                paru -S gnome-shell-extension-pop-shell-git --noconfirm
                paru -S gnome-shell-extension-space-bar-git --noconfirm
                paru -S gnome-shell-extension-useless-gaps-git --noconfirm
                paru -S gnome-shell-extension-caffeine-git --noconfirm
                paru -S gnome-shell-extension-gsconnect --noconfirm
            echo -e "${GREEN}Gnome Extensions Installed successfully!${NC}"
            ;;   
        "Piercing Gimp")
            # Gimp Dots
                echo -e "${YELLOW}Installing Piercing Gimp Presets...${NC}"
                if git clone https://github.com/Piercingxx/gimp-dots.git; then
                    chmod -R u+x gimp-dots
                    chown -R "$username":"$username" gimp-dots
                    sudo rm -Rf /home/"$username"/.var/app/org.gimp.GIMP/config/GIMP/*
                    sudo rm -Rf /home/"$username"/.config/GIMP/*
                    mkdir -p /home/"$username"/.config/GIMP/3.0
                    chown -R "$username":"$username" /home/"$username"/.config/GIMP
                    cd gimp-dots/Gimp || exit
                    cp -Rf 3.0/* /home/"$username"/.config/GIMP/3.0
                    chown "$username":"$username" -R /home/"$username"/.config/GIMP
                    cd "$builddir" || exit
                    echo -e "${GREEN}Piercing Gimp Presets Installed Successfully!${NC}"
                else
                    echo -e "${RED}Failed to clone gimp-dots repository${NC}"
                fi
            ;;
        "PiercingXX Rice")
            echo -e "${YELLOW}Downloading and Applying PiercingXX Rice...${NC}"
                # .config Dot Files
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
                        cd "$builddir" || exit
                # Add in backgrounds and themes and apply them
                rm -rf piercing-dots
            echo -e "${GREEN}PiercingXX Rice Applied Successfully!${NC}"
            ;;
        "Beautiful Bash")
            echo -e "${YELLOW}Installing Beautiful Bash...${NC}"
                git clone https://github.com/christitustech/mybash
                    chmod -R u+x mybash
                    chown -R "$username":"$username" mybash
                    cd mybash || exit
                    /setup.sh
                    cd "$builddir" || exit
                    rm -rf mybash
            ;;
        "Surface Kernel")
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
                paru -Syu
                paru -Sy libwacom-surface --noconfirm
                sudo pacman -Syu
                sudo pacman -S linux-surface linux-surface-headers iptsd --noconfirm
                sudo pacman -S linux-firmware-marvell --noconfirm
                sudo pacman -S linux-surface-secureboot-mok --noconfirm
                paru -S surface-dtx-daemon
                systemctl enable surface-dtx-daemon.service
                systemctl --user surface-dtx-userd.service
                sudo touch /boot/loader/entries/surface.conf
                    cat /boot/loader/entries/surface.conf >> /boot/loader/entries/surface.conf
                    echo "
                    title Arch Surface
                    linux /vmlinuz-linux-surface
                    initrd  /initramfs-linux-surface.img
                    options root=LABEL=arch rw"
            ;;
        "Reboot System")
            echo -e "${YELLOW}Rebooting system in 5 seconds...${NC}"
            sleep 5
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