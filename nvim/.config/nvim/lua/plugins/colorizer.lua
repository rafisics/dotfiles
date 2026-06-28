return {
  "NvChad/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("colorizer").setup {
      filetypes = { '*' }, -- Apply to all filetypes
      user_default_options = {
        names = false, -- Disable parsing "names" like Blue or Gray
      },
    }
  end
}
