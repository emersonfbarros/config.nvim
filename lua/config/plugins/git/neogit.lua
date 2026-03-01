return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'esmuellert/codediff.nvim',
      'folke/snacks.nvim',
    },
    cmd = 'Neogit',
    keys = require('config.keymaps.plugins').neogit,
    opts = {
      graph_style = 'kitty',
    },
  },
}
