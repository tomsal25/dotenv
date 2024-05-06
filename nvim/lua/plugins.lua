local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- window plugin
  --[[ {
    "nvim-tree/nvim-tree.lua",
    config = true,
    keys = {
      {mode = "n", "<c-b>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle nvim-tree"}
    },
  }, ]]

  -- filer
  {
    "lambdalisue/fern.vim",
    keys = {
      { "<C-b>", ":Fern . -reveal=% -drawer -toggle -width=30<CR>", desc = "toggle fern" },
    },
    dependencies = {
      { "lambdalisue/nerdfont.vim" },
      {
        "lambdalisue/fern-renderer-nerdfont.vim",
        config = function()
          vim.g["fern#renderer"] = "nerdfont"
        end
      },
    },
  },

  -- syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        highlight = { enable = true, disable = { "vimdoc" } },
        indent = { enable = true },
      })
    end,
  },

  -- UI
  {
    "lewis6991/gitsigns.nvim",
    event = "UIEnter",
    config = function()
      require("gitsigns").setup()
      vim.cmd("highlight SignColumn guibg=NONE")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    -- event = "UIEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
  },

  -- useful editor input tools
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "numToStr/Comment.nvim",
    event = "UIEnter",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    opts = {
      pre_hook = function()
        -- this is useful for mixed language like svelte
        require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
      end,
    }
  },

  -- lsp
  {
    "williamboman/mason.nvim",
    lazy = false,
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local lspconfig = require("lspconfig")

      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "clangd",
          "lua_ls",
          "rust_analyzer",
          "pyright",
          "biome",
          "tsserver",
          "svelte",
        },
        automatic_installation = true,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({})
          end,
        }
      })
    end,
    keys = {
      { mode = "n", "<c-f>", "<cmd>lua vim.lsp.buf.format()<CR>",         desc = "Format current file" },
      { mode = "n", "J",     "<cmd>lua vim.lsp.buf.hover()<CR>",          desc = "Hover" },
      { mode = "n", "gd",    "<cmd>lua vim.lsp.buf.definition()<CR>",     desc = "Go to Definition" },
      { mode = "n", "gi",    "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Go to Implementation" },
      { mode = "n", "gr",    "<cmd>lua vim.lsp.buf.references()<CR>",     desc = "Go to References" },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          -- Deprecated: null_ls.builtins.diagnostics.flake8,
          require("none-ls.diagnostics.flake8"),
          null_ls.builtins.completion.spell,
        },
      })
    end,
  },
  {
    -- automatically resolve mason tools packages
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "black",
          "isort",
          "flake8",
        },
      })
    end,
  },
  {
    -- lsp notification
    "j-hui/fidget.nvim",
    lazy = false,
    dependencies = {
      "rcarriga/nvim-notify",
    },
    config = function()
      require("fidget").setup({
        notification = { window = { winblend = 0 } }
      })
    end,
  },
}, {
  defaults = {
    lazy = true,
  },
})
