return {
  'otavioschwanck/arrow.nvim',
  cmd = 'Arrow',
  keys = {
    '<leader>;',
    mode = { 'n', 'v' },
    '<cdm>Arrow open<CR>',
    desc = 'Arrow open',
  },
  opts = {
    show_icons = true,
    leader_key = '<leader>;',
    buffer_leader_key = '<leader>m', -- Per Buffer Mappings
    separate_by_branch = true,
  },
}
