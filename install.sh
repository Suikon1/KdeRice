#!/bin/bash

# KDE Rice Installer - Windows 11 Style
# Visual: temas, iconos, cursores, SDDM, lock screen, formatos

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

# ============================================
# INSTALAR TEMAS
# ============================================

echo -e "${YELLOW}[1/6] Instalando fuente Segoe UI...${NC}"
$AUR_HELPER -S --needed --noconfirm ttf-segoe-ui-variable 2>/dev/null || {
    echo -e "${RED}No se pudo instalar Segoe UI, usando fuente alternativa${NC}"
}

echo -e "${YELLOW}[2/6] Instalando tema Plasma Win11OS...${NC}"
$AUR_HELPER -S --needed --noconfirm win11os-kde-theme-git 2>/dev/null || {
    echo "Instalando desde git..."
    git clone https://github.com/yeyushengfan258/Win11OS-kde.git /tmp/Win11OS-kde
    cd /tmp/Win11OS-kde
    ./install.sh
}

echo -e "${YELLOW}[3/6] Instalando iconos Fluent...${NC}"
$AUR_HELPER -S --needed --noconfirm fluent-icon-theme-git 2>/dev/null || {
    git clone https://github.com/vinceliuice/Fluent-icon-theme.git /tmp/Fluent-icon-theme
    cd /tmp/Fluent-icon-theme
    ./install.sh
}

echo -e "${YELLOW}[4/6] Instalando cursores Fluent...${NC}"
$AUR_HELPER -S --needed --noconfirm fluent-cursor-theme-git 2>/dev/null || {
    git clone https://github.com/vinceliuice/Fluent-cursor-theme.git /tmp/Fluent-cursor-theme
    cd /tmp/Fluent-cursor-theme
    ./install.sh
}

echo -e "${YELLOW}[5/6] Instalando tema GTK Fluent...${NC}"
$AUR_HELPER -S --needed --noconfirm fluent-gtk-theme-git 2>/dev/null || {
    git clone https://github.com/vinceliuice/Fluent-gtk-theme.git /tmp/Fluent-gtk-theme
    cd /tmp/Fluent-gtk-theme
    ./install.sh -c dark
}

echo -e "${YELLOW}[6/6] Instalando tema SDDM Win11...${NC}"
$AUR_HELPER -S --needed --noconfirm sddm-theme-win11 2>/dev/null || {
    git clone https://github.com/yeyushengfan258/sddm-win11-theme.git /tmp/sddm-win11-theme
    cd /tmp/sddm-win11-theme
    sudo ./install.sh
}

# ============================================
# APLICAR TEMAS
# ============================================

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

# ============================================
# CONFIGURAR LOCK SCREEN
# ============================================

echo -e "${YELLOW}Configurando lock screen...${NC}"

mkdir -p ~/.config

cat > ~/.config/kscreenlockerrc << 'EOF'
[Daemon]
Autolock=true
LockOnResume=true
Timeout=5

[Greeter]
Theme=com.github.yeyushengfan258.Win11OS-dark
WallpaperPlugin=org.kde.image

[Greeter][LnF][General]
font=Segoe UI Variable,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
showMediaControls=true
EOF

# ============================================
# CONFIGURAR FORMATO FECHA/HORA
# ============================================

echo -e "${YELLOW}Configurando formato de fecha (dd/MM/yyyy)...${NC}"

# Buscar y actualizar el reloj digital en el panel
if [ -f ~/.config/plasma-org.kde.plasma.desktop-appletsrc ]; then
    # Backup
    cp ~/.config/plasma-org.kde.plasma.desktop-appletsrc ~/.config/plasma-org.kde.plasma.desktop-appletsrc.bak

    # Agregar configuración de fecha al reloj (si existe la sección)
    if grep -q "plugin=org.kde.plasma.digitalclock" ~/.config/plasma-org.kde.plasma.desktop-appletsrc; then
        # Usar kwriteconfig6 para configurar el reloj
        kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
            --group "Containments" --group "2" --group "Applets" --group "21" --group "Configuration" --group "Appearance" \
            --key "customDateFormat" "dd/MM/yyyy" 2>/dev/null || true
        kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
            --group "Containments" --group "2" --group "Applets" --group "21" --group "Configuration" --group "Appearance" \
            --key "dateFormat" "custom" 2>/dev/null || true
        kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
            --group "Containments" --group "2" --group "Applets" --group "21" --group "Configuration" --group "Appearance" \
            --key "showDate" "true" 2>/dev/null || true
    fi
fi

# ============================================
# CONFIGURAR PANEL AUTO-HIDE
# ============================================

echo -e "${YELLOW}Configurando panel (auto-hide, floating)...${NC}"

if [ -f ~/.config/plasmashellrc ]; then
    cp ~/.config/plasmashellrc ~/.config/plasmashellrc.bak
fi

# Configurar panel para auto-hide
kwriteconfig6 --file ~/.config/plasmashellrc \
    --group "PlasmaViews" --group "Panel 2" \
    --key "floating" "1" 2>/dev/null || true
kwriteconfig6 --file ~/.config/plasmashellrc \
    --group "PlasmaViews" --group "Panel 2" \
    --key "panelVisibility" "1" 2>/dev/null || true

# ============================================
# FINALIZAR
# ============================================

echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         ¡Instalación completa!       ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo ""
echo "Temas instalados:"
echo "  • Fuente: Segoe UI Variable"
echo "  • Plasma: Win11OS-dark"
echo "  • Iconos: Fluent"
echo "  • Cursor: Fluent-dark-cursors"
echo "  • GTK: Fluent-Dark"
echo "  • SDDM: win11-sddm-theme"
echo ""
echo "Configuraciones aplicadas:"
echo "  • Lock screen: Win11OS theme + Segoe UI font"
echo "  • Fecha: dd/MM/yyyy (formato mundial)"
echo "  • Panel: auto-hide + floating"
echo ""
echo -e "${YELLOW}Reinicia sesión para aplicar todos los cambios${NC}"
echo ""
