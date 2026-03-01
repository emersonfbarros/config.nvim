return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  cmd = 'ConformInfo',
  keys = require('config.keymaps.plugins').conform,
  opts = function()
    local function js_formatter()
      return function(bufnr)
        local has_prettier = vim.fs.root(bufnr, {
          '.prettierrc',
          '.prettierrc.json',
          '.prettierrc.yml',
          '.prettierrc.yaml',
          '.prettierrc.json5',
          '.prettierrc.js',
          '.prettierrc.cjs',
          'prettier.config.js',
          'prettier.config.cjs',
          '.prettierrc.mjs',
          'prettier.config.mjs',
          '.prettierrc.toml',
        }) ~= nil
        return has_prettier and { 'prettier' } or { 'biome' }
      end
    end

    return {
      formatters_by_ft = {
        css = { 'prettier' },
        go = { 'gofumpt' },
        html = { 'prettier' },
        javascript = js_formatter(),
        javascriptreact = js_formatter(),
        json = { 'jq' },
        lua = { 'stylua' },
        markdown = { 'prettier' },
        nix = { 'nixfmt' },
        nu = { 'nufmt' },
        proto = { 'buf' },
        sh = { 'shfmt' },
        typescript = js_formatter(),
        typescriptreact = js_formatter(),
        yaml = { 'prettier' },
        ['_'] = { 'trim_whitespace', 'trim_newlines' },
      },
      default_format_opts = {
        lsp_format = 'fallback',
      },
      inherit = true,
      formatters = {
        golines = {
          prepend_args = { '-m', '150' },
        },
        shfmt = {
          prepend_args = { '-i', '2' },
        },
      },
    }
  end,
  init = function()
    -- Use conform for gq formatting
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
