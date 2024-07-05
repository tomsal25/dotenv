--####-- vim options
-- display line number
vim.opt.number = true

vim.opt.fileformat = "unix"
vim.opt.fileencoding = "utf-8"

-- force 2 white spaces and the same indent style
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = -1
vim.opt.shiftwidth = 0

-- visualize tab
vim.opt.list = true
vim.opt.listchars = { space = " ", tab = "󰁕", trail = "$" }

vim.opt.showtabline = 2

vim.opt.termguicolors = true

--####-- auto running scripts
-- remove trailing spaces on save a file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    cursor_pos = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", cursor_pos)
  end,
})

-- remove trailing line breaks on save a file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    cursor_pos = vim.fn.getpos(".")
    vim.cmd([[%s/\(\r\?\n\)\+\%$//e]])
    vim.fn.setpos(".", cursor_pos)
  end,
})

-- remember cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})
