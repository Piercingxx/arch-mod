#!/bin/bash
# GitHub.com/PiercingXX

# Define colors for whiptail

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
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

# Function to display a message box
function msg_box() {
    whiptail --msgbox "$1" 0 0 0
}

# Function to display menu
function menu() {
    whiptail --backtitle "GitHub.com/PiercingXX" --title "Main Menu" \
        --menu "Run Options In Order:" 0 0 0 \
        "Update System"                         "Update System" \
        "Update Mirrors"                        "Update Mirrors" \
        "Piercing Gimp"                         "Piercing Gimp Presets (Distro Agnostic)" \
        "PiercingXX Rice"                       "Apply Piercing Rice (Distro Agnostic)" \
        "Rice-No Hyprland"                      "Piercing Rice w/o Hyprdots but still Hypr Keybinds" \
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
        "Update Mirrors")
            echo -e "${YELLOW}Updating System...${NC}"
            # Check if reflector is installed
            if ! command_exists reflector; then
                echo "Reflector is not installed. Installing now..."
                # Attempt to install reflector using pacman
                sudo -v pacman -S reflector --noconfirm
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
        "Piercing Gimp")
            # Gimp Dots
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
                # Add in backgrounds and themes
                    mkdir -p /home/"$username"/Pictures/backgrounds
                    chown -R "$username":"$username" /home/"$username"/Pictures/backgrounds
                    cp -Rf piercing-dots/backgrounds/* /home/"$username"/Pictures/backgrounds
                    chown -R "$username":"$username" /home/"$username"/Pictures/backgrounds
                    mkdir -p /home/"$username"/Pictures/profile-image
                    chown -R "$username":"$username" /home/"$username"/Pictures/profile-image
                    cp -Rf piercing-dots/profile-image/* /home/"$username"/Pictures/profile-image
                    chown -R "$username":"$username" /home/"$username"/Pictures/profile-image
                    cd "$builddir" || exit
                # Copy Refs to Download folder
                    mkdir -p /home/"$username"/Downloads/refs
                    chown -R "$username":"$username" /home/"$username"/Downloads/refs
                    cp -Rf piercing-dots/refs/* /home/"$username"/Downloads/refs
                    chown -R "$username":"$username" /home/"$username"/Downloads/refs
                rm -rf piercing-dots
            echo -e "${GREEN}PiercingXX Rice Applied Successfully!${NC}"
            ;;
        "Rice-No Hyprland")
            echo -e "${YELLOW}Downloading and Applying PiercingXX Rice w/o Hyprdots...${NC}"
                # .config Dot Files
                echo -e "${YELLOW}Downloading PiercingXX Dot Files...${NC}"
                    git clone https://github.com/Piercingxx/piercing-dots.git
                        chmod -R u+x piercing-dots
                        chown -R "$username":"$username" piercing-dots
                        cp -Rf piercing-dots/dots/hypr/hyprland/keybinds.conf /home/"$username"/.config/hypr/hyprland
                        cd "$builddir" || exit
                        rm -Rf piercing-dots/dots/hypr/hyprland/*
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
                # Add in backgrounds and themes
                    mkdir -p /home/"$username"/Pictures/backgrounds
                    chown -R "$username":"$username" /home/"$username"/Pictures/backgrounds
                    cp -Rf piercing-dots/backgrounds/* /home/"$username"/Pictures/backgrounds
                    chown -R "$username":"$username" /home/"$username"/Pictures/backgrounds
                    mkdir -p /home/"$username"/Pictures/profile-image
                    chown -R "$username":"$username" /home/"$username"/Pictures/profile-image
                    cp -Rf piercing-dots/profile-image/* /home/"$username"/Pictures/profile-image
                    chown -R "$username":"$username" /home/"$username"/Pictures/profile-image
                    cd "$builddir" || exit
                # Copy Refs to Download folder
                    mkdir -p /home/"$username"/Downloads/refs
                    chown -R "$username":"$username" /home/"$username"/Downloads/refs
                    cp -Rf piercing-dots/refs/* /home/"$username"/Downloads/refs
                    chown -R "$username":"$username" /home/"$username"/Downloads/refs
                # Replace .bashrc
                    cp -Rf piercing-dots/bash/.bashrc /home/"$username"/
                    chown -R "$username":"$username" /home/"$username"/.bashrc
                rm -rf piercing-dots
            echo -e "${GREEN}PiercingXX Rice Applied Successfully!${NC}"
            ;;
        "Reboot System")
            echo -e "${YELLOW}Rebooting system in 3 seconds...${NC}"
            sleep 2
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
