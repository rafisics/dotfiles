# Starship prompt

Three prompt configs in `.config/starship/`. Switch between them with the `starships` fish function.

## Switching prompts

```fish
starships    # fzf picker — select starship_1, starship_2, or starship_3
```

The selected config is saved as `$STARSHIP_CONFIG` (universal fish variable, persists across sessions).

## Configs

| File | Description |
|---|---|
| `starship_1.toml` | Config 1 |
| `starship_2.toml` | Config 2 |
| `starship_3.toml` | Config 3 |

To set a config permanently:
```fish
set -Ux STARSHIP_CONFIG ~/.config/starship/starship_1.toml
```
