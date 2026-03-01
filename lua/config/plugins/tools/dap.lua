return {
  'mfussenegger/nvim-dap',
  dependencies = {
    {
      'rcarriga/nvim-dap-ui',
      dependencies = { 'nvim-neotest/nvim-nio' },
      opts = {},
      config = function(_, opts)
        local dap = require 'dap'
        local dapui = require 'dapui'
        dapui.setup(opts)

        -- Auto open/close UI
        dap.listeners.before.attach.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
          dapui.close()
        end
      end,
    },
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = {},
    },
    {
      'leoluz/nvim-dap-go',
      ft = 'go',
      opts = {},
    },
  },
  keys = require('config.keymaps.plugins').dap,
  config = function()
    local dap = require 'dap'

    -- JavaScript/TypeScript adapter
    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'js-debug',
        args = { '${port}' },
      },
    }

    dap.configurations.javascript = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        cwd = '${workspaceFolder}',
      },
    }

    dap.configurations.typescript = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch file with ts-node',
        sourceMaps = true,
        resolveSourceMapLocations = {
          '${workspaceFolder}/**',
          '!**/node_modules/**',
        },
        protocol = 'inspector',
        runtimeExecutable = 'node',
        runtimeArgs = { '-r', 'ts-node/register' },
        program = '${workspaceFolder}/src/index.ts',
        cwd = '${workspaceFolder}',
      },
    }
  end,
}
