return {
  "lukas-reineke/indent-blankline.nvim",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("ibl").setup({
      indent = {
        char = "│",
        tab_char = "│",
        smart_indent_cap = true,
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        injected_languages = true,
        include = {
          node_type = { ["*"] = { "*" } },
        },
      },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "NvimTree", "Trouble", "lazy",
          "mason", "notify", "toggleterm", "lspinfo", "checkhealth",
          "man", "gitcommit", "TelescopePrompt", "TelescopeResults", "",
        },
        buftypes = { "terminal", "nofile", "quickfix", "prompt" },
      },
    })
  end,
}
