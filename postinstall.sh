#!/bin/bash
# Post-Install Script for Debian 12 + KDE Minimal
# Purpose: Set up a dual-boot friendly, dev-ready, secure-boot compatible system
# Author: keyfox9er
# License: MIT

set -e

### --- USER CONFIGURATION --- ###
GITHUB_USERNAME=""
GITHUB_EMAIL=""
INSTALL_DIR="$HOME"

# Try to auto-fill from existing global Git config
[[ -z "$GITHUB_USERNAME" ]] && GITHUB_USERNAME=$(git config --global user.name)
[[ -z "$GITHUB_EMAIL" ]] && GITHUB_EMAIL=$(git config --global user.email)

# Ask only if still empty
if [[ -z "$GITHUB_USERNAME" || -z "$GITHUB_EMAIL" ]]; then
  read -p "Do you want to set up Git with your GitHub identity? [y/N]: " setup_git
  if [[ "$setup_git" =~ ^[Yy]$ ]]; then
    [[ -z "$GITHUB_USERNAME" ]] && read -p "Enter GitHub username: " GITHUB_USERNAME
    [[ -z "$GITHUB_EMAIL" ]] && read -p "Enter GitHub email: " GITHUB_EMAIL

    git config --global user.name "$GITHUB_USERNAME"
    git config --global user.email "$GITHUB_EMAIL"
    echo "Git config saved globally."
  else
    echo "Skipping GitHub configuration."
  fi
fi

### --- BASIC SYSTEM SETUP --- ###
echo "[+] Updating base system..."
sudo apt update && sudo apt upgrade -y

echo "[+] Installing essential tools..."
sudo apt install -y curl wget git neofetch unzip gnupg2 ca-certificates gpg lsb-release software-properties-common apt-transport-https

### --- GIT CONFIGURATION --- ###
echo "[+] Configuring Git..."
git config --global user.name "$GITHUB_USERNAME"
git config --global user.email "$GITHUB_EMAIL"

### --- INSTALL DEVELOPER TOOLS --- ###
echo "[+] Installing developer tools..."
# VS Code (Microsoft)
wget -qO vscode.deb "https://update.code.visualstudio.com/latest/linux-deb-x64/stable"
sudo apt install -y ./vscode.deb && rm vscode.deb

# JetBrains Toolbox (for PyCharm)
wget -qO toolbox.tar.gz "https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.28.1.15219.tar.gz"
tar -xzf toolbox.tar.gz && rm toolbox.tar.gz
TOOLBOX_DIR=$(find . -maxdepth 1 -type d -name "jetbrains-toolbox-*" | head -n 1)
"$TOOLBOX_DIR/jetbrains-toolbox" &

### --- INSTALL KDE COMPONENTS --- ###
echo "[+] Installing KDE Plasma components..."
sudo apt install -y kde-plasma-desktop sddm latte-dock qml-module-qtquick-controls2 kde-config-sddm

# Enable SDDM display manager
sudo systemctl enable sddm

### --- THEMING --- ###
echo "[+] Cloning NeoTokyo theming..."
mkdir -p "$INSTALL_DIR/.local/share/neotokyo"
git clone https://github.com/$GITHUB_USERNAME/NeoDevian "$INSTALL_DIR/.local/share/neotokyo"

# Autostart helper
mkdir -p "$HOME/.config/autostart"
cp "$INSTALL_DIR/.local/share/neotokyo/desktop/neotokyo.desktop" "$HOME/.config/autostart/neotokyo.desktop"

# Run theme setup
bash "$INSTALL_DIR/.local/share/neotokyo/themes/neotokyo/neotokyotheme.sh"

### --- FIX TRACKPAD TAP GESTURES --- ###
echo "[+] Enabling tap-to-click gestures..."
mkdir -p ~/.config/xorg
cat <<EOF > ~/.config/xorg/40-libinput.conf
Section "InputClass"
  Identifier "libinput touchpad catchall"
  MatchIsTouchpad "on"
  MatchDevicePath "/dev/input/event*"
  Driver "libinput"
  Option "Tapping" "on"
  Option "TappingButtonMap" "lmr"
EndSection
EOF

### --- CLEANUP --- ###
echo "[+] Cleaning up..."
sudo apt autoremove -y

### --- COMPLETE --- ###
echo "[✓] NeoDevian post-install complete. Please reboot your system!"
echo "[✓] If Latte Dock doesn't start, try running it manually or re-apply the theme."
