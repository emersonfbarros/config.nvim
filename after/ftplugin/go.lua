local opt = vim.opt_local

-- Go uses tabs by convention
opt.expandtab = false
opt.tabstop = 4
opt.shiftwidth = 4

-- Load custom Go functionality
require('config.ft.go').setup(vim.api.nvim_get_current_buf())
