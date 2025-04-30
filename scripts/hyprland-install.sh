#!/bin/bash
# GitHub.com/PiercingXX



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