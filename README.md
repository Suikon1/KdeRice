# KDE Plasma Rice

Personal KDE Plasma 6 configuration backup with Windows 11 style theme.

## Contents

### Config Files (`.config/`)
- `plasma*` - Plasma shell, panel, applets, notifications
- `k*` - KDE global settings, shortcuts, kwin, lock screen
- `gtk-*` - GTK theme settings for Qt/KDE apps
- `autostart/` - Autostart entries

### Scripts (`.local/`)
- `bin/kde-random-wallpaper.sh` - Random wallpaper script
- `share/applications/kde-random-wallpaper.desktop` - Desktop entry for shortcut

## Key Features
- Win11OS-dark theme
- Auto-hide panel
- Custom keyboard shortcuts (Meta+B Firefox, Meta+Space Terminal, etc.)
- Random wallpaper on login
- Fingerprint authentication support

## Installation

```bash
cp -r .config/* ~/.config/
cp -r .local/* ~/.local/
```

## Shortcuts
- `Meta+Space` - Terminal (Ghostty)
- `Meta+E` - File Manager (Nemo)
- `Meta+B` - Firefox
- `Meta+Q` - Close window
- `Meta+L` - Lock screen
- `Meta+Shift+W` - Random wallpaper
- `Meta+Shift+C` - Claude Code
