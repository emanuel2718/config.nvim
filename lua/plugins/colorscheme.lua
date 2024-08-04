return {
  {
    "mellow-theme/mellow.nvim",
  },
  {
    "gruvbox-community/gruvbox",
    name = "gruvbox-community",
    config = function()
      require "plugins.config.colorscheme"
      vim.g.gruvbox_contrast_dark = 'hard'
    end,
  },
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   depencencies = { "rktjmp/lush.nvim" },
  -- },
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
  },
  {
  "HoNamDuong/hybrid.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			-- Default options:
			require("hybrid").setup({
				terminal_colors = true,
				undercurl = true,
				underline = true,
				bold = true,
				italic = {
					strings = false,
					emphasis = false,
					comments = true,
					folds = true,
				},
				strikethrough = true,
				inverse = true,
				transparent = false,
				overrides = function(hl, c)
					local background = "#000000"
					c.bg = background
					hl.TelescopeNormal = {
						fg = c.fg,
						bg = background,
					}
					hl.TelescopeBorder = {
						fg = c.fg,
						bg = c.bg,
					}
					hl.TelescopeTitle = {
						fg = c.fg_hard,
						bg = c.bg,
						bold = true,
					}
				end,
			})
		end,
  }
}
