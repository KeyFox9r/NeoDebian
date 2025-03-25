#!/bin/bash

### --- Neo Tokyo KDE Theming Setup --- ###

set -e

# Colors for output
green="\033[0;32m"
blue="\033[0;34m"
reset="\033[0m"

print_section() {
  echo -e "\n${blue}==> $1${reset}"
}

print_ok() {
  echo -e "${green}[OK]${reset} $1"
}

print_section "Updating system"
sudo apt update && sudo apt upgrade -y
print_ok "System updated"

print_section "Installing KDE Add-ons and Dependencies"
sudo apt install -y \
  kde-style-breeze \
  kde-config-gtk-style \
  qt5-style-kvantum \
  latte-dock \
  plasma-widgets-addons \
  sddm-theme-breeze \
  git wget curl unzip \
  qml-module-qtquick-controls \
  qml-module-qtquick-controls2 \
  qml-module-qtgraphicaleffects \
  qml-module-org-kde-kirigami2 \
  qml-module-qtquick-xmllistmodel
print_ok "Dependencies installed"

print_section "Setting up Neo Tokyo wallpaper"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
mkdir -p "$WALLPAPER_DIR"
wget -q -O "$WALLPAPER_DIR/neotokyo.jpg" "https://raw.githubusercontent.com/NeoDevian/postinstall/main/assets/neotokyo-wallpaper.jpg"
print_ok "Wallpaper downloaded"

print_section "Downloading Kvantum themes"
KVANTUM_DIR="$HOME/.themes"
mkdir -p "$KVANTUM_DIR"
git clone --depth=1 https://github.com/vinceliuice/Qogir-kde.git /tmp/Qogir-kde
/tmp/Qogir-kde/install.sh --theme dark --install-path "$KVANTUM_DIR"
print_ok "Kvantum theme applied"

print_section "Downloading KDE color schemes and icons"
git clone --depth=1 https://github.com/vinceliuice/Tela-icon-theme.git /tmp/Tela-icon-theme
/tmp/Tela-icon-theme/install.sh -a
print_ok "Icons installed"

print_section "Applying Theme Settings"
lookandfeeltool -a org.kde.breezedark.desktop || true
kwriteconfig5 --file kdeglobals --group General --key ColorScheme "BreezeDark"
kwriteconfig5 --file kdeglobals --group Icons --key Theme "Tela-dark"
kwriteconfig5 --file kdeglobals --group KDE --key LookAndFeelPackage "org.kde.breezedark.desktop"
print_ok "Plasma Look-and-Feel applied"

print_section "Setting Neo Tokyo wallpaper"
plasma-apply-wallpaperimage "$WALLPAPER_DIR/neotokyo.jpg" || echo "Please set wallpaper manually if plasma-apply-wallpaperimage isn't available"

print_section "Setup complete! Please reboot for all changes to take full effect."
