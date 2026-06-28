return {
    "wfxr/minimap.vim",
    build = "cargo install --locked code-minimap", -- Requires Rust!
    event = "VeryLazy",
    config = function()
      vim.cmd("let g:minimap_auto_start = 1")
      vim.cmd("let g:minimap_auto_start_win_enter = 1")
    end
}
