return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    'AndreM222/copilot-lualine',
  },
  opts = {
    options = {
      icons_enabled = true,
      component_separators = ' ▎',
      section_separators = '',
      globalstatus = true,
      theme = 'kanagawa',
    },
    sections = {
      lualine_a = {
        {
          function()
            return ''
          end,
          separator = '',
        },
        'mode',
      },
      lualine_c = {
        {
          'filename',
          path = 1,
        },
      },
      lualine_x = { 'copilot', 'encoding', 'fileformat', 'filetype' },
    },
  },
}
