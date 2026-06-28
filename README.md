# dotfiles

Personal dotfiles for Ubuntu GNOME (X11), managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install on a fresh machine

```bash
git clone https://github.com/rafisics/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

Then see [system/KEYBOARD-SHORTCUTS.md](system/KEYBOARD-SHORTCUTS.md) for GNOME keybinding restore and [system/dpkg/manual-packages.txt](system/dpkg/manual-packages.txt) for the package list.

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
| `i3` | i3 WM *(archived — not stowed on GNOME)* | [Shortcuts](system/KEYBOARD-SHORTCUTS.md#i3-keybindings-archived--not-active-on-gnome) |
| `polybar` | Polybar *(archived — not stowed on GNOME)* | — |
| `picom` | Picom compositor *(archived — not stowed on GNOME)* | — |

> i3/polybar/picom packages are kept for reference or non-GNOME machines. `install.sh` does not stow them by default.

## System setup

`system/` contains:
- `dpkg/manual-packages.txt` — manually installed packages
- `gnome/` — GNOME dconf exports (full settings, keybindings, extensions)
- `img/` — screenshots of GNOME extension settings
- `KEYBOARD-SHORTCUTS.md` — all keybindings documented

Restore GNOME keybindings on a new machine:
```bash
dconf load /org/gnome/desktop/wm/keybindings/       < system/gnome/keybindings/wm.dconf
dconf load /org/gnome/shell/keybindings/            < system/gnome/keybindings/shell.dconf
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < system/gnome/keybindings/media-keys.dconf
```

Or just run the fish function: `load_gnome_settings`

## Private git identity

`git/.gitconfig-private` is gitignored (holds your GitHub no-reply email).
Copy the example and fill it in:

```bash
cp git/.gitconfig-private.example git/.gitconfig-private
# edit with your email
stow git
```

## Adding a new app

```bash
mkdir -p <app>/.config/<app>
# copy config files in
stow <app>
```
