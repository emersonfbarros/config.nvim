-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Leader Key                                  │
-- ╰──────────────────────────────────────────────────────────────────────────╯

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Prevent space from moving cursor
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Navigation                                  │
-- ╰──────────────────────────────────────────────────────────────────────────╯

local map = vim.keymap.set

-- Better word wrap navigation
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Move up (wrap-aware)' })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = 'Move down (wrap-aware)' })

-- Center cursor when scrolling
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })
map('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
map('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Buffers                                     │
-- ╰──────────────────────────────────────────────────────────────────────────╯

map('n', 'H', '<cmd>bprev<CR>', { desc = 'Previous buffer', silent = true })
map('n', 'L', '<cmd>bnext<CR>', { desc = 'Next buffer', silent = true })
map('n', '<leader>bb', '<cmd>e #<CR>', { desc = 'Switch to alternate buffer' })

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Editing                                     │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Better paste (don't overwrite register)
map('x', '<leader>P', '"_dP', { desc = 'Paste without overwriting register' })

-- Delete without yanking
map({ 'n', 'v' }, '<leader>x', '"_d', { desc = 'Delete without yanking' })

-- Better indenting (stay in visual mode)
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- Move lines up and down
map('v', '<M-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down', silent = true })
map('v', '<M-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up', silent = true })
map('n', '<M-j>', '<cmd>m .+1<CR>==', { desc = 'Move line down', silent = true })
map('n', '<M-k>', '<cmd>m .-2<CR>==', { desc = 'Move line up', silent = true })

-- Add blank lines
map('n', ']<Space>', 'o<Esc>k', { desc = 'Add blank line below' })
map('n', '[<Space>', 'O<Esc>j', { desc = 'Add blank line above' })

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Windows                                     │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Resize windows
map('n', '<C-Up>', '<cmd>resize +2<CR>', { desc = 'Increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<CR>', { desc = 'Decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Increase window width' })

-- Window splits
map('n', '<leader>wv', '<cmd>vsplit<CR>', { desc = 'Split window vertically' })
map('n', '<leader>ws', '<cmd>split<CR>', { desc = 'Split window horizontally' })
map('n', '<leader>wc', '<cmd>close<CR>', { desc = 'Close window' })
map('n', '<leader>wo', '<cmd>only<CR>', { desc = 'Close other windows' })

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Terminal                                    │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- map('t', '<C-h>', '<cmd>wincmd h<CR>', { desc = 'Go to left window' })
-- map('t', '<C-j>', '<cmd>wincmd j<CR>', { desc = 'Go to lower window' })
-- map('t', '<C-k>', '<cmd>wincmd k<CR>', { desc = 'Go to upper window' })
-- map('t', '<C-l>', '<cmd>wincmd l<CR>', { desc = 'Go to right window' })

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Copy File Info                              │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Copy file name (with extension)
map('n', '<leader>fn', function()
  local name = vim.fn.expand '%:t'
  vim.fn.setreg('+', name)
end, { desc = 'Copy file name' })

-- Copy relative path (with extension)
map('n', '<leader>fp', function()
  local path = vim.fn.expand '%:.'
  vim.fn.setreg('+', path)
end, { desc = 'Copy relative path' })

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Quickfix                                    │
-- ╰──────────────────────────────────────────────────────────────────────────╯

map('n', '[q', '<cmd>cprev<CR>zz', { desc = 'Previous quickfix item' })
map('n', ']q', '<cmd>cnext<CR>zz', { desc = 'Next quickfix item' })
map('n', '[Q', '<cmd>cfirst<CR>zz', { desc = 'First quickfix item' })
map('n', ']Q', '<cmd>clast<CR>zz', { desc = 'Last quickfix item' })

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Git (GitHub)                                │
-- ╰──────────────────────────────────────────────────────────────────────────╯

map({ 'n', 'x' }, '<leader>l', function()
  if vim.fn.executable 'gh' ~= 1 then
    vim.notify('gh CLI not found in PATH', vim.log.levels.WARN)
    return
  end

  local git_check = vim.fn.system 'git rev-parse --is-inside-work-tree 2>/dev/null'
  if not git_check:find 'true' then
    vim.notify('Not a git repository', vim.log.levels.WARN)
    return
  end

  Snacks.gitbrowse {
    open = function(url)
      vim.fn.setreg('+', url)
    end,
    notify = true,
  }
end, { desc = 'Copy GitHub permalink' })
