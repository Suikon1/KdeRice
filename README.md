# KDE Plasma Rice - Windows 11 Style

Rice visual para KDE Plasma con estilo Windows 11.

![Arch Linux](https://img.shields.io/badge/Arch-Linux-blue?logo=archlinux)
![KDE Plasma](https://img.shields.io/badge/KDE-Plasma%206-blue?logo=kde)

## Instalación Rápida

```bash
git clone https://github.com/Suikon1/KdeRice.git
cd KdeRice
./install.sh
```

## Qué Incluye

| Componente | Tema |
|------------|------|
| Fuente | Segoe UI Variable |
| Plasma | Win11OS-dark |
| Iconos | Fluent |
| Cursor | Fluent-dark-cursors |
| GTK | Fluent-Dark |
| SDDM (Login) | win11-sddm-theme |
| Lock Screen | Win11OS + Segoe UI |
| Panel | Auto-hide + Floating |
| Fecha | dd/MM/yyyy |

## Requisitos

- Arch Linux (o derivados)
- KDE Plasma 6
- yay o paru (se instala automáticamente si no existe)

## Instalación Manual

Si prefieres instalar manualmente:

```bash
# Fuente
yay -S ttf-segoe-ui-variable

# Tema Plasma
yay -S win11os-kde-theme-git

# Iconos
yay -S fluent-icon-theme-git

# Cursores
yay -S fluent-cursor-theme-git

# GTK
yay -S fluent-gtk-theme-git

# SDDM
yay -S sddm-theme-win11
```

## Capturas

*Próximamente*

## Créditos

- [Win11OS-kde](https://github.com/yeyushengfan258/Win11OS-kde) - yeyushengfan258
- [Fluent-icon-theme](https://github.com/vinceliuice/Fluent-icon-theme) - vinceliuice
- [Fluent-gtk-theme](https://github.com/vinceliuice/Fluent-gtk-theme) - vinceliuice
