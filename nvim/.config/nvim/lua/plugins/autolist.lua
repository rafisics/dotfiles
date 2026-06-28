return {
  "gaoDean/autolist.nvim",
  ft = { "markdown", "text" },
  config = function()
    require("autolist").setup()

    -- Checkbox cycle: [ ] → [.] → [:] → [x] → (remove)
    function HandleCheckbox()
      local config = require("autolist.config")
      local auto   = require("autolist.auto")
      local line   = vim.fn.getline(".")
      local filetype_list = config.lists[vim.bo.filetype]
      if not filetype_list then return end

      for _, list_pattern in ipairs(filetype_list) do
        local list_item = line:match("^%s*" .. list_pattern .. "%s*")
        if list_item == nil then goto continue end
        list_item = list_item:gsub("%s+", "")

        local has_box   = line:match("^%s*" .. list_pattern .. "%s*%[.%]%s*") ~= nil
        local is_empty  = line:match("^%s*" .. list_pattern .. "%s*%[%s%]%s*") ~= nil
        local is_prog   = line:match("^%s*" .. list_pattern .. "%s*%[%.%]%s*") ~= nil
        local is_close  = line:match("^%s*" .. list_pattern .. "%s*%[%:%]%s*") ~= nil
        local is_done   = line:match("^%s*" .. list_pattern .. "%s*%[x%]%s*") ~= nil

        list_item = list_item:gsub("%)", "%%)")

        if not has_box then
          vim.fn.setline(".", line:gsub(list_item, list_item .. " [ ]", 1))
          local pos = vim.api.nvim_win_get_cursor(0)
          vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 4 })
        elseif is_empty  then vim.fn.setline(".", line:gsub("%[%s%]", "[.]", 1))
        elseif is_prog   then vim.fn.setline(".", line:gsub("%[%.%]", "[:]", 1))
        elseif is_close  then vim.fn.setline(".", line:gsub("%[%:%]", "[x]", 1))
        elseif is_done   then
          vim.fn.setline(".", line:gsub(" %[x%]", "", 1))
          local pos = vim.api.nvim_win_get_cursor(0)
          if pos[2] >= 4 then
            vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] - 4 })
          end
        else auto.toggle_checkbox()
        end
        goto done
        ::continue::
      end
      ::done::
    end
  end,
}
