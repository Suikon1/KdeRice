#!/bin/bash
# Script para cambiar wallpaper aleatorio en KDE Plasma

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Obtener lista de imágenes
IMAGES=($(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) 2>/dev/null))

if [ ${#IMAGES[@]} -eq 0 ]; then
    exit 1
fi

# Seleccionar uno aleatorio
RANDOM_IMG="${IMAGES[$RANDOM % ${#IMAGES[@]}]}"

# Aplicar wallpaper usando qdbus
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var allDesktops = desktops();
for (var i = 0; i < allDesktops.length; i++) {
    var d = allDesktops[i];
    d.wallpaperPlugin = 'org.kde.image';
    d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
    d.writeConfig('Image', 'file://$RANDOM_IMG');
}
"
