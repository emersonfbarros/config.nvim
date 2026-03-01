return {
  {
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
              ui = {
                bg_gutter = 'none',
              },
            },
          },
        },

        ---@param colors KanagawaColorsSpec
        overrides = function(colors)
          return {
            WinSeparator = { fg = colors.palette.dragonBlack6 },
          }
        end,
      }

      vim.cmd.colorscheme 'kanagawa-dragon'
    end,
  },
}
