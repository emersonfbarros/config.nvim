return {
  'stevearc/conform.nvim',
  cmd = 'ConformInfo',
  keys = {
    {
      '<leader>cp',
      mode = { 'n', 'v' },
      function()
        require('conform').format {
          lsp_format = 'first',
        }
      end,
      desc = '[C]ode [P]retty',
    },
  },
  opts = {
    formatters_by_ft = {
      go = { 'gofmt', 'golines', 'goimports' },
      javascript = { 'biome-check' },
      typescript = { 'biome-check' },
      javascriptreact = { 'biome-check' },
      typescriptreact = { 'biome-check' },
      css = { 'prettier' },
      html = { 'prettier' },
      json = { 'jq' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      lua = { 'stylua' },
      sh = { 'shfmt' },
      proto = { 'buf' },
    },
    format_on_save = nil,
  },
}
