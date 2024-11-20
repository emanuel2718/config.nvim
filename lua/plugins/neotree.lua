return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    vim.keymap.set('n', '<C-e>', '<cmd>Neotree toggle position=right<cr>')
  end,
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
        hide_by_pattern = {
          "**/.git",
          "**/.DS_Store",
          "**/node_modules",
          "**/target",
          "**/zig-cache",
          "**/zig-out",
        },
      },
      window = {
        mappings = {
          ["o"] = "open",
          ["h"] = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" and node:is_expanded() then
              require("neo-tree.sources.filesystem").toggle_directory(state, node)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end
          end,
          ["l"] = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" then
              if not node:is_expanded() then
                require("neo-tree.sources.filesystem").toggle_directory(state, node)
              elseif node:has_children() then
                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
              end
            end
          end,
        },
      },
    },
  },
}
