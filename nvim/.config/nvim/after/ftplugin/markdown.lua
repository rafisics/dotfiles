local map = function(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true })
end

-- Auto-continue lists on Enter / new line
map("i", "<CR>",   "<CR><cmd>AutolistNewBullet<cr>")
map("n", "o",      "o<cmd>AutolistNewBullet<cr>")
map("n", "O",      "O<cmd>AutolistNewBulletBefore<cr>")

-- Indent/dedent with list recalculation
map("i", "<Tab>",   "<Tab><cmd>AutolistRecalculate<cr>")
map("i", "<S-Tab>", "<S-Tab><cmd>AutolistRecalculate<cr>")
map("n", ">>",      ">><cmd>AutolistRecalculate<cr>")
map("n", "<<",      "<<<cmd>AutolistRecalculate<cr>")

-- Delete line and recalculate numbering
map("n", "dd", "dd<cmd>AutolistRecalculate<cr>")

-- Toggle checkbox cycle: [ ] → [.] → [:] → [x] → (remove)
map("n", "<C-n>", "<cmd>lua HandleCheckbox()<cr>")
