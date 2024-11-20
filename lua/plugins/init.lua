return {
  { 'tpope/vim-sleuth' },
  { 'windwp/nvim-autopairs', event = "InsertEnter", config = true },
  { 'ntpeters/vim-better-whitespace' },
  { 'j-hui/fidget.nvim',             opts = {} },
  { 'NvChad/nvim-colorizer.lua',     config = function() require('colorizer').setup {} end },
}
