local live_grep_filtered = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()
  local finder = require('telescope.finders').new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == '' then
        return nil
      end

      local pieces = vim.split(prompt, '  ') -- two spaces
      local args = { 'rg' }
      if pieces[1] then
        table.insert(args, '-e') -- for rg takes regex
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, '-g') -- for glob option, like `*.lua`
        table.insert(args, pieces[2])
      end

      return vim
        .iter({ args, { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' } })
        :flatten()
        :totable()
    end,
    entry_maker = require('telescope.make_entry').gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  require('telescope.pickers')
    .new(opts, {
      prompt_title = 'Live grep (with filtering)',
      finder = finder,
      debounce = 100,
      previewer = require('telescope.config').values.grep_previewer(opts),
      sorter = require('telescope.sorters').empty(),
    })
    :find()
end

return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  config = function()
    local telescope = require 'telescope'

    local open_with_trouble = require('trouble.sources.telescope').open
    telescope.setup {
      defaults = {
        prompt_prefix = ' ',
        selection_caret = ' ',
        layout_config = {
          horizontal = { width = 0.94 },
        },
        borderchars = { -- squaring stuff
          --           N    E    S    W   NW   NE   SE   SW
          prompt = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          results = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        },
        mappings = {
          i = { ['<c-t>'] = open_with_trouble },
          n = {
            ['<c-t>'] = open_with_trouble,
            -- deletes buffers with d in normal mode buffers picker
            ['d'] = require('telescope.actions').delete_buffer,
          },
        },
      },
      pickers = { -- squaring stuff
        buffers = {
          theme = 'dropdown',
          previewer = false,
          borderchars = {
            --           N    E    S    W   NW   NE   SE   SW
            prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
            results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
            preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          },
        },
      },
      extensions = { fzf = {} },
    }
    telescope.load_extension 'fzf'
  end,
  keys = {
    -- Some stuff
    {
      '<leader><leader>',
      '<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>',
      desc = '[ ] Find existing buffers',
    },
    {
      '<leader>/',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end,
      desc = '[/] Fuzzily search in current buffer',
    },
    -- Search stuff
    {
      '<leader>s/',
      function()
        require('telescope.builtin').live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end,
      desc = '[S]earch [/] in Open Files',
    },
    {
      '<leader>sf',
      '<cmd>Telescope find_files<CR>',
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>sg',
      live_grep_filtered,
      desc = '[S]earch by [G]rep with filters',
    },
    {
      '<leader>sw',
      '<cmd>Telescope grep_string<CR>',
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader>sd',
      function()
        require('telescope.builtin').diagnostics { bufnr = 0 }
      end,
      desc = '[S]earch document [D]iagnostics',
    },
    {
      '<leader>sD',
      '<cmd>Telescope diagnostics<CR>',
      desc = '[S]earch workspace [D]iagnostics',
    },
    {
      '<leader>sk',
      '<cmd>Telescope keymaps<CR>',
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>sh',
      '<cmd>Telescope help_tags<CR>',
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sr',
      '<cmd>Telescope registers<CR>',
      desc = '[S]earch [R]egisters',
    },
    -- Git stuff
    {
      '<leader>gf',
      '<cmd>Telescope git_files<CR>',
      desc = '[G]it [F]iles',
    },
    {
      '<leader>gc',
      '<cmd>Telescope git_commits<CR>',
      desc = '[G]it [C]ommits',
    },
    {
      '<leader>gs',
      '<cmd>Telescope git_status<CR>',
      desc = '[G]it [S]tatus',
    },
    {
      '<leader>gS',
      '<cmd>Telescope git_stash<CR>',
      desc = '[G]it [S]tashes',
    },
  },
}
