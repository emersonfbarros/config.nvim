return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup toggles
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>ur'
        Snacks.toggle.line_number():map '<leader>ul'
        Snacks.toggle.treesitter():map '<leader>uT'
        Snacks.toggle.inlay_hints():map '<leader>uh'
        Snacks.toggle.diagnostics():map '<leader>ud'
        Snacks.toggle.indent():map '<leader>ui'
        Snacks.toggle.option('conceallevel', { off = 0, on = 2, name = 'Conceal' }):map '<leader>uc'
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
      end,
    })
  end,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    dashboard = { enabled = false },
    dim = { enabled = false },
    explorer = { enabled = true, replace_netrw = true },
    image = { enabled = false },
    indent = {
      enabled = true,
      animate = { enabled = false },
      filter = function(buf)
        local exclude = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
          'lspinfo',
          'TelescopePrompt',
          'TelescopeResults',
          'dbout',
        }
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
          return false
        end
        return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ''
      end,
    },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = {
      enabled = true,
      actions = {
        trouble_open = function(...)
          return require('trouble.sources.snacks').actions.trouble_open.action(...)
        end,
      },
      layouts = {
        default = {
          layout = {
            box = 'horizontal',
            width = 0.94,
            min_width = 126,
            height = 0.86,
            {
              box = 'vertical',
              border = 'single',
              title = '{title} {live} {flags}',
              { win = 'input', height = 1, border = 'bottom' },
              { win = 'list', border = 'none' },
            },
            { win = 'preview', title = '{preview}', border = 'single', width = 0.44 },
          },
        },
        select = { layout = { border = 'single' } },
      },
      formatters = {
        file = {
          filename_first = true,
          truncate = 80,
        },
      },
      matcher = {
        frecency = true,
      },
      sources = { explorer = { layout = { layout = { width = 54 } } } },
      win = {
        input = {
          keys = {
            ['<C-t>'] = { 'trouble_open', mode = { 'n', 'i' } },
          },
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    terminal = { enabled = true },
    styles = {
      input = { border = 'single' },
      notification = { border = 'single' },
      notification_history = { border = 'single' },
      scratch = { width = 174, height = 32, border = 'single' },
      terminal = { border = 'single' },
    },
    words = { enabled = true },
  },
  keys = require('config.keymaps.plugins').snacks,
}
