return {
  {
    "mellow-theme/mellow.nvim",
    config = function()
      require "plugins.config.colorscheme"
    end,
  },
  {
    "blazkowolf/gruber-darker.nvim",
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
  },
  {
    "HoNamDuong/hybrid.nvim",
    config = function()
      require("hybrid").setup {
        terminal_colors = true,
        undercurl = false,
        underline = false,
        bold = false,
        italic = {
          strings = false,
          emphasis = false,
          comments = false,
          folds = false,
        },
        strikethrough = false,
        inverse = false,
        transparent = false,
      }
    end,
  },
  { "kyazdani42/blue-moon" },
  { "kvrohit/rasmus.nvim" },
}
