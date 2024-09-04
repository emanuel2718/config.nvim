---@diagnostic disable: missing-fields
-- LAZY --
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end

---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

local opt = vim.opt
local map = vim.keymap.set
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- OPTIONS --

vim.g.mapleader = " " -- Setup mapleader before everything else

opt.expandtab = true -- spaces > tabs
opt.autoindent = true
opt.inccommand = "split"
opt.mouse = "a"
opt.number = true
opt.shiftwidth = 2
opt.signcolumn = "yes"
opt.smartcase = true
opt.softtabstop = 2
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.tabstop = 2
opt.softtabstop = 2

-- KEYMAPS --

-- split
map("n", "<leader>n", "<cmd>split<cr>")
map("n", "<leader>m", "<cmd>vsplit<cr>")

-- movement
map("n", "<c-j>", "<c-w><c-j>")
map("n", "<c-k>", "<c-w><c-k>")
map("n", "<c-l>", "<c-w><c-l>")
map("n", "<c-h>", "<c-w><c-h>")

-- window resize
map("n", "<Left>", "<c-w>5<")
map("n", "<Right>", "<c-w>5>")
map("n", "<Up>", "<C-W>+")
map("n", "<Down>", "<C-W>-")

-- move highlighted lines up and down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Multiple indent commands
map("v", "<", "<gv")
map("v", ">", ">gv")

-- respect system clipboard
map("v", "<leader>y", [["+y]])
map("n", "<leader>y", [["+Y]])

-- quit
map("n", "<leader>q", "<cmd>qa!<cr>")

-- save
map("n", "<leader>fs", "<cmd>w!<cr>")

-- close buffer
map("n", "<leader>o", "<cmd>q<cr>")

-- last buffer
map("n", "<leader>`", "<cmd>e #<cr>")

-- edit config
map("n", "<leader>sn", function()
  vim.cmd("edit " .. vim.fn.stdpath "config" .. "/init.lua")
end)

-- reload config
map("n", "<leader>s.", function()
  local ok, err = pcall(function()
    dofile(vim.fn.stdpath "config" .. "/init.lua")
  end)
  if not ok then
    print("Error reloading config: " .. err)
  end

  if ok then
    print "Reloaded config"
  end
end)

-- Toggle hlsearch if it's on, otherwise do nothing
map("n", "<Esc>", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt.hlsearch:get() then
    vim.cmd.nohl()
    return ""
  else
    return "<Esc>"
  end
end, { expr = true })

-- AUTOCOMMANDS --

-- Highlight on yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = "200",
    }
  end,
})

-- Don't auto commenting new lines, NEVER
autocmd("BufEnter", {
  pattern = "",
  command = "set fo-=c fo-=r fo-=o",
})

-- close certain buffers with just pressing `q`
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = { "help", "lspinfo", "man", "fugitive", "checkhealth", "oil" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    map("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- PLUGINS --

require("lazy").setup {
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

  -- "vim-airline/vim-airline", -- statusline, nostalgia
  {
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
          lualine_c = { "filename", "diagnostics" },
          lualine_x = {},
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true }, -- autopairs -- autopairs

  { -- gitsigns
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
  -- theme
  { "RRethy/base16-nvim" },
  { -- colorizer
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup {}
    end,
  },
  { -- term
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      direction = "float",
    },
    keys = {
      { "<C-t>", "<cmd>ToggleTerm<cr>", mode = "n" },
      { "<C-t>", "<cmd>ToggleTerm<cr>", mode = "t" },
    },
  },

  { -- fugitive
    "tpope/vim-fugitive",
    config = function()
      map("n", "<leader>g.", ":Git")
    end,
  },

  { -- fzf-lua
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup {
        { "fzf-native" },
        winopts = {
          preview = {
            hidden = "hidden",
          },
          height = 0.5,
          width = 1,
          row = 1,
          col = 0.5,
          border = "rounded",
          winblend = 10,
        },
        files = {
          formatter = "path.filename_first", -- places file name first
        },
      }

      local fzf = require "fzf-lua"

      map("n", "<leader>.", fzf.files)
      map("n", "<leader>ff", fzf.git_files)
      map("n", "<leader>fo", fzf.oldfiles)
      map("n", "<leader>/", fzf.blines)
      map("n", "<leader><leader>", fzf.buffers)
      map("n", "<leader>sp", fzf.live_grep_native)

      map("n", "<leader>r.", fzf.resume)
      map("n", "<leader>hh", fzf.helptags)
      map("n", "<leader>ht", fzf.colorschemes)
      map("n", "<leader>mm", fzf.manpages)
    end,
  },
  { -- treesitter
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "c",
          "cpp",
          "css",
          "html",
          "javascript",
          "lua",
          "rust",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "vue",
          "yaml",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      vim.keymap.set("n", "<leader>;", function()
        return require("copilot.suggestion").toggle_auto_trigger()
      end)

      require("copilot").setup {
        panel = {
          enabled = false,
          auto_refresh = false,
        },
        suggestion = {
          enabled = true,
          auto_trigger = false,
          debounce = 75,
          keymap = {
            accept = "<C-f>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = "node", -- Node.js version must be > 18.x
      }
    end,
  },
  { -- oil
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    config = function()
      require("oil").setup()
      map("n", "-", "<cmd>Oil<cr>")
    end,
  },
  { -- LSP
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
      { "j-hui/fidget.nvim", opts = {} },
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
        emmet_ls = true,
        pyright = true,
        tailwindcss = true,
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
        "emmet_ls",
        "tsserver",
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

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          map("n", "gd", fzf.lsp_definitions, { buffer = 0 })
          map("n", "si", fzf.lsp_document_symbols, { buffer = 0 })

          map("n", "gh", fzf.lsp_references, { buffer = 0 })
          map("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
          map("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
          map("n", "K", vim.lsp.buf.hover, { buffer = 0 })
          map("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = 0 })
          map("n", "gl", function()
            vim.diagnostic.open_float {}
          end)

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
  },
  { -- cmp
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "neovim/nvim-lspconfig",
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
          ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Enter>"] = cmp.mapping.confirm { select = true },
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
          { name = "luasnip" },
        }),
      }
    end,
  },
}

local base16 = function()
  vim.cmd [[colorscheme base16-tomorrow-night]]
end

local highlight = function()
  -- blue highlight in cmp menu
  vim.cmd [[highlight PmenuSel guibg=blue guifg=white]]

  -- blue cursor in telescope
  vim.cmd [[highlight TelescopeSelection guibg=blue]]

  -- invinsible gutter
  vim.cmd [[ highlight LineNr guibg=NONE ctermbg=NONE ]]
  vim.cmd [[ highlight SignColumn guibg=NONE ctermbg=NONE ]]
end

-- COLORSCHEME --
base16()
highlight()
