return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('kanagawa').setup {
      compile = true,

      ---@param colors KanagawaColorsSpec
      overrides = function(colors)
        return {
          IndentLine = { fg = colors.palette.dragonBlack5 },
          IndentLineCurrent = { fg = colors.palette.dragonBlue2 },
          WinSeparator = { fg = colors.palette.dragonBlack5 },
        }
      end,
    }

    vim.cmd.colorscheme 'kanagawa-dragon'
  end,
}
