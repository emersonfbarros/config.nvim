return {
  'nvimtools/none-ls.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local null_ls = require 'null-ls'

    null_ls.setup {
      sources = {
        -- Code actions
        null_ls.builtins.code_actions.gomodifytags,
        null_ls.builtins.code_actions.impl,
        null_ls.builtins.code_actions.statix,

        -- Diagnostics
        null_ls.builtins.diagnostics.checkmake,
        null_ls.builtins.diagnostics.editorconfig_checker,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.statix,
      },
    }
  end,
}
