return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  keys = require('config.keymaps.plugins').trouble,
  opts = {
    focus = true,
  },
}
