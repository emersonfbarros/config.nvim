--- Auto-install and start parsers for nvim-treesitter.
local function setup_treesitter_auto()
  local function start_treesitter(bufnr)
    -- Skip special buffers
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    local buftype = vim.bo[bufnr].buftype
    if buftype ~= '' then
      return
    end

    local filetype = vim.bo[bufnr].filetype
    if filetype == '' then
      return
    end

    -- Get parser name based on filetype
    local parser_name = vim.treesitter.language.get_lang(filetype)
    if not parser_name then
      return
    end

    -- Check if parser is available in configs
    local ok, parser_configs = pcall(require, 'nvim-treesitter.parsers')
    if not ok or not parser_configs[parser_name] then
      return
    end

    -- Check if parser is installed
    local parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)

    -- If not installed, install parser synchronously
    if not parser_installed then
      require('nvim-treesitter').install({ parser_name }):wait(30000)
      vim.notify('Installed parser: ' .. parser_name, vim.log.levels.INFO, { title = 'Treesitter' })
      parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)
    end

    -- Start treesitter highlighting
    if parser_installed then
      vim.treesitter.start(bufnr, parser_name)
    end
  end

  local group = vim.api.nvim_create_augroup('nvim-treesitter-auto', { clear = true })

  -- Handle FileType event - this fires when filetype is detected/changed
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    callback = function(event)
      start_treesitter(event.buf)
    end,
  })

  -- Also handle BufWinEnter for files that already have a filetype
  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = group,
    callback = function(event)
      start_treesitter(event.buf)
    end,
  })
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    branch = 'main',
    lazy = vim.fn.argc(-1) == 0, -- Load early when opening a file from cmdline
    event = { 'BufReadPre', 'BufNewFile', 'VeryLazy' },
    cmd = { 'TSUpdate', 'TSInstall', 'TSUninstall', 'TSModuleInfo' },
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-context',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {
          max_lines = 3,
          multiline_threshold = 1,
        },
        keys = require('config.keymaps.plugins').treesitter_context,
      },
    },
    opts = {
      ensure_installed = {},
      highlight = {
        enable = true,
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          return ok and stats and stats.size > max_filesize
        end,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-Space>',
          node_incremental = '<C-Space>',
          scope_incremental = false,
          node_decremental = '<BS>',
        },
      },
    },
    config = function(_, opts)
      -- Apply opts (not using configs.setup for main branch)
      _ = opts -- Future: apply opts if needed

      setup_treesitter_auto()

      -- Default folding
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        move = {
          set_jumps = true,
        },
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = '<C-v>',
          },
          include_surrounding_whitespace = false,
        },
      }

      local move = require 'nvim-treesitter-textobjects.move'
      local select = require 'nvim-treesitter-textobjects.select'
      local ts_repeat = require 'nvim-treesitter-textobjects.repeatable_move'

      local map = vim.keymap.set
      local nxo = { 'n', 'x', 'o' }
      local xo = { 'x', 'o' }

      -- Movement keymaps
      local function map_move(modes, lhs, fn, query, group, desc)
        map(modes, lhs, function()
          fn(query, group)
        end, { desc = desc })
      end

      local function map_select(modes, lhs, query, group, desc)
        map(modes, lhs, function()
          select.select_textobject(query, group)
        end, { desc = desc })
      end

      -- Next/Previous function
      map_move(nxo, ']m', move.goto_next_start, '@function.outer', 'textobjects', 'Next function start')
      map_move(nxo, ']M', move.goto_next_end, '@function.outer', 'textobjects', 'Next function end')
      map_move(nxo, '[m', move.goto_previous_start, '@function.outer', 'textobjects', 'Prev function start')
      map_move(nxo, '[M', move.goto_previous_end, '@function.outer', 'textobjects', 'Prev function end')

      -- Next/Previous class
      map_move(nxo, ']]', move.goto_next_start, '@class.outer', 'textobjects', 'Next class start')
      map_move(nxo, '][', move.goto_next_end, '@class.outer', 'textobjects', 'Next class end')
      map_move(nxo, '[[', move.goto_previous_start, '@class.outer', 'textobjects', 'Prev class start')
      map_move(nxo, '[]', move.goto_previous_end, '@class.outer', 'textobjects', 'Prev class end')

      -- Other movements
      map_move(nxo, ']o', move.goto_next_start, { '@loop.inner', '@loop.outer' }, 'textobjects', 'Next loop')
      map_move(nxo, '[o', move.goto_previous_start, { '@loop.inner', '@loop.outer' }, 'textobjects', 'Prev loop')
      map_move(nxo, ']s', move.goto_next_start, '@local.scope', 'locals', 'Next scope')
      map_move(nxo, '[s', move.goto_previous_start, '@local.scope', 'locals', 'Prev scope')
      map_move(nxo, ']a', move.goto_next_start, '@parameter.outer', 'textobjects', 'Next argument')
      map_move(nxo, '[a', move.goto_previous_start, '@parameter.outer', 'textobjects', 'Prev argument')

      -- Text object selections
      map_select(xo, 'af', '@function.outer', 'textobjects', 'Around function')
      map_select(xo, 'if', '@function.inner', 'textobjects', 'Inside function')
      map_select(xo, 'ac', '@class.outer', 'textobjects', 'Around class')
      map_select(xo, 'ic', '@class.inner', 'textobjects', 'Inside class')
      map_select(xo, 'aa', '@parameter.outer', 'textobjects', 'Around argument')
      map_select(xo, 'ia', '@parameter.inner', 'textobjects', 'Inside argument')
      map_select(xo, 'ai', '@conditional.outer', 'textobjects', 'Around conditional')
      map_select(xo, 'ii', '@conditional.inner', 'textobjects', 'Inside conditional')
      map_select(xo, 'al', '@loop.outer', 'textobjects', 'Around loop')
      map_select(xo, 'il', '@loop.inner', 'textobjects', 'Inside loop')

      -- Repeatable movements with ; and ,
      map(nxo, ';', ts_repeat.repeat_last_move_next, { desc = 'Repeat last move (next)' })
      map(nxo, ',', ts_repeat.repeat_last_move_previous, { desc = 'Repeat last move (prev)' })

      -- Make builtin f, F, t, T also repeatable
      map(nxo, 'f', ts_repeat.builtin_f_expr, { expr = true, desc = 'Find char forward' })
      map(nxo, 'F', ts_repeat.builtin_F_expr, { expr = true, desc = 'Find char backward' })
      map(nxo, 't', ts_repeat.builtin_t_expr, { expr = true, desc = 'Till char forward' })
      map(nxo, 'T', ts_repeat.builtin_T_expr, { expr = true, desc = 'Till char backward' })
    end,
  },
}
