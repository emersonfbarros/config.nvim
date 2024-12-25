return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = 'AndreM222/copilot-lualine',
  opts = {
    options = {
      icons_enabled = true,
      component_separators = '|',
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
          function()
            local buffers = vim.api.nvim_list_bufs()
            local count = 0
            for _, buf in ipairs(buffers) do
              if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= '' then
                count = count + 1
              end
            end
            return string.format('(%d)', count)
          end,
        },
        {
          'filename',
          path = 1,
        },
      },
      lualine_x = { 'copilot', 'encoding', 'fileformat', 'filetype' },
    },
  },
}
