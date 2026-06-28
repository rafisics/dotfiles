-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

---@type ChadrcConfig

local M = {}

M.base46 = {
  theme = "gruvbox",
  theme_toggle = { "gruvbox", "gruvbox_light" },
  hl_override = {
    ["Visual"] = { bg = "#787859", fg = "#D4D4D4" },
    ["NonText"] = { fg = "#C0B499" },
  },
}

-- Apply the same style to multiple comment groups
local comment_groups = { "Comment", "@comment", "texComment" }
for _, group in ipairs(comment_groups) do
  M.base46.hl_override[group] = {
    -- fg = "#9A9A80",
    italic = true
  }
end

return M
