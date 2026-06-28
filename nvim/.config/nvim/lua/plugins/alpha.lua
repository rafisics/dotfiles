return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "Shatur/neovim-session-manager",
  },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Define highlight groups upfront
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#787859" })
    vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#C0B499" })
    vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#C0B499" })
    -- Note: #787859 may have low contrast; consider #C0B499 for better readability on footer and buttons

    -- Set header
    dashboard.section.header.val = {
      "                                                                       ",
      "                                                                     ",
      "       ████ ██████           █████      ██                     ",
      "      ███████████             █████                             ",
      "      █████████ ███████████████████ ███   ███████████   ",
      "     █████████  ███    █████████████ █████ ██████████████   ",
      "    █████████ ██████████ █████████ █████ █████ ████ █████   ",
      "  ███████████ ███    ███ █████████ █████ █████ ████ █████  ",
      " ██████  █████████████████████ ████ █████ █████ ████ ██████ ",
      "                                                                       ",
    }
    dashboard.section.header.opts.hl = "AlphaHeader"

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("s", "  Sessions", "<cmd>SessionManager load_session<CR>"),
      dashboard.button("r", "󰈚  Recent", ":Telescope oldfiles <CR>"),
      dashboard.button("e", "󰱼  Explorer", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("f", "  Find", ":Telescope find_files <CR>"),
      dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
      -- dashboard.button("i", "  Info", "<cmd>e ~/.config/CheatSheet.md<cr>"),
      dashboard.button("p", "  Plugins", "<cmd>Lazy<cr>"),
      dashboard.button("h", "  Checkhealth", "<cmd>checkhealth<cr>"),
      dashboard.button("q", "  Quit", "<cmd>qa!<CR>"),
    }

    -- Apply highlight to buttons
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaButtons"
    end

    -- Set footer
    -- dashboard.section.footer.val = fortune
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

        -- local now = os.date "%d-%m-%Y %H:%M:%S"
        local version = "   v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
        -- local fortune = require "alpha.fortune"
        -- local quote = table.concat(fortune(), "\n")
        local plugins = "⚡Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
        local footer = version .. "\t" .. plugins -- .. "\n" .. quote
        dashboard.section.footer.val = footer
        dashboard.section.footer.opts.hl = "AlphaFooter"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    -- Send config to alpha (call only once)
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
