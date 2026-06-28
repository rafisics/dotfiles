# Keyboard Shortcuts

## GNOME custom keybindings

Set via **Settings → Keyboard → Custom Shortcuts**.  
Restore all at once: `dconf load /org/gnome/settings-daemon/plugins/media-keys/ < ~/dotfiles/system/gnome/keybindings/media-keys.dconf`

| Shortcut | Command | Description |
|---|---|---|
| `Super + Enter` | `kitty` | Open Kitty terminal |
| `Super + F` | `fsearch` | Open FSearch file search |
| `Super + G` | `google-chrome` | Google Chrome |
| `Super + B` | `brave-browser` | Brave Browser |
| `Super + E` | `nautilus` | File manager |
| `Super + Print` | `flameshot gui` | Screenshot (area select) |
| `Super + Shift + P` | `rofi -show drun` | App launcher (Rofi) |
| `Super + Z` | `rofi-zotero.py ...` | Zotero attachment picker |

## GNOME window manager keybindings

Restore: `dconf load /org/gnome/desktop/wm/keybindings/ < ~/dotfiles/system/gnome/keybindings/wm.dconf`

Standard GNOME WM shortcuts are preserved. See `system/gnome/keybindings/wm.dconf` for full list.

## GNOME shell keybindings

Restore: `dconf load /org/gnome/shell/keybindings/ < ~/dotfiles/system/gnome/keybindings/shell.dconf`

## Restore all GNOME keybindings at once

```bash
dconf load /org/gnome/desktop/wm/keybindings/       < ~/dotfiles/system/gnome/keybindings/wm.dconf
dconf load /org/gnome/terminal/legacy/keybindings/  < ~/dotfiles/system/gnome/keybindings/terminal.dconf
dconf load /org/gnome/shell/keybindings/            < ~/dotfiles/system/gnome/keybindings/shell.dconf
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < ~/dotfiles/system/gnome/keybindings/media-keys.dconf
```

Or use the fish function: `load_gnome_settings`

---

## Fish shell keybindings

| Shortcut | Action |
|---|---|
| `Ctrl + A` | Launch `nvims` — fzf neovim config picker |
| `Ctrl + T` | **Disabled** (used by NvChad as float terminal toggle) |

## Neovim keybindings

See [nvim/README.md](../nvim/README.md) for the full mapping table.

Key highlights:
| Key | Action |
|---|---|
| `Ctrl + \`` | Float terminal (fish, in current file's dir) |
| `Ctrl + P` | Telescope file finder |
| `Ctrl + /` | Toggle comment |
| `Space mm` | Toggle minimap |
| `Tab` / `Shift+Tab` | Next/prev buffer |
| `Shift + H/L` | Line start / end |

---

## i3 keybindings (archived — not active on GNOME)

> These are kept in `dotfiles/i3/` for reference or if switching to i3.  
> Config: `i3/.config/i3/config`

| Key | Action |
|---|---|
| `Mod + Enter` | Kitty terminal |
| `Mod + Q` | Close window |
| `Mod + D` | dmenu launcher |
| `Mod + H/V` | Split horizontal/vertical |
| `Mod + F` | Fullscreen toggle |
| `Mod + Shift + Space` | Float toggle |
| `Mod + 1–8` | Switch workspace |
| `Mod + Shift + 1–8` | Move window to workspace |
| `Mod + J/K/L/;` | Focus left/down/up/right |
| `XF86Audio*` | Volume up/down/mute/mic mute |
