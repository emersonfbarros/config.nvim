return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('kanagawa').setup {
      compile = true,

      colors = {
        theme = {
          dragon = {
            syn = {
              parameter = '#a292a3',
              number = '#a6a69c',
            },
            ui = {
              bg_gutter = 'none',
            },
          },
        },
      },

      ---@param colors KanagawaColorsSpec
      overrides = function(colors)
        return {
          IndentLine = { fg = colors.palette.dragonBlack5 },
          IndentLineCurrent = { fg = colors.palette.dragonBlue2 },
          WinSeparator = { fg = colors.palette.dragonBlack6 },
        }
      end,
    }

    vim.cmd.colorscheme 'kanagawa-dragon'
  end,
}
