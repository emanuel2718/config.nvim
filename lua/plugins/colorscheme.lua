local function rosePine()
  vim.cmd [[colorscheme rose-pine]]
  vim.cmd [[highlight TelescopeSelection guibg=blue]]
end

local function noClownFiesta()
  vim.cmd [[colorscheme no-clown-fiesta]]
  vim.cmd [[highlight TelescopeSelection guibg=blue]]
  vim.cmd [[highlight PmenuSel guibg=blue guifg=white]]
end

local function gruberDarker()
  require("gruber-darker").setup {
    opts = {
      bold = false,
      invert = {
        signs = false,
        tabline = false,
        visual = false,
      },
      italic = {
        strings = false,
        comments = false,
        operators = false,
        folds = true,
      },
      undercurl = false,
      underline = false,
    },
  }
  vim.cmd [[colorscheme gruber-darker]]
  vim.cmd [[highlight Normal guibg=#101010]]
end



return {
  { "kvrohit/rasmus.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "morhetz/gruvbox" },
  { "folke/tokyonight.nvim" },
  { "w0ng/vim-hybrid" },
  { "aktersnurra/no-clown-fiesta.nvim", config = noClownFiesta },
  { "blazkowolf/gruber-darker.nvim" },
}
