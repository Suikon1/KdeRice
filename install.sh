#!/bin/bash

# KDE Rice Installer - Windows 11 Style
# Solo visual: temas, iconos, cursores, SDDM

set -e

echo "╔══════════════════════════════════════╗"
echo "║   KDE Rice Installer - Win11 Style   ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar si es Arch
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}Este script es solo para Arch Linux${NC}"
    exit 1
fi

# Verificar yay o paru
if command -v yay &> /dev/null; then
    AUR_HELPER="yay"
elif command -v paru &> /dev/null; then
    AUR_HELPER="paru"
else
    echo -e "${YELLOW}Instalando yay...${NC}"
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    AUR_HELPER="yay"
fi

echo -e "${GREEN}Usando $AUR_HELPER como AUR helper${NC}"
echo ""

# Instalar temas
echo -e "${YELLOW}[1/5] Instalando tema Plasma Win11OS...${NC}"
$AUR_HELPER -S --needed --noconfirm win11os-kde-theme-git 2>/dev/null || {
    echo "Instalando desde git..."
    git clone https://github.com/yeyushengfan258/Win11OS-kde.git /tmp/Win11OS-kde
    cd /tmp/Win11OS-kde
    ./install.sh
}

echo -e "${YELLOW}[2/5] Instalando iconos Fluent...${NC}"
$AUR_HELPER -S --needed --noconfirm fluent-icon-theme-git 2>/dev/null || {
    git clone https://github.com/vinceliuice/Fluent-icon-theme.git /tmp/Fluent-icon-theme
    cd /tmp/Fluent-icon-theme
    ./install.sh
}

echo -e "${YELLOW}[3/5] Instalando cursores Fluent...${NC}"
$AUR_HELPER -S --needed --noconfirm fluent-cursor-theme-git 2>/dev/null || {
    git clone https://github.com/vinceliuice/Fluent-cursor-theme.git /tmp/Fluent-cursor-theme
    cd /tmp/Fluent-cursor-theme
    ./install.sh
}

echo -e "${YELLOW}[4/5] Instalando tema GTK Fluent...${NC}"
$AUR_HELPER -S --needed --noconfirm fluent-gtk-theme-git 2>/dev/null || {
    git clone https://github.com/vinceliuice/Fluent-gtk-theme.git /tmp/Fluent-gtk-theme
    cd /tmp/Fluent-gtk-theme
    ./install.sh -c dark
}

echo -e "${YELLOW}[5/5] Instalando tema SDDM Win11...${NC}"
$AUR_HELPER -S --needed --noconfirm sddm-theme-win11 2>/dev/null || {
    git clone https://github.com/yeyushengfan258/sddm-win11-theme.git /tmp/sddm-win11-theme
    cd /tmp/sddm-win11-theme
    sudo ./install.sh
}

echo ""
echo -e "${YELLOW}Aplicando temas...${NC}"

# Aplicar tema Plasma
plasma-apply-lookandfeel -a com.github.yeyushengfan258.Win11OS-dark 2>/dev/null || true

# Aplicar iconos
plasma-apply-desktoptheme Win11OS-dark 2>/dev/null || true
/usr/lib/plasma-changeicons Fluent 2>/dev/null || true

# Aplicar cursor
plasma-apply-cursortheme Fluent-dark-cursors 2>/dev/null || true

# Configurar SDDM (requiere sudo)
echo -e "${YELLOW}Configurando SDDM...${NC}"
sudo mkdir -p /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=win11-sddm-theme" | sudo tee /etc/sddm.conf.d/theme.conf > /dev/null

echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         ¡Instalación completa!       ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo ""
echo "Temas instalados:"
echo "  • Plasma: Win11OS-dark"
echo "  • Iconos: Fluent"
echo "  • Cursor: Fluent-dark-cursors"
echo "  • GTK: Fluent-Dark"
echo "  • SDDM: win11-sddm-theme"
echo ""
echo -e "${YELLOW}Reinicia sesión o ejecuta:${NC}"
echo "  kquitapp6 plasmashell && kstart plasmashell"
echo ""
