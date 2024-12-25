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
  vtsls = {
    settings = (function()
      local lang_opts = {
        updateImportsOnFileMove = { enabled = 'always' },
        suggest = {
          completeFunctionCalls = true,
        },
        preferences = {
          quoteStyle = 'auto',
          importModuleSpecifierEnding = 'minimal',
          importModuleSpecifier = 'shortest',
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = 'literals' },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      }

      return {
        typescript = lang_opts,
        javascript = lang_opts,
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            maxInlayHintLength = 30,
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
      }
    end)(),
    on_attach = function(client, bufnr) -- adapted from LazyVim config
      client.commands['_typescript.moveToFileRefactoring'] = function(command, _)
        ---@type string, string, lsp.Range
        local action, uri, range = unpack(command.arguments)

        local function move(newf)
          client.request('workspace/executeCommand', {
            command = command.command,
            arguments = { action, uri, range, newf },
          })
        end

        local fname = vim.uri_to_fname(uri)
        client.request('workspace/executeCommand', {
          command = 'typescript.tsserverRequest',
          arguments = {
            'getMoveToRefactoringFileSuggestions',
            {
              file = fname,
              startLine = range.start.line + 1,
              startOffset = range.start.character + 1,
              endLine = range['end'].line + 1,
              endOffset = range['end'].character + 1,
            },
          },
        }, function(_, result)
          ---@type string[]
          local files = result.body.files
          table.insert(files, 1, 'Enter new path...')
          vim.ui.select(files, {
            prompt = 'Select move destination:',
            format_item = function(f)
              return vim.fn.fnamemodify(f, ':~:.')
            end,
          }, function(f)
            if f and f:find '^Enter new path' then
              vim.ui.input({
                prompt = 'Enter move destination:',
                default = vim.fn.fnamemodify(fname, ':h') .. '/',
                completion = 'file',
              }, function(newf)
                return newf and move(newf)
              end)
            elseif f then
              move(f)
            end
          end)
        end)
      end

      ---@class LspCommand: lsp.ExecuteCommandParams
      ---@field open? boolean
      ---@field handler? lsp.Handler

      ---@param opts LspCommand
      local function lsp_exec(opts)
        local params = {
          command = opts.command,
          arguments = opts.arguments,
        }
        if opts.open then
          require('trouble').open {
            mode = 'lsp_command',
            params = params,
          }
        else
          return vim.lsp.buf_request(0, 'workspace/executeCommand', params, opts.handler)
        end
      end

      local lsp_action = setmetatable({}, {
        __index = function(_, action)
          return function()
            vim.lsp.buf.code_action {
              apply = true,
              context = {
                only = { action },
                diagnostics = {},
              },
            }
          end
        end,
      })

      vim.keymap.set('n', 'gS', function()
        local params = vim.lsp.util.make_position_params()
        lsp_exec {
          command = 'typescript.goToSourceDefinition',
          arguments = { params.textDocument.uri, params.position },
          open = true,
        }
      end, { buffer = bufnr, desc = '[G]oto [S]ource Definition' })

      vim.keymap.set('n', 'gR', function()
        lsp_exec {
          command = 'typescript.findAllFileReferences',
          arguments = { vim.uri_from_bufnr(0) },
          open = true,
        }
      end, { buffer = bufnr, desc = 'File References' })

      vim.keymap.set(
        'n',
        '<leader>co',
        lsp_action['source.organizeImports'],
        { buffer = bufnr, desc = 'Organize Imports' }
      )

      vim.keymap.set(
        'n',
        '<leader>cM',
        lsp_action['source.addMissingImports.ts'],
        { buffer = bufnr, desc = 'Add missing imports' }
      )

      vim.keymap.set(
        'n',
        '<leader>cu',
        lsp_action['source.removeUnused.ts'],
        { buffer = bufnr, desc = 'Remove unused imports' }
      )

      vim.keymap.set(
        'n',
        '<leader>cD',
        lsp_action['source.fixAll.ts'],
        { buffer = bufnr, desc = 'Fix all diagnostics' }
      )

      vim.keymap.set('n', '<leader>cV', function()
        lsp_exec { command = 'typescript.selectTypeScriptVersion' }
      end, { buffer = bufnr, desc = 'Select TS workspace version' })
    end,
  },
  dockerls = {},
  docker_compose_language_service = {},
  bashls = {},
  marksman = {},
  jsonls = {},
  html = {},
  cssls = {},
  eslint = {},
  biome = {},
}
