return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'saghen/blink.cmp',
      'folke/snacks.nvim',
      {
        'j-hui/fidget.nvim',
        event = 'LspAttach',
        opts = {
          notification = {
            window = {
              winblend = 0,
            },
          },
        },
      },
    },
    config = function()
      local lsp = require 'config.lsp'

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('nvim-lsp-attach', { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          lsp.on_attach(client, bufnr)
        end,
      })

      -- Setup diagnostics
      lsp.setup_diagnostics()

      -- Load server configurations
      local servers = require 'config.lsp.servers'

      -- Extend LSP capabilities with blink.cmp
      local blink_cmp_capabilities = require('blink.cmp').get_lsp_capabilities()
      local client_capabilities = vim.lsp.protocol.make_client_capabilities()
      local merged_capabilities = vim.tbl_deep_extend('force', {}, client_capabilities, blink_cmp_capabilities)

      -- Configure and enable each server
      -- vim.lsp.config() merges with defaults from nvim-lspconfig's lsp/ folder
      -- We add our custom settings on top of those defaults
      for server, opts in pairs(servers) do
        -- Merge capabilities (our custom + blink.cmp + any server-specific)
        opts.capabilities = vim.tbl_deep_extend('force', {}, merged_capabilities, opts.capabilities or {})

        -- vim.lsp.config() will deep-merge with the defaults from lsp/<server>.lua
        -- This preserves cmd, filetypes, root_dir from nvim-lspconfig while adding our settings
        vim.lsp.config(server, opts)
        vim.lsp.enable(server)
      end
    end,
  },
}
