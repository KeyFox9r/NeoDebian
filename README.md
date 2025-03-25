# Post-Install Script for Debian 12 + KDE

This script transforms a minimal Debian 12 KDE install into a gorgeous, developer-ready environment tailored for dual-boot setups with Secure Boot compatibility.

## Features

- Secure Boot compatible
- Full VS Code (Microsoft .deb) and PyCharm (via JetBrains Toolbox)
- Git + GitHub CLI
- Powerlevel10k ZSH terminal
- KDE tools (Partition Manager, Dolphin plugins)
- Optional firmware and GPU packages
- Prepared for custom bootloader integration (GRUB)
- Lightweight, non-bloated, and user-friendly

## Usage

After installing Debian and ensuring internet access, run:

```bash
bash <(curl -s https://raw.githubusercontent.com/YOUR_USERNAME/NeoDebian/main/loki-postinstall.sh)
```

> Replace `YOUR_USERNAME` with your actual GitHub username once forked or cloned.

## 🔐 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
