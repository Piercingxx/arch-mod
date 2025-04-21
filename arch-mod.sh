#!/bin/bash

# GitHub.com/PiercingXX

# Define colors for whiptail

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
        --menu "Choose an option:" 0 0 0 \
        "Update System"                         "Update Mirrors & The System" \
        "Add Paru, Flatpak, & Dependencies"     "Install Paru, Flatpak, and Dependencies" \
        "Applications"                          "Install Applications and Utilities" \
        "Hyprland"                              "This Will Install Hyprland & All Dependencies" \
        "Gnome Extensions"                      "Install Gnome Shell Extensions" \
        "Piercing Rice"                         "Apply All My Customizations" \
        "Surface Kernel"                        "Install Surface Kernal" \
        "Reboot System"                         "Reboot the system" \
        "Exit"                                  "Exit the script" 3>&1 1>&2 2>&3
}

# Main menu loop
while true; do
    clear
    echo -e "${BLUE}Arch Mod Script${NC}"
    echo -e "${GREEN}Welcome ${username}${NC}\n"
    
    choice=$(menu)
    case $choice in
        "Update System")
            echo -e "${YELLOW}Finding The Fastest Mirrors then Updating, Be Patient...${NC}"
            # Update mirrors
            sudo reflector --verbose --sort rate -l 75 --save /etc/pacman.d/mirrorlist
            paru -Syu
            wait
            hyprpm update
            hyprpm reload
            msg_box "Mirrors & System Updated Successfully!"
            ;;
        "Add Paru, Flatpak, & Dependencies"*)
                if [[ $EUID -eq 0 ]]; then
                echo "This script should not be executed as root! Exiting......."
                exit 1
                fi
            echo -e "${YELLOW}Installing Paru, Flatpak, & Dependencies...${NC}"
            # Install dependencies
            sudo pacman -S zip unzip gzip tar make --noconfirm
            # Clone and install Paru
            git clone https://aur.archlinux.org/paru-bin.git && cd paru-bin && makepkg -si --noconfirm && cd ..
            # Add Flatpak
            sudo pacman -S flatpak --noconfirm
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            # Enable Bluetooth
            sudo systemctl start bluetooth
            systemctl enable bluetooth
            # Enable Printer 
            sudo pacman -S cups gutenprint cups-pdf gtk3-print-backends nmap net-tools cmake meson cpio --noconfirm
            systemctl enable cups.service
            systemctl start cups
            msg_box "Installed successfully! Rebooting now. Re-run script after reboot"
            sudo reboot
            ;;
        "Hyprland"*)
            echo -e "${YELLOW}Installing Hyprland & Dependencies...${NC}"
                paru -S hyprland-meta-git --noconfirm
                paru -S hyprpaper --noconfirm
                paru -S hyprlock --noconfirm
                paru -S hypridle --noconfirm
                paru -S hyprcursor-git --noconfirm
                paru -S wlsunset-git --noconfirm 
                #Screenshot
                paru -S hyprshot --noconfirm
                #Clipboard Manager
                paru -S cliphist --noconfirm
                paru -S wl-clipboard --noconfirm
                #paru -S eww --noconfirm
                #Gnome customization tool
                paru -S dconf --noconfirm
                #Monitor locator
                paru -S nwg-displays --noconfirm
                # Waybar
                paru -S waybar --noconfirm
                # Menus
                paru -S nwg-drawer --noconfirm
                paru -S fuzzel --noconfirm
                #paru -S yad --noconfirm
                paru -S wlogout --noconfirm
                paru -S libdbusmenu-gtk3 --noconfirm
                # Notifications
                paru -S libnotify --noconfirm
                paru -S notification-daemon --noconfirm
                paru -S swaync --noconfirm
                paru -S polkit-gnome --noconfirm
                # File Explorer
                #paru -S xplr --noconfirm
                paru -S ranger --noconfirm
                paru -S nautilus --noconfirm
                paru -S nautilus-renamer --noconfirm
                paru -S nautilus-open-any-terminal --noconfirm
                paru -S code-nautilus-git --noconfirm
                #Wallpaper
                paru -S swww --noconfirm
                # Allows keybindings to dynamically change the color temperature and software brightness
                paru -S wl-gammarelay --noconfirm
                paru -S brightnessctl --noconfirm
                paru -S light --noconfirm
                # Audio
                paru -S pamixer --noconfirm
                paru -S cava --noconfirm
                paru -S wireplumber --noconfirm
                paru -S playerctl --noconfirm
                #paru -S sox --noconfirm
                # Pulse Audio Volume Control
                paru -S pavucontrol --noconfirm
                # Network and Bluetooth
                paru -S networkmanager --noconfirm
                paru -S network-manager-applet --noconfirm
                paru -S bluez --noconfirm
                paru -S bluez-uti --noconfirm
                paru -S blueman --noconfirm
                # GUI Interface to Customize Icons and Cursors and Stuff
                paru -S nwg-look --noconfirm
                # Dynamic Cursor
                hyprpm update
                hyprpm reload
                hyprpm add https://github.com/hyprwm/hyprland-plugins
                hyprpm add https://github.com/virtcode/hypr-dynamic-cursors
                hyprpm enable dynamic-cursors
                hyprpm enable hyprtrails
            ;;
        "Gnome Extensions"*)
                if [[ $EUID -eq 0 ]]; then
                echo "This script should not be executed as root! Exiting......."
                exit 1
                fi
            CHOICES=$(whiptail --separate-output --checklist "Choose options" 0 0 0 \
                    "App Indicator" "" ON \
                    "App Icon Taskbar" "" ON \
                    "Blur My Shell" "" On \
                    "Just Perfection" "" ON \
                    "Pop Shell" "" On \
                    "Space Bar" "" On \
                    "Useless Gaps" "" On \
                    "Caffeine" "" ON \
                    "GSConnect" "" On 3>&1 1>&2 2>&3)
                if [ -z "$CHOICE" ]; then
                    echo "No option was selected, hit Cancel or select an option"
                else
                    for CHOICE in $CHOICES; do
                    case "$CHOICE" in
                    "App Indicator")
                        paru -S gnome-shell-extension-appindicator-git --noconfirm
                        ;;
                    "App Icon Taskbar")
                        paru -S gnome-shell-extension-app-icons-taskbar --noconfirm
                        ;;
                    "Blur My Shell")
                        paru -S gnome-shell-extension-blur-my-shell-git --noconfirm
                        ;;
                    "Just Perfection")
                        paru -S gnome-shell-extension-just-perfection-desktop --noconfirm
                        ;;
                    "Pop Shell")
                        paru -S gnome-shell-extension-pop-shell-git --noconfirm
                        ;;
                    "Space Bar")
                        paru -S gnome-shell-extension-space-bar-git --noconfirm
                        ;;
                    "Useless Gaps")
                        paru -S gnome-shell-extension-useless-gaps-git --noconfirm
                        ;;
                    "Caffeine")
                        paru -S gnome-shell-extension-caffeine-git --noconfirm
                        ;;
                    "GSConnect")
                        paru -S gnome-shell-extension-gsconnect --noconfirm
                        ;;
                    esac
                done
                fi            
            msg_box "Gnome Shell Extensions & Customization installed successfully!"
            ;;
        
        "Applications")
                    CHOICES=$(whiptail --separate-output --checklist "Choose options" 0 0 0 \
                    "Core Applications" "" ON \
                    "Obsidian" "" ON \
                    "LibreOffice" "" ON \
                    "GIMP & Darktable" "" ON \
                    "Synology Chat" "" ON \
                    "Synology Drive" "" ON \
                    "VS Code" "VSCode & Github Desktop" ON \
                    "Fonts/Icons/Cursors" "Only Run Once" ON \
                    "Docker" "" OFF \
                    "Blender" "" OFF \
                    "Kdenlive" "This takes a very long time to install" OFF \
                    "Steam" "" OFF \
                    "Discord" "" OFF \
                    "Input Remapper" "" OFF 3>&1 1>&2 2>&3)
                if [ -z "$CHOICE" ]; then
                    echo "No option was selected, hit Cancel or select an option"
                else
                    for CHOICE in $CHOICES; do
                    case "$CHOICE" in
                    "Core Applications")
                        sudo pacman -S mpd --noconfirm
                        paru -S mpv --noconfirm
                        flatpak install flathub com.mattjakeman.ExtensionManager -y
                        paru -S waterfox-bin --noconfirm
                        paru -S pacseek --noconfirm
                        paru -S dconf --noconfirm
                        paru -S fuzzel --noconfirm
                        paru -S ranger --noconfirm
                        paru -S nautilus-renamer --noconfirm
                        paru -S nautilus-open-any-terminal --noconfirm
                        paru -S code-nautilus-git --noconfirm
                        paru -S kitty --noconfirm
                        paru -S mission-center --noconfirm
                        sudo pacman -S python --noconfirm
                        sudo pacman -S reflector --noconfirm
                        ;;
                    "Obsidian")
                        paru -S obsidian --noconfirm
                        ;;
                    "Libre Office")
                        paru -S libreoffice-fresh --noconfirm
                        ;;
                    "Gimp & Darktable")
                        paru -S gimp --noconfirm
                        paru -S darktable --noconfirm
                        paru -S opencl-amd --noconfirm
                        ;;
                    "Synology Chat")
                        paru -S synochat --noconfirm
                        ;;
                    "Synology Drive")
                        paru -S synology-drive --noconfirm
                        #Synology Drive doesnt support wayland so run this..
                        # shellcheck disable=SC2034
                        QT_QPA_PLATFORM=xcb
                        ;;
                    "VS Code")
                        paru -S visual-studio-code-bin --noconfirm
                        paru -S github-desktop-bin --noconfirm
                        ;;
                    "Fonts/Icons/Cursors")
                        echo -e "${YELLOW}Installing fonts, icons, and cursors...${NC}"
                        mkdir -p "$HOME"/.fonts
                        chmod -R u+x "$HOME"/.fonts
                        chown -R "$username":"$username" "$HOME"/.fonts
                        cd "$HOME"/.fonts || exit
                        wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
                        unzip FiraCode.zip
                        wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
                        unzip Meslo.zip
                        rm Firacode.zip
                        rm Meslo.zip
                        cd "$builddir" || exit
                        paru -S papirus-icon-theme --noconfirm
                        paru -S ttf-firacode --noconfirm
                        paru -S awesome-terminal-fonts --noconfirm
                        paru -S ttf-ms-fonts --noconfirm
                        paru -S terminus-font-ttf --noconfirm
                        paru -S noto-color-emoji-fontconfig --noconfirm
                        paru -S wtype-git --noconfirm
                        paru -S xcursor-simp1e-gruvbox-light --noconfirm
                        # Fuzzmoji
                        git clone https://codeberg.org/codingotaku/fuzzmoji.git
                        cd fuzzmoji || exit
                        sudo mkdir -p /usr/share/fuzzmoji/emoji-list
                        sudo cp emoji-list /usr/share/fuzzmoji/emoji-list
                        sudo cp fuzzmoji /usr/bin/fuzzmoji
                        cd ..
                        sudo rm -R fuzzmoji
                        ;;
                    "Docker")
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
                    "Blender")
                        paru -S blender --noconfirm
                        ;;
                    "Kdenlive")
                        paru -S kdenlive-git --noconfirm
                        ;;
                    "Steam")
                        sudo pacman -S steam --noconfirm
                        ;;
                    "Discord")
                        paru -S discord --noconfirm
                        ;;
                    "Input Remapper")
                        paru -S input-remapper --noconfirm
                        ;;
                esac
                done
                fi            
            msg_box "Selected Applications Installed Successfully!"
            ;;
        "Piercing Rice")
            echo -e "${YELLOW}Copying Dotfiles...${NC}"
            CHOICES=$(whiptail --separate-output --checklist "Choose options" 0 0 0 \
                    "Piercings Gnome Customizations" "" ON \
                    "Gimp Dots" "" ON \
                    ".config Dot Files" "" On 3>&1 1>&2 2>&3)
                if [ -z "$CHOICE" ]; then
                    echo "No option was selected, hit Cancel or select an option"
                else
                    for CHOICE in $CHOICES; do
                    case "$CHOICE" in
                    "Piercings Gnome Customizations")
                        gsettings set org.gnome.desktop.interface clock-format 24h
                        gsettings set org.gnome.desktop.interface clock-show-weekday true
                        gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true
                        gsettings set org.gnome.desktop.input-sources xkb-options "['caps:backspace']"
                        gsettings set org.gnome.desktop.peripherals.mouse.speed "0.11790393013100431"
                        gsettings set org.gnome.desktop.peripherals.mouse.accel-profile "'flat'"
                        dconf write /org/gnome/desktop/privacy/report-technical-problems 'false'
                        dconf write /org/gnome/desktop/wm/preferences/focus-mode 'mouse'
                        dconf write /org/gnome/desktop/peripherals/touchpad/accel-profile 'flat'
                        dconf write /org/gnome/desktop/interface/font-name 'MesloLGSDZ Nerd Font 11'
                        dconf write /org/gnome/desktop/interface/document-font-name 'FiraCode Nerd Font 11'
                        dconf write /org/gnome/desktop/interface/monospace-font-name 'Terminus (TTF) Medium 12'
                        dconf write /org/gnome/desktop/wm/preferences/button-layout 'appmenu:close'
                        dconf write /org/gnome/system/location/enabled 'false'
                        gsettings set org.gnome.desktop.interface color-scheme prefer-dark
                        gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
                        gsettings set org.gnome.desktop.interface show-battery-percentage true
                        gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
                        gsettings set org.gnome.settings-daemon.plugins.power idle-delay "uint32 900"
                        gsettings set org.gnome.desktop.session idle-delay 0
                        gsettings set org.gnome.desktop.interface enable-hot-corners false
                        gsettings set org.gnome.desktop.background picture-options 'spanned'
                        gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
                        gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic false
                        gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 20
                        gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 04
                        gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 2500
                        gsettings set org.gnome.mutter.wayland.keybindings.restore-shortcuts "['']" 
                        gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
                        gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
                        gsettings set org.gnome.desktop.peripherals.touchpad click-method 'areas'
                        gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
                        gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
                        gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'
                        gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
                        gsettings set org.gnome.shell favorite-apps "['waterfox.desktop', 'org.gnome.Nautilus.desktop', 'org.libreoffice.LibreOffice.writer.desktop', 'org.gnome.Calculator.desktop', 'md.obsidian.Obsidian.desktop', 'com.visualstudio.code.desktop', 'code.desktop', 'synochat.desktop', 'org.gimp.GIMP.desktop', 'org.blender.Blender.desktop']"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>c"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "flatpak run net.waterfox.waterfox"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Waterfox"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "kitty"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "kitty"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "<Super>W"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding "<Super>z"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command "nautilus --new-window"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name "Nautilus"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding "<Super>b"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command "flatpak run md.obsidian.Obsidian"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name "Obsisian"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ binding "<Control><Alt>Delete"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ command "flatpak run io.missioncenter.MissionCenter"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ name "Mission Center"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/ binding "<Super>period"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/ command "flatpak run com.tomjwatson.Emote"
                        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/ name "Emoji"
                        gsettings set org.gnome.desktop.wm.keybindings close "['<Super>Q']"
                        gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
                        gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
                        gsettings set com.github.stunkymonkey.nautilus-open-any-terminal flatpak system
                        dconf write /org/gnome/settings-daemon/plugins/media-keys/control-center "['<Super>s']"
                        dconf write /org/gnome/shell/keybindings/toggle-quick-settings "[]"
                        dconf write /org/gnome/shell/extensions/forge/keybindings/prefs-open "[]"
                        dconf write /org/gnome/settings-daemon/plugins/media-keys/logout "[]"
                        dconf write /org/gnome/settings-daemon/plugins/media-keys/screensaver "['<Super>Return']"
                        dconf write /org/gnome/shell/extensions/forge/move-pointer-focus-enabled 'true'
                        dconf write /org/gnome/shell/extensions/space-bar/shortcuts/open-menu "[]"
                        dconf write /org/gnome/shell/extensions/space-bar/shortcuts/enable-move-to-workspace-shortcuts 'true'
                        dconf write /org/gnome/desktop/interface/font-name 'MesloLGSDZ Nerd Font 11'
                        dconf write /org/gnome/desktop/interface/document-font-name 'FiraCode Nerd Font 11'
                        dconf write /org/gnome/desktop/interface/monospace-font-name 'Terminus (TTF) Medium 12'
                        dconf write /org/gnome/desktop/wm/preferences/button-layout 'appmenu:close'
                        dconf write /org/gnome/system/location/enabled 'false'
                        dconf write /org/gnome/desktop/privacy/report-technical-problems 'false'
                        gnome-extensions enable ubuntu-appindicators@ubuntu.com
                        gnome-extensions enable gsconnect@andyholmes.github.io
                        gnome-extensions enable awesome-tiles@velitasali.com
                        gnome-extensions enable aztaskbar@aztaskbar.gitlab.com
                        gnome-extensions enable blur-my-shell@aunetx
                        gnome-extensions enable caffeine@patapon.info
                        gnome-extensions enable just-perfection-desktop@just-perfection
                        gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
                        gnome-extensions enable forge@jmmaranan.com
                        gnome-extensions enable pop-shell@system76.com
                        gnome-extensions enable space-bar@luchrioh
                        gnome-extensions enable useless-gaps@pimsnel.com
                        dconf wrote /org/gnome/shell/extensions/useless-gaps/gap-size "20"
                        dconf write /org/gnome/shell/extensions/just-perfection/dash-icon-size "48"
                        dconf write /org/gnome/shell/extensions/just-perfection/animation "3"
                        dconf write /org/gnome/shell/extensions/just-perfection/startup-status "0"
                        dconf write /org/gnome/shell/extensions/just-perfection/app-menu-icon "false"
                        dconf write /org/gnome/shell/extensions/just-perfection/activities-button "false"
                        dconf write /org/gnome/shell/extensions/just-perfection/app-menu "false"
                        dconf write /org/gnome/shell/extensions/just-perfection/app-menu-label "false"
                        dconf write /org/gnome/shell/extensions/just-perfection/search "false"
                        dconf write /org/gnome/shell/extensions/just-perfection/theme "true"
                        dconf write /org/gnome/shell/extensions/caffeine/duration-timer "4"
                        dconf write /org/gnome/shell/extensions/awesome-tiles/gap-size-increments "1"
                        dconf write /org/gnome/shell/extensions/aztaskbar/favorites "false"
                        dconf write /org/gnome/shell/extensions/aztaskbar/main-panel-height "33"
                        dconf write /org/gnome/shell/extensions/aztaskbar/panel-on-all-monitors "false"
                        dconf write /org/gnome/shell/extensions/aztaskbar/show-panel-activities-button "false"
                        dconf write /org/gnome/shell/extensions/aztaskbar/icon-size "23"
                        dconf write /org/gnome/shell/extensions/blur-my-shell/brightness "1.0"
                        dconf write /org/gnome/shell/extensions/aztaskbar/indicator-color-focused "'rgb(246,148,255)'"
                        dconf write /org/gnome/shell/extensions/aztaskbar/indicator-color-running "'rgb(130,226,255)'"
                        dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-1 "'<Super><Shift>1'"
                        dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-10 "'<Super><Shift>0'"
                        dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-2 "'<Super><Shift>2'"
                        dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-3 "'<Super><Shift>3'"
                        dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-4 "'<Super><Shift>4'"
                        dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-5 "'<Super><Shift>5'"
                        dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-6 "'<Super><Shift>6'"
                        dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-7 "'<Super><Shift>7'"
                        dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-8 "'<Super><Shift>8'"
                        dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-9 "'<Super><Shift>9'"
                        dconf write /org/gnome/shell/extensions/space-bar/behavior/show-empty-workspaces 'false'
                        dconf write /org/gnome/shell/extensions/space-bar/behavior/toggle-overview 'false'
                        dconf write /org/gnome/shell/extensions/forge/stacked-tiling-mode-enabled 'false'
                        dconf write /org/gnome/shell/extensions/forge/tabbed-tiling-mode-enabled 'false'
                        dconf write /org/gnome/shell/extensions/forge/preview-hint-enabled 'false'
                        dconf write /org/gnome/shell/extensions/forge/window-gap-size 'uint32 7'
                        dconf write /org/gtk/gtk4/settings/color-chooser/selected-color "true, 1.0, 1.0, 1.0, 1.0"
                        ;;
                    "Gimp Dots")
                        git clone https://github.com/Piercingxx/gimp-dots.git
                            chmod -R u+x gimp-dots
                            chown -R "$username":"$username" gimp-dots
                            sudo rm -Rf /home/"$username"/.var/app/org.gimp.GIMP/config/GIMP/*
                            sudo rm -Rf /home/"$username"/.config/GIMP/*
                            mkdir /home/"$username"/.config/GIMP/3.0
                            chown -R "$username":"$username" /home/"$username"/.config/GIMP
                            cd gimp-dots/Gimp || exit
                            cp -R "3.0" /home/"$username"/.config/GIMP/3.0
                            chown "$username":"$username" -R /home/"$username"/.config/GIMP
                            cd "$builddir" || exit
                            ;;
                    ".config Dot Files")
                        git clone https://github.com/Piercingxx/piercing-dots.git
                            chmod -R u+x piercing-dots
                            chown -R "$username":"$username" piercing-dots
                            cp -Rf "piercing-dots" /home/"$username"/.config/
                            chown "$username":"$username" -R /home/"$username"/.config/*
                    esac
                done
                fi   
            msg_box "Piercing Rice Applied Successfully!"
                ;;

        "Surface Kernel")
            echo -e "${YELLOW}Installing Surface Kernel...${NC}"            
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
                echo -e "${BLUE}Thank you for using PiercingXXs Arch Setup Script!${NC}"
                exit 0
                ;;
    esac

    # Prompt to continue
    while true; do
        read -p "Press [Enter] to continue..." 
        break
    done
done