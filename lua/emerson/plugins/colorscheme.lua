return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('kanagawa').setup {
      compile = true,
      overrides = function(colors)
        return {
          IndentLine = { fg = colors.palette.dragonBlack5 },
          IndentLineCurrent = { fg = colors.palette.dragonBlue2 },
        }
      end,
    }

    vim.cmd.colorscheme 'kanagawa-dragon'
  end,
}
