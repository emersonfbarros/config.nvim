return {
  'rebelot/heirline.nvim',
  event = 'UIEnter',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'lewis6991/gitsigns.nvim',
  },
  config = function()
    require 'config.ui.heirline'
  end,
}
