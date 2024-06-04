return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neodev.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
      "folke/trouble.nvim",

      { "j-hui/fidget.nvim", opts = {} },

      -- Autoformatting
      "stevearc/conform.nvim",

      -- Schema information
      "b0o/SchemaStore.nvim",
    },
    config = function()
      require("neodev").setup {}

      local capabilities = nil
      if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      local lspconfig = require "lspconfig"

      local servers = {
        bashls = true,
        lua_ls = true,
        rust_analyzer = true,
        svelte = true,
        templ = true,
        cssls = true,
        pyright = true,
        tailwindcss = true,
        -- gopls = {
        --   settings = {
        --     gopls = {
        --       hints = {
        --         assignVariableTypes = true,
        --         compositeLiteralFields = true,
        --         compositeLiteralTypes = true,
        --         constantValues = true,
        --         functionTypeParameters = true,
        --         parameterNames = true,
        --         rangeVariableTypes = true,
        --       },
        --     },
        --   },
        -- },

        -- Probably want to disable formatting for this lang server
        tsserver = true,

        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        volar = {
          filetypes = { "vue" },
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },

        clangd = {
          init_options = { clangdFileStatus = true },
          filetypes = { "c" },
        },
      }

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      require("mason").setup()
      local ensure_installed = {
        "clangd",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "stylua",
        "tailwindcss-language-server",
        "tsserver",
        "volar",
        "yamlls",
        -- "gopls",
      }

      vim.list_extend(ensure_installed, servers_to_install)
      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        lspconfig[name].setup(config)
      end

      local disable_semantic_tokens = {
        lua = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
          vim.keymap.set("n", "gd", ':lua require"telescope.builtin".lsp_definitions()<CR>', { buffer = 0 })

          vim.keymap.set("n", "gh", vim.lsp.buf.references, { buffer = 0 })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
          vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
          vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = 0 })
          vim.keymap.set("n", "gl", function()
            vim.diagnostic.open_float {}
          end)

          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = 0 })
          vim.keymap.set("n", "<C-c>", vim.lsp.buf.code_action, { buffer = 0 })
          vim.keymap.set("n", "<leader>j", "<cmd>lua vim.diagnostic.goto_next()<cr>", { buffer = 0 })
          vim.keymap.set("n", "<leader>k", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { buffer = 0 })
          vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>")
          vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>")
          vim.keymap.set("n", "<leader>lf", function()
            require("conform").format { bufnr = bufnr, lsp_fallback = true, quiet = true }
          end)

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })

      -- Autoformatting Setup
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          rust = { "rust_analyzer" },
          python = { "isort", "black" },
          typescript = { "prettier" },
          javascript = { "prettier"},
          vue = { "prettier" },
        },
      }

      -- Autoformatting
      -- vim.api.nvim_create_autocmd("BufWritePre", {
      --   callback = function(args)
      --     require("conform").format {
      --       bufnr = args.buf,
      --       lsp_fallback = true,
      --       quiet = true,
      --     }
      --   end,
      -- })

      -- Toggle LSP Diagnostics
      require("toggle_lsp_diagnostics").init { start_on = true }
      vim.keymap.set("n", "<leader>dd", "<cmd>ToggleDiag<cr>")

      local trouble = require "trouble"
      vim.keymap.set("n", "<leader>d.", function()
        trouble.toggle "document_diagnostics"
      end)
    end,
  },
}
