return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>g.', ":Git")
  end
}
