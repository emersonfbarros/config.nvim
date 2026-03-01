local utils = require 'config.utils'
local augroup = utils.augroup

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Filetype Detection                          │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Ensure filetype detection runs when opening files via :e or file explorers
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = augroup 'ensure_filetype',
  callback = function(event)
    local buf = event.buf
    -- Skip if already has a filetype or is a special buffer
    if vim.bo[buf].filetype ~= '' or vim.bo[buf].buftype ~= '' then
      return
    end

    -- Get the filename
    local filename = vim.api.nvim_buf_get_name(buf)
    if filename == '' then
      return
    end

    -- Trigger filetype detection
    vim.cmd 'filetype detect'
  end,
})

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Highlight on Yank                           │
-- ╰──────────────────────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup 'highlight_yank',
  callback = function()
    vim.highlight.on_yank { timeout = 200 }
  end,
})

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Window Management                           │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Resize splits when window is resized
vim.api.nvim_create_autocmd('VimResized', {
  group = augroup 'resize_splits',
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd 'tabdo wincmd ='
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Cursor Position                             │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup 'last_loc',
  callback = function(event)
    local exclude = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].nvim_last_loc then
      return
    end
    vim.b[buf].nvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              FileType Settings                           │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Wrap and spell check for text filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'wrap_spell',
  pattern = { 'gitcommit', 'markdown', 'org', 'text', 'plaintex', 'typst' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for JSON files
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'json_conceal',
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Close buffers with 'q'
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'close_with_q',
  pattern = {
    'checkhealth',
    'dbout',
    'gitsigns-blame',
    'gogenres',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'vim',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<CR>', {
      buffer = event.buf,
      silent = true,
      desc = 'Close buffer',
    })
  end,
})

-- Man pages settings
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'man_unlisted',
  pattern = 'man',
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Terminal                                    │
-- ╰──────────────────────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd('TermOpen', {
  group = augroup 'custom_term_open',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    vim.opt_local.signcolumn = 'no'
    vim.bo.filetype = 'terminal'
  end,
})

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Auto Create Directories                     │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Auto create directories when saving a file
vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup 'auto_create_dir',
  callback = function(event)
    if event.match:match '^%w%w+:[\\/][\\/]' then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Quickfix Improvements                       │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Auto open quickfix window when populated
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = augroup 'quickfix_open',
  pattern = { '[^l]*' },
  command = 'cwindow',
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = augroup 'loclist_open',
  pattern = { 'l*' },
  command = 'lwindow',
})
