return {
  'emanuel2718/vanta.nvim',
  config = function()
    require('vanta').setup()
    vim.cmd([[colorscheme vanta]])
  end
}
