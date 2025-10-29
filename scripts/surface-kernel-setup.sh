#!/bin/bash
# surface-kernel-setup.sh
# Automated setup script for Microsoft Surface kernel on Arch Linux
# This script must be run as root or with sudo

set -e

# Import linux-surface signing key
echo "Importing linux-surface signing key..."
curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc | sudo pacman-key --add -

# Verify fingerprint
echo "Verifying key fingerprint:"
sudo pacman-key --finger 56C464BAAC421453

# Locally sign the imported key
echo "Locally signing the key..."
sudo pacman-key --lsign-key 56C464BAAC421453

# Add linux-surface repository if not already present
if ! grep -q '\[linux-surface\]' /etc/pacman.conf; then
    echo "Adding linux-surface repository to /etc/pacman.conf..."
    echo -e '\n[linux-surface]\nServer = https://pkg.surfacelinux.com/arch/' | sudo tee -a /etc/pacman.conf
else
    echo "linux-surface repository already present in /etc/pacman.conf."
fi

# Update package lists
echo "Updating package lists..."
sudo pacman -Syu --noconfirm

# Install linux-surface kernel and dependencies
echo "Installing linux-surface kernel and dependencies..."
sudo pacman -S --noconfirm linux-surface linux-surface-headers iptsd

echo "\nIf you need libwacom-surface, install it from the AUR (e.g., with yay or paru)."
echo "yay -S libwacom-surface"

echo "\nIf you have a Surface Pro 4/5/6, Book 1/2, or Laptop 1/2, installing Marvell WiFi firmware..."
echo "sudo pacman -S --noconfirm linux-firmware-marvell"

echo "\nFor Intel camera firmware, run:"
echo "sudo pacman -S --noconfirm linux-firmware-intel"

echo "\nIf you have set up Secure Boot with SHIM, you can install the secureboot MOK package:"
echo "sudo pacman -S --noconfirm linux-surface-secureboot-mok"
echo "Follow the on-screen instructions and reboot to enroll the key."

echo "\nUpdating GRUB configuration..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "\nSetup complete! Please reboot your system. After reboot, check your kernel with:"
echo "uname -a | grep surface"