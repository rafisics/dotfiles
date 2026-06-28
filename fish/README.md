# Fish shell config

Shell: [Fish](https://fishshell.com/) | Prompt: [Starship](../starship/README.md)

Config: `.config/fish/config.fish`  
Functions: `.config/fish/functions/`

## Shell behaviour

- `EDITOR` = `nvim`
- `zoxide` is lazy-initialized (replaces `cd` via `zoxide init fish --cmd cd`)
- Starship is initialized in the background on shell start
- `Ctrl+T` mapping removed (used by NvChad as terminal toggle)
- `Ctrl+A` → launches `nvims` config picker (defined in `nvim.fish`)
- Ruby gems path added if `bundle` is available
- Sources `~/.config/nvim.fish` on every interactive shell (nvim helper functions)

## Custom commands

### Neovim
| Command | What it does |
|---|---|
| `nvims` | fzf picker to switch between NvChad and NeoTeX configs |
| `nvim-tex` | Launch neovim with NeoTeX config directly |
| `upgrade_nvim` | Build and install neovim stable from source |
| `delete_nvim_local_cache` | Wipe `~/.local/share/nvim`, `~/.local/state/nvim`, `~/.cache/nvim` |

### Python environments
| Command | What it does |
|---|---|
| `py-coding` | Activate `~/.venvs/coding-env` |
| `py-nvim` | Activate `~/.venvs/nvim-env` (neovim Python provider) |

### Research / astrophysics
| Command | What it does |
|---|---|
| `load-astro` | Source `~/github/my-scripts/astro/astro.fish` (lazy-loads astrophysics environment). Prevents double-loading. |
| `arxiv` | Lazy-load and run arxiv helper from `~/github/my-scripts/arxiv/arxiv.fish` |

### System
| Command | What it does |
|---|---|
| `backup_packages` | Export dpkg package lists to `~/github/ubuntu-setup/dpkg/` (all, installed, manual) |
| `dump_gnome_settings` | Export GNOME dconf + keybindings to `~/github/ubuntu-setup/gnome/` |
| `load_gnome_settings` | Restore GNOME keybindings from `~/github/ubuntu-setup/gnome/` |
| `toggle_screen` | Extend screen via xrandr and start x11vnc for remote viewing of the right half |
| `warpcli` | fzf picker to connect/disconnect Cloudflare WARP |
| `fastfetch` | Wrapper around `fastfetch` — if a preset name is given (e.g. `fastfetch minimal`), loads `~/.config/fastfetch/presets/<name>.jsonc` |

### Utilities
| Command | What it does |
|---|---|
| `copy-last-output` | Re-runs the last command and copies its output (+ the command itself) to clipboard via `xclip` |
| `starships` | fzf picker to switch between starship prompt configs (see [starship docs](../starship/README.md)) |
| `y` | Yazi file manager wrapper — changes the shell's CWD to where you quit yazi |

## Dependencies for custom commands

| Command | Requires |
|---|---|
| `copy-last-output` | `xclip` |
| `toggle_screen` | `xrandr`, `x11vnc` |
| `warpcli` | `warp-cli` (Cloudflare WARP) |
| `load-astro`, `arxiv` | `~/github/my-scripts/` repo |
| `backup_packages`, `dump_gnome_settings`, `load_gnome_settings` | `~/github/ubuntu-setup/` repo |
| `y` | `yazi` |
| `starships` | `fzf` |
