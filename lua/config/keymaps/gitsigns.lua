--- Gitsigns keymaps - used in on_attach callback
--- Returns a function that sets up keymaps for a buffer
---@param bufnr number
return function(bufnr)
  local gs = require 'gitsigns'

  local function map(mode, l, r, desc)
    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
  end

  -- Navigation
  map('n', ']h', function()
    if vim.wo.diff then
      vim.cmd.normal { ']c', bang = true }
    else
      gs.nav_hunk 'next'
    end
  end, 'Next Hunk')

  map('n', '[h', function()
    if vim.wo.diff then
      vim.cmd.normal { '[c', bang = true }
    else
      gs.nav_hunk 'prev'
    end
  end, 'Prev Hunk')

  -- Actions
  map('n', '<leader>ghs', gs.stage_hunk, 'Stage Hunk')
  map('n', '<leader>ghr', gs.reset_hunk, 'Reset Hunk')
  map('v', '<leader>ghs', function()
    gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
  end, 'Stage Hunk')
  map('v', '<leader>ghr', function()
    gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
  end, 'Reset Hunk')
  map('n', '<leader>ghS', gs.stage_buffer, 'Stage Buffer')
  map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')
  map('n', '<leader>ghR', gs.reset_buffer, 'Reset Buffer')
  map('n', '<leader>ghp', gs.preview_hunk_inline, 'Preview Hunk Inline')
  map('n', '<leader>ghb', function()
    gs.blame_line { full = false }
  end, 'Blame Line')
  map('n', '<leader>ghB', function()
    gs.blame_line { full = true }
  end, 'Blame Line (full)')
  map('n', '<leader>ghd', gs.diffthis, 'Diff This')
  map('n', '<leader>ghD', function()
    gs.diffthis '~'
  end, 'Diff This ~')

  -- Text object
  map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Select Hunk')
end
