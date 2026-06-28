# NeoTeX (nvim-tex)

LaTeX-focused Neovim config. Based on [benbrastmckie/nvim](https://github.com/benbrastmckie/nvim).

Launched via `NVIM_APPNAME=nvim-tex` so it runs independently alongside the main NvChad config.

## Launch

```fish
nvim-tex     # launch directly
nvims        # fzf picker — choose NeoTeX from the list
Ctrl+A       # quick nvims picker from any fish prompt
```

## Structure

```
nvim-tex/
├── init.lua          # entry: loads neotex.core and neotex.bootstrap
├── lua/neotex/       # all config under neotex namespace
├── after/            # filetype-specific overrides
├── snippets/         # LuaSnip snippets
└── templates/        # LaTeX document templates
```

## Differences from NvChad config

| | NvChad (`nvim/`) | NeoTeX (`nvim-tex/`) |
|---|---|---|
| Base | NvChad v2 | benbrastmckie/nvim |
| Focus | General-purpose | LaTeX writing |
| Templates | — | LaTeX document templates |
| Snippets | — | Custom LuaSnip snippets |
| Session workflow | persisted.nvim | Focused on LaTeX sessions |

See also: [nvim/README.md](../nvim/README.md) for the main config.
