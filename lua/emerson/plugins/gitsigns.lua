return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    signs_staged = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
    },
    attach_to_untracked = true,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      map('n', ']h', gs.next_hunk, 'Next Hunk')
      map('n', '[h', gs.prev_hunk, 'Prev Hunk')
      map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', '[G]it [H]unk [S]tage')
      map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', '[G]it [H]unk [R]eset')
      map('n', '<leader>ghS', gs.stage_buffer, '[G]it [H]unk [S]tage Buffer')
      map('n', '<leader>ghu', gs.undo_stage_hunk, '[G]it [H]unk [U]ndo Stage')
      map('n', '<leader>ghR', gs.reset_buffer, '[G]it [R]eset [B]uffer')
      map('n', '<leader>ghp', gs.preview_hunk_inline, '[G]it [P]review [H]unk')
      map('n', '<leader>ghb', gs.blame_line, '[G]it [H]unk [B]lame')
      map('n', '<leader>ghB', function()
        gs.blame_line { full = true }
      end, '[G]it [H]unk [B]lame Full')
      map('n', '<leader>ghd', gs.diffthis, '[G]it [H]unk [D]iff')
      map('n', '<leader>ghD', function()
        gs.diffthis '~'
      end, '[G]it [H]unk [D]iff This ~')
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
    end,
  },
}
