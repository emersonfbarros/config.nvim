return {
  'nvimtools/none-ls.nvim',
  event = 'VeryLazy',
  config = function()
    local null_ls = require 'null-ls'

    null_ls.setup {
      sources = {
        null_ls.builtins.code_actions.gomodifytags,
        null_ls.builtins.code_actions.impl,
        null_ls.builtins.code_actions.statix,

        null_ls.builtins.diagnostics.checkmake,
        null_ls.builtins.diagnostics.commitlint,
        null_ls.builtins.diagnostics.editorconfig_checker,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.buf,
        null_ls.builtins.diagnostics.statix,
      },
    }
  end,
}
