---@return table
return {
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          rangeVariableTypes = true,
          parameterNames = true,
          constantValues = true,
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          functionTypeParameters = true,
        },
        analyses = {
          fieldalignment = true,
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
        semanticTokens = true,
      },
    },
    on_attach = function(client, _)
      if not client.server_capabilities.semanticTokensProvider then
        local semantic = client.config.capabilities.textDocument.semanticTokens
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = {
            tokenTypes = semantic.tokenTypes,
            tokenModifiers = semantic.tokenModifiers,
          },
          range = true,
        }
      end
    end,
  },
  lua_ls = {
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
  },
  taplo = {
    on_attach = function(_, bufnr)
      vim.keymap.set('n', 'K', function()
        if vim.fn.expand '%:t' == 'Cargo.toml' and require('crates').popup_available() then
          require('crates').show_popup()
        else
          vim.lsp.buf.hover()
        end
      end, { buffer = bufnr, desc = 'Show Crate Documentation' })
    end,
  },
  omnisharp = {
    cmd = { 'OmniSharp' },
    settings = {
      FormattingOptions = {
        EnableEditorConfigSupport = true,
        OrganizeImports = true,
      },
      RoslynExtensionsOptions = {
        EnableImportCompletion = true,
        EnableAnalyzersSupport = true,
      },
    },
    handlers = {
      ['textDocument/definition'] = function()
        require('omnisharp_extended').definition_handler()
      end,
      ['textDocument/typeDefinition'] = function()
        require('omnisharp_extended').type_definition_handler()
      end,
      ['textDocument/references'] = function()
        require('omnisharp_extended').references_handler()
      end,
      ['textDocument/implementation'] = function()
        require('omnisharp_extended').implementation_handler()
      end,
    },
    on_attach = function(_, bufnr)
      vim.keymap.set('n', 'gr', function()
        require('omnisharp_extended').telescope_lsp_references()
      end, { buffer = bufnr, desc = '[G]oto [R]eferences' })

      vim.keymap.set('n', 'gd', function()
        require('omnisharp_extended').telescope_lsp_definition()
      end, { buffer = bufnr, desc = '[G]oto [D]efinition' })

      vim.keymap.set('n', 'gI', function()
        require('omnisharp_extended').telescope_lsp_implementation()
      end, { buffer = bufnr, desc = '[G]oto [I]mplementation' })

      vim.keymap.set('n', 'gD', function()
        require('omnisharp_extended').telescope_lsp_type_definition()
      end, { buffer = bufnr, desc = '[G]oto Type [D]efinition' })
    end,
  },
  nixd = {
    settings = {
      nixpkgs = {
        expr = 'import <nixpkgs> { }',
      },
      formatting = {
        command = { 'nixfmt' },
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake \"/home/emerson/.dotfiles/\").nixosConfigurations.nixos.options',
        },
        home_manager = {
          expr = '(builtins.getFlake \"/home/emerson/.dotfiles/\").homeConfigurations.emerson.options',
        },
      },
    },
  },
  dockerls = {},
  docker_compose_language_service = {},
  bashls = {},
  jsonls = {},
  marksman = {},
}
