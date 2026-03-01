return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- Adapters
    'fredrikaverpil/neotest-golang',
    'nvim-neotest/neotest-jest',
  },
  keys = require('config.keymaps.plugins').neotest,
  config = function()
    local neotest_ns = vim.api.nvim_create_namespace 'neotest'
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          return diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
        end,
      },
    }, neotest_ns)

    ---@diagnostic disable-next-line: missing-fields
    require('neotest').setup {
      adapters = {
        require 'neotest-golang' {
          go_list_args = { '-tags=wireinject,integration' },
          go_test_args = {
            '-v',
            '-count=1',
            '-race',
            '-coverprofile=' .. vim.fn.getcwd() .. '/coverage.out',
            '-parallel=1',
            '-tags=wireinject,integration',
          },
        },
        require 'neotest-jest' {
          jestCommand = 'npm test --',
          jestConfigFile = 'jest.config.js',
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        },
      },
      discovery = {
        enabled = true,
        concurrent = 0,
      },
      running = {
        concurrent = true,
      },
      summary = {
        animated = true,
      },
      status = {
        virtual_text = true,
      },
      output = {
        open_on_run = false,
      },
      quickfix = {
        open = function()
          vim.cmd 'Trouble qflist toggle'
        end,
      },
    }
  end,
}
