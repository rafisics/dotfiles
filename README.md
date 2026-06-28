# dotfiles

Personal dotfiles for Ubuntu + i3, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package | What it configures |
|---|---|
| `bash` | `.bashrc`, `.bash_profile`, `.bash_logout` |
| `git` | `.gitconfig` (identity, credential helper, safe dirs) |
| `nvim` | Neovim (lazy.nvim) + `nvim.fish` shell functions |
| `fish` | Fish shell — `config.fish`, functions, `fish_variables` |
| `starship` | Three prompt configs (`starship_1–3.toml`), switch with `starships` |
| `kitty` | Kitty terminal |
| `i3` | i3 window manager + `adjust_brightness.sh` |
| `polybar` | Polybar status bar |
| `rofi` | Rofi launcher + rofi-zotero |
| `picom` | Picom compositor |
| `zathura` | Zathura PDF viewer + themes |
| `yazi` | Yazi file manager |
| `btop` | btop resource monitor |

## Install on a fresh machine

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

Then follow **SETUP.md** for manual steps (packages, GNOME settings, tools not in apt).

## Private git identity

`git/.gitconfig-private` is gitignored (it holds your GitHub no-reply email).
Copy the example and fill it in before stowing:

```bash
cp git/.gitconfig-private.example git/.gitconfig-private
# edit git/.gitconfig-private
stow git
```

## Credentials

`~/.git-credentials` is never committed. On a new machine, re-authenticate:
- GitHub: `gh auth login` (or create a PAT and let `git credential store` save it)
- Overleaf: push once — git will prompt and store via credential helper

## Adding a new app

```bash
mkdir -p <app>/.config/<app>
# copy config files in
stow <app>
```

## System setup

See `system/` for:
- `dpkg/manual-packages.txt` — manually installed packages
- `gnome/` — GNOME dconf exports, keybindings, extension settings

Restore GNOME settings on a new machine:
```bash
dconf load /org/gnome/ < system/gnome/full-settings.dconf
```
