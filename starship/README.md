# Starship prompt

Three prompt configs in `.config/starship/`. Switch between them with the `starships` fish function.

## Switching prompts

```fish
starships    # fzf picker — select starship_1, starship_2, or starship_3
```

The selected config is saved as `$STARSHIP_CONFIG` (universal fish variable, persists across sessions).

To set one permanently:
```fish
set -Ux STARSHIP_CONFIG ~/.config/starship/starship_1.toml
```

## Configs

| File | Style | Palette |
|---|---|---|
| `starship_1.toml` | Powerline segments | Catppuccin Mocha (peach → green → blue → pink) |
| `starship_2.toml` | Powerline segments | Nord-ish (dark navy → light blue → teal → steel blue) |
| `starship_3.toml` | Powerline segments | Gruvbox-ish (dark grey → olive green → steel blue → dark teal) |

All three configs show: OS icon → username → directory → git branch/status → docker/python context → time. Command duration on the right.
