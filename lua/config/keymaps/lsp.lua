--- LSP keymaps - used in LspAttach autocmd
--- Returns a function that sets up keymaps for a buffer
---@param bufnr number
return function(bufnr)
  local function map(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  -- Navigation
  map('gd', Snacks.picker.lsp_definitions, 'Goto Definition')
  map('gr', Snacks.picker.lsp_references, 'Goto References')
  map('gI', Snacks.picker.lsp_implementations, 'Goto Implementation')
  map('gy', Snacks.picker.lsp_type_definitions, 'Goto Type Definition')
  map('gD', Snacks.picker.lsp_declarations, 'Goto Declaration')

  -- Code actions and refactoring
  map('<leader>cr', vim.lsp.buf.rename, 'Rename symbol')
  map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
  map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', 'v')

  -- Symbols
  map('<leader>cs', Snacks.picker.lsp_symbols, 'Document Symbols')
  map('<leader>cS', Snacks.picker.lsp_workspace_symbols, 'Workspace Symbols')

  -- Documentation
  map('<C-x>', vim.lsp.buf.signature_help, 'Signature Help', 'i')

  -- Word navigation (LSP references)
  map(']]', function()
    Snacks.words.jump(vim.v.count1, true)
  end, 'Next Reference')
  map('[[', function()
    Snacks.words.jump(-vim.v.count1, true)
  end, 'Prev Reference')
end
