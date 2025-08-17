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
        "Install"                               "Install PiercingXX Arch" \
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
        "Install")
            # Turn off sleep/suspend to avoid interruptions
                gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'false'
                gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'false'
                gsettings set org.gnome.settings-daemon.plugins.power idle-dim 'false'
            echo -e "${YELLOW}Installing Essentials...${NC}"
                cd scripts || exit
                chmod u+x step-1.sh
                ./step-1.sh
                wait
                cd "$builddir" || exit
            echo -e "${GREEN}Essentials Installed successfully!${NC}"
            # Apply Piercing Rice
                echo -e "${YELLOW}Applying PiercingXX Gnome Customizations...${NC}"
                rm -rf piercing-dots
                git clone --depth 1 https://github.com/Piercingxx/piercing-dots.git
                cd piercing-dots || exit
                chmod u+x install.sh
                ./install.sh
                wait
                cd "$builddir" || exit
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
            echo -e "${GREEN}Hyprland & Dependencies Installed successfully!${NC}"
            # Enable Bluetooth again
                sudo systemctl start bluetooth
                systemctl enable bluetooth
            # Apply Piercing Gnome Customizations as User
                cd piercing-dots/scripts || exit
                ./gnome-customizations.sh
                wait
                cd "$builddir" || exit
                rm -rf piercing-dots
            echo -e "${GREEN}PiercingXX Gnome Customizations Applied successfully!${NC}"
            msg_box "System will reboot now."
            sudo reboot
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
