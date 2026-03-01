return {
  'otavioschwanck/arrow.nvim',
  keys = require('config.keymaps.plugins').arrow,
  opts = {
    show_icons = true,
    leader_key = '<leader>;',
    buffer_leader_key = '<leader>m',
    separate_by_branch = true,
    mappings = {
      edit = 'e',
      delete_mode = 'd',
      clear_all_items = 'C',
      toggle = 's',
      open_vertical = 'v',
      open_horizontal = '-',
      quit = 'q',
      remove = 'x',
      next_item = ']',
      prev_item = '[',
    },
  },
}
