return {
  'nvimdev/indentmini.nvim',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  opts = {
    char = '▏',
    exclude = {
      'help',
      'lazy',
      'mason',
      'terminal',
      'nofile',
      'NvimTree',
    },
  },
}
