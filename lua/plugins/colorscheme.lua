return {
  "tanvirtin/monokai.nvim",
  config = function()
    require('monokai').setup {}
    vim.cmd [[colorscheme monokai]]
  end
}