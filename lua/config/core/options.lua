local opt = vim.opt
local g = vim.g

-- Undercurl support for terminals
vim.cmd [[let &t_Cs = "\e[4:3m"]]
vim.cmd [[let &t_Ce = "\e[4:0m"]]

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              General                                     │
-- ╰──────────────────────────────────────────────────────────────────────────╯

g.editorconfig = true
opt.mouse = 'a' -- Enable mouse in all modes
opt.confirm = true -- Confirm before closing unsaved buffer
opt.autowrite = true -- Auto-save before running commands
opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode

-- Sync clipboard with system (deferred for faster startup)
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              UI Settings                                 │
-- ╰──────────────────────────────────────────────────────────────────────────╯

opt.termguicolors = true -- True color support
opt.number = true -- Show line numbers
opt.relativenumber = false -- Relative line numbers (toggle with <leader>r)
opt.cursorline = true -- Highlight current line
opt.signcolumn = 'yes' -- Always show sign column
opt.colorcolumn = '80' -- Show column guide
opt.showmode = false -- Don't show mode (statusline handles it)
opt.cmdheight = 1 -- Command line height
opt.pumheight = 10 -- Max completion popup height
opt.pumblend = 10 -- Popup transparency

-- Whitespace characters
opt.list = true
opt.listchars = { tab = '▏ ', trail = '·', nbsp = '␣', extends = '»', precedes = '«' }

-- Fill characters
opt.fillchars:append { diff = '╱', eob = ' ' }

-- Window borders
opt.winborder = 'single'

-- Scrolling
opt.scrolloff = 8 -- Lines of context above/below cursor
opt.sidescrolloff = 8 -- Columns of context left/right of cursor
opt.smoothscroll = true -- Smooth scrolling for Ctrl-d/u

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Editing                                     │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Smart auto-indenting
opt.shiftround = true -- Round indent to multiple of shiftwidth
opt.tabstop = 2 -- Number of spaces tabs count for
opt.shiftwidth = 2 -- Size of an indent
opt.breakindent = true -- Indent wrapped lines

-- Search
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Case-sensitive if uppercase present
opt.inccommand = 'split' -- Preview substitutions live

-- Completion
opt.completeopt = 'fuzzy,menu,menuone,noselect'

-- Undo/backup
opt.undofile = true -- Persistent undo
opt.undolevels = 10000 -- More undo levels
opt.swapfile = false -- Disable swap files
opt.backup = false -- Disable backup files

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Windows                                     │
-- ╰──────────────────────────────────────────────────────────────────────────╯

opt.splitright = true -- Split vertical window to the right
opt.splitbelow = true -- Split horizontal window to the bottom
opt.splitkeep = 'screen' -- Keep text on same screen line when splitting

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Performance                                 │
-- ╰──────────────────────────────────────────────────────────────────────────╯

opt.updatetime = 200 -- Faster CursorHold and swap file writes
opt.timeout = true
opt.timeoutlen = 300 -- Time to wait for a mapped sequence

-- Reduce redraw frequency for better performance
opt.lazyredraw = false -- Disabled for noice.nvim compatibility
opt.redrawtime = 1500 -- Time for syntax highlighting

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Folding                                     │
-- ╰──────────────────────────────────────────────────────────────────────────╯

opt.foldcolumn = '0'
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Grep/Search                                 │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Use ripgrep if available
if vim.fn.executable 'rg' == 1 then
  opt.grepprg = 'rg --vimgrep --smart-case --hidden'
  opt.grepformat = '%f:%l:%c:%m'
end

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              File Types                                  │
-- ╰──────────────────────────────────────────────────────────────────────────╯

vim.filetype.add {
  filename = {
    ['docker-compose.yml'] = 'yaml.docker-compose',
    ['docker-compose.yaml'] = 'yaml.docker-compose',
    ['compose.yml'] = 'yaml.docker-compose',
    ['compose.yaml'] = 'yaml.docker-compose',
  },
}
