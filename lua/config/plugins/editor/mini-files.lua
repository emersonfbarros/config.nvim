return {
  'echasnovski/mini.files',
  version = '*',
  keys = require('config.keymaps.plugins').mini_files,
  opts = {
    mappings = {
      close = 'q',
      go_in = 'l',
      go_in_plus = '<CR>',
      go_out = 'h',
      go_out_plus = 'H',
      reset = '<BS>',
      reveal_cwd = '@',
      show_help = 'g?',
      synchronize = '=',
      trim_left = '<',
      trim_right = '>',
    },
    windows = {
      preview = true,
      width_focus = 30,
      width_nofocus = 15,
      width_preview = 50,
    },
  },
  config = function(_, opts)
    require('mini.files').setup(opts)

    -- LSP rename integration with Snacks
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesActionRename',
      callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
      end,
    })
  end,
}
