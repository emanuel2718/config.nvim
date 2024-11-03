return { -- oil
  "stevearc/oil.nvim",
  opts = {},
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function()
    require("oil").setup()
    vim.keymap.set("n", "-", "<cmd>Oil<cr>")
  end,
}
