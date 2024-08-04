return {
  "ibhagwan/fzf-lua",
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup {
      { "fzf-native" },
      -- winopts = {
      --   preview = {
      --     layout = "vertical",
      --   },
      -- },
      winopts = {
        preview = {
          hidden = "hidden", -- Change this to adjust the preview height
        },
        height = 0.5, -- Set the height of the window as needed
        width = 1, -- Set the width of the window as needed
        row = 1, -- Start the window at the bottom
        col = 0.5, -- Center the window horizontally
        border = "rounded", -- Set border style (optional)
        winblend = 10, -- Set transparency (optional)
      },
      files = {
        formatter = "path.filename_first", -- places file name first
      },
    }

    local map = vim.keymap.set
    local fzf = require "fzf-lua"

    map("n", "<leader>.", fzf.files)
    map("n", "<leader>ff", fzf.git_files)
    map("n", "<leader>fo", fzf.oldfiles)
    map("n", "<leader>/", fzf.blines)
    map("n", "<leader>b.", fzf.buffers)
    map("n", "<leader>sp", fzf.live_grep_native)

    map("n", "<leader>gs", fzf.git_status)
    map("n", "<leader>gc", fzf.git_commits)
    map("n", "<leader>gcb", fzf.git_bcommits)
    map("n", "<leader>gb", fzf.git_branches)
    map("n", "<leader>gt", fzf.git_stash)

    map("n", "<leader>r.", fzf.resume)
    map("n", "<leader>hh", fzf.helptags)
    map("n", "<leader>ht", fzf.colorschemes)
    map("n", "<leader>mm", fzf.manpages)
  end,
}
