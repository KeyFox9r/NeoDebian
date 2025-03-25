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
sudo apt install -y \
  build-essential curl wget git sudo ca-certificates \
  zsh unzip gpg lsb-release software-properties-common \
  bash-completion neofetch lsd

### --- VS CODE + PYCHARM INSTALL --- ###
echo "[+] Installing Visual Studio Code..."
wget -qO vscode.deb "https://update.code.visualstudio.com/latest/linux-deb-x64/stable"
sudo apt install -y ./vscode.deb && rm vscode.deb

echo "[+] Installing JetBrains Toolbox for PyCharm..."
wget -qO toolbox.tar.gz "https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.2.1.19922.tar.gz"
tar -xzf toolbox.tar.gz -C $INSTALL_DIR && rm toolbox.tar.gz
TOOLBOX_DIR=$(find $INSTALL_DIR -maxdepth 1 -type d -name "jetbrains-toolbox-*" | head -n 1)
$TOOLBOX_DIR/jetbrains-toolbox &

### --- GIT + GITHUB CLI --- ###
echo "[+] Installing GitHub CLI..."
type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
  https://cli.github.com/packages stable main" | \
  sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install gh -y

if [[ -n "$GITHUB_USERNAME" ]]; then
  gh auth login
  git config --global user.name "$GITHUB_USERNAME"
  git config --global user.email "$GITHUB_EMAIL"
fi

### --- ZSH + GARUDA STYLE TERMINAL --- ###
echo "[+] Setting up Zsh and aesthetic terminal..."
sudo apt install -y zsh fonts-powerline
chsh -s $(which zsh)

# Install Oh-My-Zsh
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
sed -i 's|ZSH_THEME=.*|ZSH_THEME=\"powerlevel10k/powerlevel10k\"|' ~/.zshrc

### --- KDE + PLASMA TOOLS --- ###
echo "[+] Installing KDE extras..."
sudo apt install -y \
  kde-spectacle ark dolphin-plugins filelight partitionmanager \
  ffmpegthumbs kdegraphics-thumbnailers

### --- FIRMWARE (OPTIONAL) --- ###
echo "[+] Installing firmware packages..."
sudo apt install -y firmware-linux firmware-misc-nonfree firmware-amd-graphics

### --- CLEANUP --- ###
echo "[+] Cleaning up..."
sudo apt autoremove -y && sudo apt clean

### --- DONE --- ###
echo -e "\n[✓] Setup complete! Please reboot and finish setting up JetBrains Toolbox."
echo -e "\n👉 You may want to configure GRUB and themes next."
echo -e "\n🚀 Happy hacking, dev! — Loki out."

exit 0
