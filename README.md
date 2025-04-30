
### A script to setup my version of Arch Linux


I recommend running all the options in order. 

![image](https://github.com/user-attachments/assets/fc6daea2-52b3-4a35-800e-b685c96a3974)


- Update Mirrors will run Reflector and rate the fastest 75 mirrors.

- Update system will update the system using (and/or) paru/pacman/flatpak/hyprpm. Whatever is installed.

- Add Paru, Flatpak, & Dependencies will do just that. It will auto reboot the system after. Run the script again to run everything else.

- Core Applications will give you the option to install any of the applications I use.

- Hyprland will install Hyprland and all the dependencies for my build of Hyprland.
![image](https://github.com/user-attachments/assets/d8113c86-4985-420c-ba0d-fc519fe14478)

- Gnome Extensions will install all the Gnome Extensions I use.

- Piercing Gimp will download my version of Gimp with all its settings and plugins. 

- PiercingXX Rice will not only apply my custom Gnome settings (some of which carry over to Hyprland) but will also download my dot files and automatically apply them with force. (This does not make a backup of your current dot files. It will overwrite them.)

- Surface Kernel will install the Surface Kernel for any Microsoft Surface device.
      - This is setup for a systemd bootloader. You will have to go in and edit the boot entry to see the kernal listed.
      - This will also work with GRUB. You will have to edit the boot order for default boot.




## This script is for my personal use. It is not meant to be used as a template for your own build. However, if you do use it, I would love to hear about it and see your rice!!




##### Credits:
- The surface bits are from: https://github.com/linux-surface/linux-surface/wiki but compiled into this script by me.
