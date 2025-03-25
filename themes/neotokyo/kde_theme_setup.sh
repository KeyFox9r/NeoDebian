#!/bin/bash

### --- NeoDevian KDE Plasma Neon Tokyo Theme Setup --- ###
# This script deploys Latte Dock layout, Plasma panel config, and a glowing window decoration

set -e

### Paths
THEME_DIR="$HOME/.local/share/NeoDevianTheme"
LATTE_DIR="$HOME/.config/latte"
PLASMA_LOOK_AND_FEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
KWIN_DIR="$HOME/.local/share/aurorae/themes"

mkdir -p "$THEME_DIR"
mkdir -p "$LATTE_DIR"
mkdir -p "$PLASMA_LOOK_AND_FEEL_DIR"
mkdir -p "$KWIN_DIR"

### 1. Deploy Latte Dock Layout
cat > "$LATTE_DIR/NeoTokyo.latte" <<EOF
[Layout]
name=NeoTokyo
version=2

[Dock]
alignment=center
background=dynamic
hoverAction=raise
zoomLevel=0
launchers=applications:systemsettings.desktop,applications:org.kde.konsole.desktop,applications:org.kde.dolphin.desktop
EOF

### 2. Deploy Simple Plasma Panel Style
cat > "$THEME_DIR/plasma-panel.conf" <<EOF
[Containments][1][General]
showOnlyCurrentScreen=true
opacity=0.8
glowAnimation=true
panelHeight=34
EOF

### 3. Deploy KWin Aurorae Theme (glowing borders)
mkdir -p "$KWIN_DIR/NeoTokyoGlow"
cat > "$KWIN_DIR/NeoTokyoGlow/metadata.desktop" <<EOF
[Desktop Entry]
Name=NeoTokyo Glow
X-KDE-PluginInfo-Author=NeoDevian Team
X-KDE-PluginInfo-Name=NeoTokyoGlow
X-KDE-PluginInfo-Version=1.0
X-KDE-PluginInfo-License=MIT
X-KDE-PluginInfo-EnabledByDefault=true
EOF

cat > "$KWIN_DIR/NeoTokyoGlow/decoration.kwinrc" <<EOF
[General]
borderSize=Normal
glowColor=#ff55ff
glowStrength=0.4
EOF

### 4. Done!
echo "[+] NeoTokyo theme elements deployed."
echo "[!] To activate:"
echo "   - Import Latte layout from: $LATTE_DIR/NeoTokyo.latte"
echo "   - Apply Plasma config manually (System Settings → Plasma Tweaks)"
echo "   - Choose window decoration: 'NeoTokyo Glow'"

exit 0
