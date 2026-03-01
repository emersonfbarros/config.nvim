local M = {}

--- Setup LSP keymaps and buffer-local settings
---@param client vim.lsp.Client
---@param bufnr number
function M.on_attach(client, bufnr)
  -- Setup keymaps
  require 'config.keymaps.lsp'(bufnr)

  -- LSP-based folding
  if client.supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange, bufnr) then
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'v:lua.vim.lsp.foldexpr()'
  end
end

--- Configure diagnostics
function M.setup_diagnostics()
  vim.diagnostic.config {
    severity_sort = true,
    float = {
      border = 'single',
      source = true,
      header = '',
      prefix = '',
    },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    },
    virtual_text = {
      source = true,
      spacing = 2,
      prefix = '●',
    },
  }
end

return M
