# Arch‑Mod

A streamlined installer for a fully‑featured Arch Linux workstation.  
Automates core package installation, GPU drivers, Surface kernel modules, Hyprland, and curated dotfiles.

---

## 📦 Features

- Installs GNOME, developer tools, and essential apps
- Optional NVIDIA driver and Microsoft Surface kernel support
- Hyprland Wayland session setup
- Applies [Piercing‑Dots](https://github.com/PiercingXX/piercing-dots) dotfiles and customizations
- Firewall configuration with UFW
- Flatpak integration and core desktop applications

---

## 🚀 Quick Start

```bash
git clone https://github.com/PiercingXX/arch-mod
cd arch-mod
chmod -R u+x scripts/
arch-mod.sh
```

---

## 🛠️ Usage

Run `./arch-mod.sh` and follow the menu prompts.  
Options include system install, NVIDIA drivers, Surface kernel, Hyprland, and reboot.

---

## 🔧 Optional Scripts

| Script                | Purpose                                 |
|-----------------------|-----------------------------------------|
| `scripts/apps.sh`     | Installs core desktop applications      |
| `scripts/hyprland-install.sh` | Installs Hyprland and dependencies |
| `scripts/nvidia.sh`   | Installs proprietary NVIDIA drivers     |
| `scripts/Surface.sh`  | Installs Microsoft Surface kernel       |

---

## 📄 License

MIT © PiercingXX  
See the LICENSE file for details.

---

## 🤝 Contributing

Fork, branch, and PR welcome.  
Keep scripts POSIX‑friendly and avoid hard‑coded paths.

---

## 📞 Support

*No direct support provided.*
```
