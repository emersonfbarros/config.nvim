return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      {
        'j-hui/fidget.nvim',
        opts = {
          integration = {
            ['nvim-tree'] = {
              enable = false,
            },
          },
        },
        lazy = true,
      },
      { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim', opts = {}, lazy = true },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('nvim-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
          end

          local telescope_cmd = function(builtin)
            return '<cmd>Telescope ' .. builtin .. '<CR>'
          end

          map('gd', telescope_cmd 'lsp_definitions', '[G]oto [D]efinition')
          map('gr', telescope_cmd 'lsp_references', '[G]oto [R]eferences')
          map('gI', telescope_cmd 'lsp_implementations', '[G]oto [I]mplementation')
          map('gD', telescope_cmd 'lsp_type_definitions', '[G]oto Type [D]efinition')
          map('gC', vim.lsp.buf.declaration, '[G]oto De[c]laration')
          map('<leader>cs', telescope_cmd 'lsp_document_symbols', '[C]ode doc [S]ymbols')
          map('<leader>cS', telescope_cmd 'lsp_dynamic_workspace_symbols', '[C]ode workspace [S]ymbols')
          map('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>ch', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
            end, '[C]ode inlay [H]ints')
          end
        end,
        vim.diagnostic.config { virtual_text = false },
      })

      -- Lsps
      local servers = require 'emerson.servers'
      local lspconfig = require 'lspconfig'

      -- Extending lsp capabilites
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      for server, opts in pairs(servers) do
        opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, opts.capabilities or {})
        lspconfig[server].setup(opts)
      end
    end,
  },
}
