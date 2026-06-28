# Rofi

[Rofi](https://github.com/davatorium/rofi) application launcher, configured with a custom theme and integrated with Zotero.

## Configs

| File | Purpose |
|---|---|
| `.config/rofi/config.rasi` | Default rofi config (theme, keybindings) |
| `.config/rofi/rofi-default.rasi` | Base theme file |
| `.config/rofi-zotero/rofi-zotero.py` | Zotero attachment launcher script |
| `.config/rofi-zotero/themes/` | Zotero-specific rofi themes |

## GNOME keybinding

| Shortcut | Action |
|---|---|
| `Super + Shift + P` | Launch rofi app picker (`rofi -show drun`) |
| `Super + Z` | Launch rofi-zotero picker |

## rofi-zotero

Searches your Zotero library and opens PDF/DjVu attachments directly from a rofi popup.

> For full Zotero setup context, see my blog post: [Becoming a Zoteroist](https://rafisics.github.io/posts/zotero/)

### Usage

```bash
# Simple launch (GNOME shortcut: Super+Z)
~/.config/rofi-zotero/rofi-zotero.py --rofi-args="-i -theme ~/.config/rofi-zotero/themes/zotero-theme.rasi"

# With a specific Zotero profile
~/.config/rofi-zotero/rofi-zotero.py -p myprofile

# See all options
~/.config/rofi-zotero/rofi-zotero.py --help
```

### Setup on a new machine

1. Install Zotero and ensure its SQLite database exists at `~/Zotero/zotero.sqlite`
2. The script auto-detects the default Zotero profile
3. Wire up the GNOME shortcut (see [KEYBOARD-SHORTCUTS.md](../system/KEYBOARD-SHORTCUTS.md)):
   ```
   Command: /home/<user>/.config/rofi-zotero/rofi-zotero.py --rofi-args="-i -theme /home/<user>/.config/rofi-zotero/themes/zotero-theme.rasi"
   Shortcut: Super+Z
   ```
4. Restore from dconf: `dconf load /org/gnome/settings-daemon/plugins/media-keys/ < ~/dotfiles/system/gnome/keybindings/media-keys.dconf`

### Requirements

- Python 3.7+
- `rofi`
- `zathura` (or any PDF viewer — configured inside `rofi-zotero.py`)
- Zotero with at least one attachment
