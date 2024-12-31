return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "stevearc/conform.nvim",
      "b0o/SchemaStore.nvim",
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities {
        textDocument = { completion = { completionItem = { snippetSupport = false } } },
      }

      local lspconfig = require "lspconfig"

      -- LSP SERVERS

      -- lua
      lspconfig.lua_ls.setup {
        capabilites = capabilities,
        settings = {
          Lua = {
            completion = {
              callSnippet = "Disable",
              keywordSnippet = "Disable",
            },
          },
        },
        server_capabilities = {
          semanticTokensProvider = vim.NIL,
        },
      }

      -- rust
      lspconfig.rust_analyzer.setup {
        capabilites = capabilities,
        completion = {
          capable = {
            snippets = "add_parenthesis",
          },
        },
      }
      -- python
      lspconfig.pyright.setup { capabilites = capabilities }

      -- tailwindcscs
      lspconfig.tailwindcss.setup { capabilites = capabilities }

      -- typescript
      lspconfig.ts_ls.setup { capabilites = capabilities }

      -- html
      lspconfig.html.setup { capabilites = capabilities }

      -- css
      lspconfig.cssls.setup { capabilites = capabilities }

      -- C/C++
      lspconfig.clangd.setup { capabilites = capabilities }

      -- json
      lspconfig.jsonls.setup {
        capabilites = capabilities,
        server_capabilities = {
          documentFormattingProvider = false,
        },
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      }

      -- yaml
      lspconfig.yamlls.setup {
        capabilites = capabilities,
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
          },
        },
      }

      -- vue
      lspconfig.volar.setup {
        capabilites = capabilities,
        filetypes = { "vue" },
        init_options = {
          vue = {
            hybridMode = false,
          },
        },
      }
      require("mason").setup()
      local ensure_installed = {
        "clangd",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "stylua",
        "tailwindcss-language-server",
        "emmet_ls",
        "ts_ls",
        "volar",
        "yamlls",
      }

      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      local conform = require "conform"
      conform.setup {
        formatters_by_ft = {
          lua = { "stylua" },
          rust = { "rust_analyzer" },
          python = { "isort", "black" },
          go = { "gofmt" },
          typescript = { "prettier" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          yaml = { "prettier" },
          vue = { "prettier" },
        },
      }

      local auto_format = true

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if not c then
            return
          end

          -- Format the current buffer on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
              if auto_format then
                conform.format { lsp_format = "fallback", quiet = false }
              end
              -- vim.lsp.buf.format { bufnr = args.buf, id = c.id }
            end,
          })

          local is_v10 = vim.fn.has "nvim-0.10" == 1
          local fzf = require "fzf-lua"
          local opts = { noremap = true, silent = true, buffer = args.buf }
          vim.keymap.set("n", "gd", fzf.lsp_definitions, opts)
          vim.keymap.set("n", "gr", fzf.lsp_references, opts)
          vim.keymap.set("n", "gi", fzf.lsp_implementations, opts)
          vim.keymap.set("n", "gD", fzf.lsp_declarations, opts)
          vim.keymap.set("n", "<leader>ll", fzf.lsp_document_symbols, opts)
          vim.keymap.set("n", "<leader>ls", fzf.lsp_workspace_symbols, opts)
          vim.keymap.set("n", "<leader>ff", function()
            if auto_format then
              auto_format = false
              print "Toggling auto format OFF!"
            else
              print "Toggling auto format ON!"
              auto_format = true
            end
            -- auto_format = not auto_format -- toggle it
          end, opts)
          vim.keymap.set({ "n", "v" }, "<leader>lf", function()
            conform.format { lsp_format = "fallback", quiet = false }
          end)

          vim.keymap.set("i", "<C-k>", function()
            vim.lsp.buf.signature_help {}
          end, opts)
          vim.keymap.set("n", "gn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)

          vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", opts)
          vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", opts)
          vim.keymap.set("n", "<leader>ti", "<cmd>InspectTree<cr>", opts)

          vim.keymap.set("n", "<C-c>", vim.lsp.buf.code_action, opts)

          vim.keymap.set("n", "<leader>k", function()
            if is_v10 then
              ---@diagnostic disable-next-line: deprecated
              vim.diagnostic.goto_prev()
            else
              vim.diagnostic.jump { count = -1 }
            end
            vim.cmd "norm zz"
          end, opts)
          vim.keymap.set("n", "<leader>j", function()
            if is_v10 then
              ---@diagnostic disable-next-line: deprecated
              vim.diagnostic.goto_next()
            else
              vim.diagnostic.jump { count = 1 }
            end
            vim.cmd "norm zz"
          end, opts)

          vim.keymap.set("n", "<leader>v", function()
            vim.cmd "vsplit | lua vim.lsp.buf.definition()"
            vim.cmd "norm zz"
          end, opts)
        end,
      })
    end,
  },
}
