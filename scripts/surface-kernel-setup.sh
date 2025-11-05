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
sudo pacman -S --noconfirm linux-surface linux-surface-headers iptsd
# do not put --noconfirm on libwacom-surface
paru -S libwacom-surface
sudo pacman -S --noconfirm linux-firmware-marvell
sudo pacman -S --noconfirm linux-firmware-intel
sudo pacman -S --noconfirm linux-surface-secureboot-mok


# Update GRUB configuration
echo "\nUpdating GRUB configuration..."
if command -v grub-mkconfig &> /dev/null; then
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

# systemd-boot
if bootctl is-installed &>/dev/null; then
    echo "\nDetected systemd-boot. Attempting to create and set Surface kernel as default..."
    entries_dir="/boot/loader/entries"
    surface_entry=""
    # Try to find an existing entry
    for entry in "$entries_dir"/*.conf; do
        if grep -qi 'surface' "$entry"; then
            surface_entry="$(basename "$entry")"
            break
        fi
    done
    # If not found, create a new entry
    if [[ -z "$surface_entry" ]]; then
        echo "No Surface kernel loader entry found. Creating one..."
        # Find the latest installed surface kernel version
        kernel_img=$(ls /boot/vmlinuz-linux-surface* 2>/dev/null | head -n1)
        initrd_img=$(ls /boot/initramfs-linux-surface*.img 2>/dev/null | head -n1)
        if [[ -n "$kernel_img" && -n "$initrd_img" ]]; then
            surface_entry="linux-surface.conf"
            sudo tee "$entries_dir/$surface_entry" > /dev/null <<EOF
title   Microsoft Surface Linux
linux   ${kernel_img}
initrd  ${initrd_img}
options root=PARTUUID="$(blkid -s PARTUUID -o value $(findmnt / -o SOURCE -n))" rw quiet splash
EOF
            echo "Created $surface_entry in $entries_dir."
        else
            echo "Error: Could not find Surface kernel or initramfs in /boot. Aborting loader entry creation."
            surface_entry=""
        fi
    fi
    # Set as default if entry exists
    if [[ -n "$surface_entry" ]]; then
        sudo sed -i "/^default /d" /boot/loader/loader.conf 2>/dev/null
        echo "default  $surface_entry" | sudo tee -a /boot/loader/loader.conf
        echo "Set $surface_entry as the default boot entry for systemd-boot."
    else
        echo "Warning: No Surface kernel entry found or created in $entries_dir. Please check installation."
    fi
else
    echo "systemd-boot not detected or not installed. Skipping systemd-boot default kernel configuration."
fi

echo "\nSetup complete! Please reboot your system. After reboot, check your kernel with:"
echo "uname -a | grep surface"