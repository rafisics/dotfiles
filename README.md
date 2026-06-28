# dotfiles

Personal dotfiles for Ubuntu GNOME (X11), managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install on a fresh machine

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

Then follow [SETUP.md](system/SETUP.md) (if present) or `ubuntu-setup` repo for manual steps.

## Packages

| Package | What it configures | Docs |
|---|---|---|
| `bash` | `.bashrc`, `.bash_profile`, `.bash_logout`, `.stow-global-ignore` | — |
| `git` | `.gitconfig` (identity, credential helper) | — |
| `nvim` | Neovim (NvChad) + `nvim.fish` helper functions | [nvim/README.md](nvim/README.md) |
| `fish` | Fish shell — config, functions, variables | [fish/README.md](fish/README.md) |
| `starship` | Three prompt configs, switch with `starships` | [starship/README.md](starship/README.md) |
| `kitty` | Kitty terminal | — |
| `rofi` | Rofi launcher + rofi-zotero | [rofi/README.md](rofi/README.md) |
| `zathura` | Zathura PDF viewer + themes | — |
| `yazi` | Yazi file manager (catppuccin theme) | — |
| `btop` | btop resource monitor | — |
| `i3` | i3 WM *(archived — not stowed on GNOME)* | [Shortcuts](system/KEYBOARD-SHORTCUTS.md#i3) |
| `polybar` | Polybar *(archived — not stowed on GNOME)* | — |
| `picom` | Picom compositor *(archived — not stowed on GNOME)* | — |

## Documentation

| Doc | Contents |
|---|---|
| [nvim/README.md](nvim/README.md) | Plugin list, all key mappings, config switching |
| [fish/README.md](fish/README.md) | All custom fish commands with usage |
| [rofi/README.md](rofi/README.md) | Rofi setup + rofi-zotero integration |
| [system/KEYBOARD-SHORTCUTS.md](system/KEYBOARD-SHORTCUTS.md) | GNOME + fish + nvim keyboard shortcuts |

## System setup

`system/` contains:
- `dpkg/manual-packages.txt` — manually installed packages
- `gnome/` — GNOME dconf exports (full settings, keybindings, extensions)
- `img/` — screenshots of GNOME extension settings

Restore GNOME settings on a new machine:
```bash
# All keybindings at once
dconf load /org/gnome/desktop/wm/keybindings/       < system/gnome/keybindings/wm.dconf
dconf load /org/gnome/shell/keybindings/            < system/gnome/keybindings/shell.dconf
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < system/gnome/keybindings/media-keys.dconf

# Full GNOME settings (careful — overwrites everything)
dconf load /org/gnome/ < system/gnome/full-settings.dconf
```

## Private git identity

`git/.gitconfig-private` is gitignored (holds your GitHub no-reply email).
Copy the example and fill it in:

```bash
cp git/.gitconfig-private.example git/.gitconfig-private
# edit git/.gitconfig-private with your email
stow git
```

## Adding a new app

```bash
mkdir -p <app>/.config/<app>
# copy config files in
stow <app>
```

To stow a WM package on an i3 machine:
```bash
stow i3 polybar picom
```
