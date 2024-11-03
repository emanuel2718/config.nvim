return {}
-- return {
--   "nvim-telescope/telescope.nvim",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     {
--       "nvim-telescope/telescope-fzf-native.nvim",
--       build = "make",
--       cond = function()
--         return vim.fn.executable('make') == 1
--       end
--     },
--     { "nvim-telescope/telescope-rg.nvim" }
--   },
--   config = function()
--     local map = vim.keymap.set
--     require('telescope').setup {}
--     -- require('telescope').load_extension('fzf')

--     local builtin = require "telescope.builtin"

--   end
-- }