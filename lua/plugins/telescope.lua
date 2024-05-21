return {
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-smart-history.nvim",
      -- { "kkharji/sqlite.lua" },
    },
    config = function()
      require("telescope").setup {
        defaults = {
          mappings = {
            i = {
              ["<C-x>"] = false,
              ["<esc>"] = require("telescope.actions").close,
            },
          },
        },
        extensions = {
          fzf = {},
          wrap_results = true,
          history = {
            -- path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
            limit = 100,
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
          },
        },
      }

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "smart_history")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require "telescope.builtin"
      local map = vim.keymap.set

      map("n", "<space>gt", builtin.git_files)
      map("n", "<space>gt", builtin.find_files)
      map("n", "<leader>.", ':lua require"telescope.builtin".find_files({ hidden = true })<CR>')

      map("n", "<leader>fo", builtin.oldfiles)
      map("n", "<leader>hh", builtin.help_tags)
      map("n", "<leader>sp", builtin.live_grep)
      map("n", "<leader>ss", builtin.current_buffer_fuzzy_find)
      map("n", "<leader>bi", builtin.buffers)
      map("n", "<leader>ri", builtin.resume)
      map("n", "<leader>si", builtin.lsp_document_symbols)

      map("n", "<leader>/", builtin.grep_string)

      map("n", "<leader>fa", function()
        ---@diagnostic disable-next-line: param-type-mismatch
        builtin.find_files { cwd = vim.fs.joinpath(vim.fn.stdpath "data", "lazy") }
      end)

      map("n", "<leader>sn", function()
        builtin.find_files { cwd = vim.fn.stdpath "config" }
      end)
    end,
  },
}
