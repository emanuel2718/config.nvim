return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "echasnovski/mini.icons" },
  config = function()
    local map = vim.keymap.set
    local fzf = require 'fzf-lua'
    fzf.setup {
    }

    map('n', '<leader>.', fzf.files)
    map('n', '<leader>fo', fzf.git_files)
    map('n', '<leader>fo', fzf.oldfiles)
    map('n', '<leader><leader>', fzf.buffers)
    map('n', '<leader>sp', fzf.live_grep_native)
    map('n', '<leader>r.', fzf.resume)
    map('n', '<leader>ht', fzf.colorschemes)
    map('n', '<leader>hh', fzf.helptags)
  end
}
