--- Aggregates all LSP server configurations
--- Each server module returns its configuration table

local M = {}

-- Complex servers with extensive configuration
M.gopls = require 'config.lsp.servers.gopls'
M.vtsls = require 'config.lsp.servers.vtsls'

-- Servers with moderate configuration
M.lua_ls = {
  settings = {
    Lua = {
      hint = {
        enable = true,
      },
      completion = {
        callSnippet = 'Replace',
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      codeLens = {
        enable = true,
      },
    },
  },
}

M.taplo = {
  on_attach = function(_, bufnr)
    vim.keymap.set('n', 'K', function()
      if vim.fn.expand '%:t' == 'Cargo.toml' and require('crates').popup_available() then
        require('crates').show_popup()
      else
        vim.lsp.buf.hover()
      end
    end, { buffer = bufnr, desc = 'Show Crate Documentation' })
  end,
}

M.nixd = {
  settings = {
    nixpkgs = {
      expr = 'import <nixpkgs> { }',
    },
    formatting = {
      command = { 'nixfmt' },
    },
    options = {
      nixos = {
        expr = '(builtins.getFlake "/home/emerson/.dotfiles/").nixosConfigurations.nixos.options',
      },
      home_manager = {
        expr = '(builtins.getFlake "/home/emerson/.dotfiles/").homeConfigurations.emerson.options',
      },
    },
  },
}

-- Simple servers (no custom configuration)
M.terraformls = {}
M.golangci_lint_ls = {}
M.protols = {}
M.statix = {}
M.dockerls = {}
M.docker_compose_language_service = {}
M.bashls = {}
M.jsonls = {}
M.html = {}
M.cssls = {}
M.eslint = {}
M.biome = {}
M.astro = {}
M.nushell = {}

return M
