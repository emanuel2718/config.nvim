return {
  "echasnovski/mini.nvim",
  config = function()
    local statusline = require "mini.statusline"
    statusline.setup { use_icons = vim.g.have_nerd_font }
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return "%2l:%-2v"
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_git = function()
      return nil
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_diff = function()
      return nil
    end

  end,
}
