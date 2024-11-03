return {
  "tanvirtin/monokai.nvim",
  config = function()
    require('monokai').setup {}
    -- blue highlight in cmp menu
    vim.cmd [[colorscheme monokai]]
    vim.cmd [[highlight PmenuSel guibg=blue guifg=white]]
  end
}
