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
  {
    "lambdalisue/fern.vim",
    keys = {
      {"<C-b>", ":Fern . -reveal=% -drawer -toggle -width=30<CR>", desc = "toggle fern"},
    },
    dependencies = {
      {"lambdalisue/nerdfont.vim"},
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
    build = ":TSUpdate",
    lazy = false,
    config = function ()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        highlight = {enable = true, disable = {"vimdoc"}},
        indent = {enable = true},
      })
    end,
  },
  -- useful editor input tools
  {
    "windwp/nvim-autopairs",
    config = true,
    event = 'InsertEnter',
  },
  {
    "numToStr/Comment.nvim",
    event = "UIEnter",
    dependencies = {"JoosepAlviste/nvim-ts-context-commentstring"},
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
  },
}, {
  defaults = {
    lazy = true,
  },
})
