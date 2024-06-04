return {
  {
    "mellow-theme/mellow.nvim",
    config = function()
      require "plugins.config.colorscheme"
    end
  },
  {
    "ellisonleao/gruvbox.nvim",
    depencencies = { "rktjmp/lush.nvim" },
  },
  {
    "sainnhe/gruvbox-material",
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
  }
}

