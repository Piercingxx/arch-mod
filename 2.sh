#!/bin/bash

username=$(id -u -n 1000)
builddir=$(pwd)

# Checks for active network connection
if [[ -n "$(command -v nmcli)" && "$(nmcli -t -f STATE g)" != connected ]]; then
  awk '{print}' <<<"Network connectivity is required to continue."
  exit
fi

# Installs
pacman -S mpd --noconfirm
paru -Syu

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

# Applications
paru -S mpv --noconfirm
paru -S synochat --noconfirm
paru -S synology-drive --noconfirm
paru -S visual-studio-code-bin --noconfirm
paru -S mission-center --noconfirm
paru -S obsidian --noconfirm
paru -S libreoffice-fresh --noconfirm
paru -S kdenlive-git --noconfirm
# Gimp and GPU drivers for it
paru -S gimp-devel --noconfirm
paru -S opencl-amd --noconfirm

# Fonts & Icons & Cursors
mkdir -p $HOME/.fonts
chmod -R u+x $HOME/.fonts
chown -R "$username":"$username" $HOME/.fonts
cd $HOME/.fonts || exit
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
cd fuzzmoji
sudo mkdir -p /usr/share/fuzzmoji/emoji-list
sudo cp emoji-list /usr/share/fuzzmoji/emoji-list
sudo cp fuzzmoji /usr/bin/fuzzmoji
cd ..
sudo rm -R fuzzmoji

# Gimp dotfiles
git clone https://github.com/Piercingxx/gimp-dots.git
chmod -R u+x gimp-dots
chown -R "$username":"$username" gimp-dots
rm -Rf /home/"$username"/.var/app/org.gimp.GIMP/config/GIMP/*
rm -Rf /home/"$username"/.config/GIMP/*
mkdir /home/"$username"/.config/GIMP/3.0
chown -R "$username":"$username" /home/"$username"/.config/GIMP
cd gimp-dots/Gimp || exit
cp -R "3.0" /home/"$username"/.config/GIMP/
chown "$username":"$username" -R /home/"$username"/.config/GIMP
cd "$builddir" || exit

sudo reboot
