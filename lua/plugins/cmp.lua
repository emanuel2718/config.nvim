return {
  {
    "saghen/blink.cmp",
    version = "v0.*",
    config = function()
      require("blink.cmp").setup {
        completion = {
          menu = { border = "single", auto_show = false },
        },
        sources = {
          -- disable all snippets
          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              return item.kind ~= require("blink.cmp.types").CompletionItemKind.Snippet
            end, items)
          end,
          default = { "lsp", "path", "buffer" },
          cmdline = {}, -- disable in command line (annoying)
        },

        signature = { enabled = true },
      }
    end,
  },
}
