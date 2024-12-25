return {
  'RRethy/vim-illuminate',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  config = function()
    require('illuminate').configure {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { 'lsp' },
      },
      filetypes_denylist = {
        'dirbuf',
        'NeogitStatus',
        'NeogitCommitMessage',
        'neotest-summary',
        'neotest-output-panel',
        'lazy',
        'trouble',
        'mason',
        'help',
        'NvimTree',
      },
      min_count_to_highlight = 2,
    }
  end,
}
