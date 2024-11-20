return { -- LSP
  "neovim/nvim-lspconfig",
  dependencies = {
    "folke/neodev.nvim",
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
    "JoosepAlviste/nvim-ts-context-commentstring",
    "folke/trouble.nvim",
    "stevearc/conform.nvim",
    "b0o/SchemaStore.nvim",
    { "j-hui/fidget.nvim",       opts = {} },
  },
  config = function()
    local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
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
      emmet_ls = true,
      pyright = true,
      tailwindcss = true,
      -- Probably want to disable formatting for this lang server
      ts_ls = true,

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
      "emmet_ls",
      "ts_ls",
      "volar",
      "yamlls",
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

    -- Autoformatting Setup
    require("conform").setup {
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

    autocmd("LspAttach", {
      callback = function(args)
        local fzf = require "fzf-lua"
        local bufnr = args.buf
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")
        local map = vim.keymap.set

        vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
        map("n", "gd", fzf.lsp_definitions, { buffer = 0 })

        map("n", "gh", fzf.lsp_references, { buffer = 0 })
        map("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
        map("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
        map("n", "K", vim.lsp.buf.hover, { buffer = 0 })
        map("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = 0 })
        map("n", "gl", function()
          vim.diagnostic.open_float {}
        end)

        map("n", "<leader>si", fzf.lsp_document_symbols, { buffer = 0 })
        map("n", "<leader>d.", fzf.diagnostics_document, { buffer = 0 })
        map("n", "<space>rn", vim.lsp.buf.rename, { buffer = 0 })
        map("n", "<C-c>", fzf.lsp_code_actions, { buffer = 0 })
        map("n", "<leader>j", "<cmd>lua vim.diagnostic.goto_next()<cr>", { buffer = 0 })
        map("n", "<leader>k", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { buffer = 0 })
        map("n", "<leader>lr", "<cmd>LspRestart<cr>")
        map("n", "<leader>li", "<cmd>LspInfo<cr>")
        map({ "n", "v" }, "<leader>lf", function()
          require("conform").format { lsp_format = "fallback", quiet = false }
        end)

        -- Toggle LSP Diagnostics
        require("toggle_lsp_diagnostics").init { start_on = true }
        map("n", "<leader>dd", "<cmd>ToggleDiag<cr>")

        local filetype = vim.bo[bufnr].filetype
        if disable_semantic_tokens[filetype] then
          client.server_capabilities.semanticTokensProvider = nil
        end
      end,
    })
  end,
}
