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
  -- filer
  {
    "lambdalisue/fern.vim",
    keys = {
      {
        "<C-b>",
        ":Fern . -reveal=% -drawer -toggle -width=30<CR>",
        desc = "toggle fern",
        silent = true,
      },
    },
    dependencies = {
      { "lambdalisue/nerdfont.vim" },
      {
        "lambdalisue/fern-renderer-nerdfont.vim",
        config = function()
          vim.g["fern#renderer"] = "nerdfont"
        end
      },
      { "lambdalisue/vim-fern-git-status" },
      {
        "yuki-yano/fern-preview.vim",
        config = function()
          vim.api.nvim_create_autocmd({ "FileType" }, {
            once = true,
            pattern = "fern",
            group = vim.api.nvim_create_augroup("fern-settings", { clear = true }),
            callback = function(ev)
              -- keymap only for fern
              vim.keymap.set("n", "p", "<Plug>(fern-action-preview:auto:toggle)", { buffer = ev.buf })
              vim.keymap.set("n", "q", "<Plug>(fern-action-preview:auto:disable) <Plug>(fern-action-preview:close)",
                { buffer = ev.buf })
              vim.keymap.set("n", "<C-d>", "<Plug>(fern-action-preview:scroll:down:half)", { buffer = ev.buf })
              vim.keymap.set("n", "<C-u>", "<Plug>(fern-action-preview:scroll:up:half)", { buffer = ev.buf })
            end,
          })
        end,
      },
    },
  },

  -- syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    evnet = "UIEnter",
    dependencies = { "neovim/nvim-lspconfig" },
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
    "folke/tokyonight.nvim",
    -- lazy = false,
    event = "VeryLazy",
    -- config = function()
    --   vim.cmd.colorscheme("tokyonight-night")
    -- end,
  },
  {
    "cocopon/iceberg.vim",
    lazy = false,
    config = function()
      vim.cmd.colorscheme("iceberg")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup()
      vim.cmd("highlight SignColumn guibg=NONE")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({})

      local clients = vim.lsp.get_active_clients()
      if (clients[1] == nil) or ((clients[1] ~= nil) and (clients[1].name ~= "pyright")) then
        return 0
      end

      local VenvSelectorComponent = require("lualine.component"):extend()

      local default_opts = {
        icon = "",
        color = { fg = "#CDD6F4" },
        on_click = function()
          vim.cmd("VenvSelect")
        end,
      }

      function VenvSelectorComponent:init(options)
        options = vim.tbl_deep_extend("keep", options or {}, default_opts)
        VenvSelectorComponent.super.init(self, options)
      end

      function VenvSelectorComponent:update_status()
        return "Select Venv"
      end

      require("lualine").setup({
        sections = { lualine_c = { "filename", VenvSelectorComponent } }
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "UIEnter",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup({})
    end,
    keys = {
      {
        mode = { "n" },
        "<tab>",
        "<cmd>BufferLineCycleNext<CR>",
        desc = "Move Next Tab",
      },
      {
        mode = { "n" },
        "<S-tab>",
        "<cmd>BufferLineCyclePrev<CR>",
        desc = "Move Prev Tab",
      },
    }
  },
  {
    "karb94/neoscroll.nvim",
    event = "UIEnter",
    config = function()
      local neoscroll = require('neoscroll')
      local keymap = {
        ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 50, easing = "sine" }) end,
        ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 50, easing = "sine" }) end,
        ["G"]     = function() neoscroll.scroll(vim.api.nvim_buf_line_count(0), { duration = 2, easing = "sine" }) end,
        ["gg"]    = function() neoscroll.scroll(-vim.api.nvim_buf_line_count(0), { duration = 2, easing = "sine" }) end,
      }
      local modes = { "n", "v", "x" }
      for key, func in pairs(keymap) do
        vim.keymap.set(modes, key, func)
      end

      neoscroll.setup({
        mappings = {}
      })
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    event = "BufReadPre",
    config = function()
      require("transparent").setup({
        extra_groups = {
          "NormalFloat",
        }
      })
      vim.g.transparent_enalled = true
    end,
  },

  -- toggle terminal
  {
    "akinsho/toggleterm.nvim",
    -- event = "VeryLazy",
    config = function()
      vim.keymap.set("t", "<C-w>", "<C-\\><C-o><C-w>", { noremap = true })

      require("toggleterm").setup({
        open_mapping = { "<C-\\>" },
        shell = "zsh",
      })
    end,
    keys = { "<C-\\>" },
  },

  -- useful editor tools
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    config = true,
  },
  {
    "linux-cultist/venv-selector.nvim",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" }
      },
    },
    branch = "regexp",
    config = function()
      local clients = vim.lsp.get_active_clients()
      if (clients[1] == nil) or ((clients[1] ~= nil) and (clients[1].name ~= "pyright")) then
        return 0
      end

      local venv_selector = require("venv-selector")
      local default_vs_hooks = require("venv-selector.config").default_settings.hooks or {}

      local lualine_setting = function(venv_python)
        local VenvSelectorComponent = require("lualine.component"):extend()

        local default_opts = {
          icon = "",
          color = { fg = "#CDD6F4" },
          on_click = function()
            vim.cmd("VenvSelect")
          end,
        }

        function VenvSelectorComponent:init(options)
          options = vim.tbl_deep_extend("keep", options or {}, default_opts)
          VenvSelectorComponent.super.init(self, options)
        end

        local venv_py_version = vim.fn.system(venv_python .. " -V")
        venv_py_version = string.gsub(venv_py_version, "\n", "")

        function VenvSelectorComponent:update_status()
          return venv_py_version
        end

        require("lualine").setup({
          sections = { lualine_c = { "filename", VenvSelectorComponent } }
        })

        return 0
      end

      table.insert(default_vs_hooks, lualine_setting)

      venv_selector.setup({
        settings = {
          hooks = {
            options = default_vs_hooks,
          },
        },
      })
    end,
  },
  {
    "aznhe21/actions-preview.nvim",
    event = "VeryLazy",
    keys = {
      {
        mode = { "v", "n" },
        "gf",
        "<cmd>lua require('actions-preview').code_actions()<CR>",
        desc = "Preview Code Actions",
      },
    }
  },

  -- useful input tools
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "numToStr/Comment.nvim",
    event = "UIEnter",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      pre_hook = function()
        -- this is useful for mixed language like svelte
        require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
      end,
    },
  },
  {
    "machakann/vim-sandwich",
    event = "InsertEnter",
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },
  {
    "thinca/vim-qfreplace",
    event = "VeryLazy",
  },

  -- lsp
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
          require("mason").setup({
            ui = { border = "single" }
          })
        end,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        config = function()
          local lspconfig = require("lspconfig")

          require("mason-lspconfig").setup({
            ensure_installed = {
              -- shell
              "bashls",
              -- lua
              "lua_ls",
              -- C, C++, C#
              "clangd",
              "omnisharp",
              -- rust
              "rust_analyzer",
              -- python
              "pyright",
              -- web
              "html",
              "biome",
              "denols",
              "tsserver",
              "svelte",
              -- java
              "gradle_ls",
              "jdtls",
              -- "java_language_server",
              -- F#
              "fsautocomplete",
              -- haskell
              "hls",
              --docker
              "dockerls",
              "docker_compose_language_service",
            },
            automatic_installation = true,
            handlers = {
              function(server_name)
                -- border customize
                -- see https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
                vim.cmd("highlight FloatBorder guibg=NONE")

                local border = {
                  { "󱡄", "FloatBorder" },
                  { "󰇜", "FloatBorder" },
                  { "⧨", "FloatBorder" },
                  { "▕", "FloatBorder" },
                  { "", "FloatBorder" },
                  { "󰇜", "FloatBorder" },
                  { "⧩", "FloatBorder" },
                  { "▏", "FloatBorder" },
                }

                -- LSP settings (for overriding per client)
                local handlers = {
                  ["textDocument/hover"] = vim.lsp.with(
                    vim.lsp.handlers.hover,
                    { border = border }
                  ),
                  ["textDocument/signatureHelp"] = vim.lsp.with(
                    vim.lsp.handlers.signature_help,
                    { border = border }
                  ),
                }

                if server_name == "clangd" then
                  local capabilities = vim.lsp.protocol.make_client_capabilities()
                  capabilities.offsetEncoding = { "utf-16" }
                  lspconfig.clangd.setup({
                    handlers = handlers,
                    capabilities = capabilities
                  })
                else
                  lspconfig[server_name].setup({
                    handlers = handlers,
                  })
                end
              end,
            }
          })
        end,
        keys = {
          {
            mode = "n",
            "<c-f>",
            "<cmd>lua vim.lsp.buf.format()<CR><cmd>:LspRestart<CR>",
            desc = "Format current file",
          },
          {
            mode = "n",
            "J",
            "<cmd>lua vim.lsp.buf.hover()<CR>",
            desc = "Hover",
          },
          {
            mode = "n",
            "gd",
            "<cmd>lua vim.lsp.buf.definition()<CR>",
            desc = "Go to Definition",
          },
          {
            mode = "n",
            "gi",
            "<cmd>lua vim.lsp.buf.implementation()<CR>",
            desc = "Go to Implementation",
          },
          {
            mode = "n",
            "gr",
            "<cmd>lua vim.lsp.buf.references()<CR>",
            desc = "Go to References",
          },
          {
            mode = "n",
            "<F2>",
            "<cmd>lua vim.lsp.buf.rename()<CR>",
            desc = "Rename under cursor",
          },
        },
      },
      {
        "nvimtools/none-ls.nvim",
        dependencies = {
          "mason.nvim",
          "nvim-lua/plenary.nvim",
          "nvimtools/none-ls-extras.nvim",
        },
        config = function()
          local null_ls = require("null-ls")

          null_ls.setup({
            border = "single",
            sources = {
              -- python
              null_ls.builtins.formatting.black,
              null_ls.builtins.formatting.isort,
              -- Deprecated: null_ls.builtins.diagnostics.flake8,
              require("none-ls.diagnostics.flake8"),
              -- java
              null_ls.builtins.formatting.google_java_format,
              -- F#
              null_ls.builtins.formatting.fantomas,
              null_ls.builtins.completion.spell,
            },
          })
        end,
      },
      {
        -- automatically resolve mason tools packages
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
          "mason.nvim",
        },
        config = function()
          require("mason-tool-installer").setup({
            ensure_installed = {
              "black",
              "isort",
              "flake8",
            },
          })
        end,
      }
    },
    config = function()
      require("lspconfig.ui.windows").default_options.border = "single"
    end,
  },
  {
    -- lsp notification
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-notify",
    },
    config = function()
      require("fidget").setup({
        notification = { window = { winblend = 0 } }
      })
    end,
    display = {
      overrides = { -- Override options from the default notification config
        rust_analyzer = { name = "rust-analyzer" },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = function()
      require("notify").setup({
        background_colour = "#000000"
      })
      vim.notify = require("notify")
    end,
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    config = true,
  },

  -- snippet
  -- completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
      },
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "luasnip" },
        }),
        view = {
          entries = "native",
        },
      })
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    event = "InsertEnter",
  },
  {
    "hrsh7th/cmp-path",
    event = "InsertEnter",
  },
  {
    "saadparwaiz1/cmp_luasnip",
    event = "InsertEnter",
  },
  {
    "onsails/lspkind.nvim",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({})
        }
      })
    end,
  },
}, {
  -- lazy setup
  ui = {
    border = "single",
  },
  defaults = {
    lazy = true,
  },
})
