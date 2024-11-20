-- return {
--   "tanvirtin/monokai.nvim",
--   config = function()
--     require('monokai').setup {}
--     -- blue highlight in cmp menu
--     vim.cmd [[colorscheme monokai]]
--     vim.cmd [[highlight PmenuSel guibg=blue guifg=white]]
--   end
-- }
return {
   "kyazdani42/blue-moon",
  config = function()
    vim.opt.termguicolors = true
    vim.cmd "colorscheme blue-moon"
  end
}

-- return {
--   "ofirgall/ofirkai.nvim",
--   config = function()
--     require("ofirkai").setup {
--       theme = nil, -- Choose theme to use, available themes: 'dark_blue'
--       scheme = require("ofirkai").scheme, -- Option to override scheme
--       custom_hlgroups = {}, -- Option to add/override highlight groups
--       remove_italics = false, -- Option to change all the italics style to none
--     }
--   end,
-- }

-- return {
--   "blazkowolf/gruber-darker.nvim",
--   opts = {
--     bold = false,
--     italic = {
--       strings = false,
--     },
--   },
--   config = function()
--     vim.cmd [[colorscheme gruber-darker]]
--     vim.cmd [[highlight PmenuSel guibg=blue guifg=white]]
--   end
-- }
