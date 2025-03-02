#!/bin/bash

# https://github.com/Piercingxx

username=$(id -u -n 1000)

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

# Checks for active network connection
if [[ -n "$(command -v nmcli)" && "$(nmcli -t -f STATE g)" != connected ]]; then
    awk '{print}' <<< "Network connectivity is required to continue."
    exit
fi


curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
    | sudo pacman-key --add -


sudo pacman-key --finger 56C464BAAC421453

sudo pacman-key --lsign-key 56C464BAAC421453


  if [ -f "/etc/pacman.conf" ]; then
    cat /etc/pacman.conf >> /etc/pacman.conf
    echo "[linux-surface] Server = https://pkg.surfacelinux.com/arch/" >> /etc/pacman.conf
  else
    echo "The file does not exist."
  fi

paru -Syu
paru -Sy libwacom-surface

sudo pacman -Syu
sudo pacman -S linux-surface linux-surface-headers iptsd
sudo pacman -S linux-firmware-marvell
sudo pacman -S linux-surface-secureboot-mok


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


sudo reboot