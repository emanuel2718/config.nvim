-- return {}
return {
  "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup {
        options = {
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = { {"filename", path = 1 }, "diagnostics" },
          lualine_x = {},
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
}
