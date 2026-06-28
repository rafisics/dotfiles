return {
  "L3MON4D3/LuaSnip",
  -- version = "v2.*",
  event = { "BufReadPre", "BufNewFile" },
  build = "make install_jsregexp",
  -- config = function()    
  --     require("luasnip.loaders.from_vscode").lazy_load()
  --     -- require("luasnip.loaders.from_snipmate").load({ paths = "~/.config/nvim/snippets/" })
  -- end
}
