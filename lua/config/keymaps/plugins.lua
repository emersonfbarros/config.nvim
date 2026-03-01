local M = {}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Snacks                                      │
-- ╰──────────────────────────────────────────────────────────────────────────╯

M.snacks = {
  -- Buffers
  {
    '<leader><leader>',
    function()
      Snacks.picker.buffers()
    end,
    desc = 'Find buffers',
  },
  {
    '<leader>bd',
    function()
      Snacks.bufdelete()
    end,
    desc = 'Delete buffer',
  },
  {
    '<leader>bD',
    function()
      Snacks.bufdelete.all()
    end,
    desc = 'Delete all buffers',
  },
  {
    '<leader>bo',
    function()
      Snacks.bufdelete.other()
    end,
    desc = 'Delete other buffers',
  },

  -- Explorer
  {
    '<leader>e',
    function()
      Snacks.explorer.open()
    end,
    desc = 'File Explorer',
  },

  -- Git
  {
    '<leader>gB',
    function()
      Snacks.picker.git_branches()
    end,
    desc = 'Git Branches',
  },
  {
    '<leader>gb',
    function()
      Snacks.gitbrowse.open()
    end,
    desc = 'Git Browse',
  },
  {
    '<leader>gc',
    function()
      Snacks.picker.git_diff()
    end,
    desc = 'Git Diff (changes)',
  },
  {
    '<leader>gf',
    function()
      Snacks.picker.git_files()
    end,
    desc = 'Git Files',
  },
  {
    '<leader>gl',
    function()
      Snacks.picker.git_log()
    end,
    desc = 'Git Log',
  },
  {
    '<leader>gL',
    function()
      Snacks.picker.git_log_line()
    end,
    desc = 'Git Log (line)',
  },
  {
    '<leader>gs',
    function()
      Snacks.picker.git_status()
    end,
    desc = 'Git Status',
  },
  {
    '<leader>gS',
    function()
      Snacks.picker.git_stash()
    end,
    desc = 'Git Stash',
  },

  -- GitHub (requires gh CLI)
  {
    '<leader>Gi',
    function()
      Snacks.picker.gh_issue()
    end,
    desc = 'GitHub Issues',
  },
  {
    '<leader>Gp',
    function()
      Snacks.picker.gh_pr()
    end,
    desc = 'GitHub Pull Requests',
  },
  {
    '<leader>Ga',
    function()
      Snacks.picker.gh_actions()
    end,
    desc = 'GitHub PR Actions',
  },
  {
    '<leader>Gd',
    function()
      Snacks.picker.gh_diff()
    end,
    desc = 'GitHub PR Diff',
  },

  -- Scratch
  {
    '<leader>.',
    function()
      Snacks.scratch()
    end,
    desc = 'Toggle Scratch Buffer',
  },
  {
    '<leader>S',
    function()
      Snacks.scratch.select()
    end,
    desc = 'Select Scratch Buffer',
  },

  -- Terminal
  {
    '<c-/>',
    function()
      Snacks.terminal.toggle()
    end,
    desc = 'Toggle Terminal',
    mode = { 'n', 't' },
  },
  {
    '<leader>fT',
    function()
      Snacks.terminal.toggle(nil, { win = { style = 'float' } })
    end,
    desc = 'Floating Terminal',
    mode = { 'n', 't' },
  },

  -- Search/Find
  {
    '<leader>/',
    function()
      Snacks.picker.lines()
    end,
    desc = 'Buffer Lines',
  },
  {
    '<leader>:',
    function()
      Snacks.picker.command_history()
    end,
    desc = 'Command History',
  },
  {
    '<leader>ff',
    function()
      Snacks.picker.files()
    end,
    desc = 'Find Files',
  },
  {
    '<leader>fr',
    function()
      Snacks.picker.recent()
    end,
    desc = 'Recent Files',
  },
  {
    '<leader>s/',
    function()
      Snacks.picker.grep_buffers()
    end,
    desc = 'Grep Open Buffers',
  },
  {
    '<leader>s"',
    function()
      Snacks.picker.registers()
    end,
    desc = 'Registers',
  },
  {
    '<leader>sa',
    function()
      Snacks.picker.autocmds()
    end,
    desc = 'Autocmds',
  },
  {
    '<leader>sb',
    function()
      Snacks.picker.lines()
    end,
    desc = 'Buffer Lines',
  },
  {
    '<leader>sc',
    function()
      Snacks.picker.command_history()
    end,
    desc = 'Command History',
  },
  {
    '<leader>sC',
    function()
      Snacks.picker.commands()
    end,
    desc = 'Commands',
  },
  {
    '<leader>sd',
    function()
      Snacks.picker.diagnostics_buffer()
    end,
    desc = 'Buffer Diagnostics',
  },
  {
    '<leader>sD',
    function()
      Snacks.picker.diagnostics()
    end,
    desc = 'Workspace Diagnostics',
  },
  {
    '<leader>sf',
    function()
      Snacks.picker.files()
    end,
    desc = 'Find Files',
  },
  {
    '<leader>sg',
    function()
      Snacks.picker.grep()
    end,
    desc = 'Grep',
  },
  {
    '<leader>sh',
    function()
      Snacks.picker.help()
    end,
    desc = 'Help Pages',
  },
  {
    '<leader>sH',
    function()
      Snacks.picker.highlights()
    end,
    desc = 'Highlights',
  },
  {
    '<leader>sj',
    function()
      Snacks.picker.jumps()
    end,
    desc = 'Jump List',
  },
  {
    '<leader>sk',
    function()
      Snacks.picker.keymaps()
    end,
    desc = 'Keymaps',
  },
  {
    '<leader>sl',
    function()
      Snacks.picker.loclist()
    end,
    desc = 'Location List',
  },
  {
    '<leader>sm',
    function()
      Snacks.picker.marks()
    end,
    desc = 'Marks',
  },
  {
    '<leader>sM',
    function()
      Snacks.picker.man()
    end,
    desc = 'Man Pages',
  },
  {
    '<leader>so',
    function()
      Snacks.picker.vim_options()
    end,
    desc = 'Vim Options',
  },
  {
    '<leader>sq',
    function()
      Snacks.picker.qflist()
    end,
    desc = 'Quickfix List',
  },
  {
    '<leader>sR',
    function()
      Snacks.picker.resume()
    end,
    desc = 'Resume Last Picker',
  },
  {
    '<leader>ss',
    function()
      Snacks.picker.lsp_symbols()
    end,
    desc = 'LSP Symbols',
  },
  {
    '<leader>sS',
    function()
      Snacks.picker.lsp_workspace_symbols()
    end,
    desc = 'LSP Workspace Symbols',
  },
  {
    '<leader>su',
    function()
      Snacks.picker.undo()
    end,
    desc = 'Undo History',
  },
  {
    '<leader>sw',
    function()
      Snacks.picker.grep_word()
    end,
    desc = 'Grep Word',
    mode = { 'n', 'x' },
  },

  -- Notifications
  {
    '<leader>un',
    function()
      Snacks.notifier.hide()
    end,
    desc = 'Dismiss Notifications',
  },
  {
    '<leader>nh',
    function()
      Snacks.picker.notifications()
    end,
    desc = 'Notification History',
  },
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Trouble                                     │
-- ╰──────────────────────────────────────────────────────────────────────────╯

M.trouble = {
  { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (Trouble)' },
  { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer Diagnostics (Trouble)' },
  { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<CR>', desc = 'Symbols (Trouble)' },
  { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<CR>', desc = 'LSP References (Trouble)' },
  { '<leader>xL', '<cmd>Trouble loclist toggle<CR>', desc = 'Location List (Trouble)' },
  { '<leader>xQ', '<cmd>Trouble qflist toggle<CR>', desc = 'Quickfix List (Trouble)' },
  {
    '[x',
    function()
      if require('trouble').is_open() then
        require('trouble').prev { skip_groups = true, jump = true }
      else
        local ok, err = pcall(vim.cmd.cprev)
        if not ok then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end
    end,
    desc = 'Previous Trouble/Quickfix item',
  },
  {
    ']x',
    function()
      if require('trouble').is_open() then
        require('trouble').next { skip_groups = true, jump = true }
      else
        local ok, err = pcall(vim.cmd.cnext)
        if not ok then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end
    end,
    desc = 'Next Trouble/Quickfix item',
  },
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              DAP (Debug Adapter Protocol)                │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- stylua: ignore
M.dap = {
  { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
  { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Conditional Breakpoint' },
  { '<leader>dc', function() require('dap').continue() end, desc = 'Continue' },
  { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'Run to Cursor' },
  { '<leader>dg', function() require('dap').goto_() end, desc = 'Go to Line (no execute)' },
  { '<leader>di', function() require('dap').step_into() end, desc = 'Step Into' },
  { '<leader>dj', function() require('dap').down() end, desc = 'Down' },
  { '<leader>dk', function() require('dap').up() end, desc = 'Up' },
  { '<leader>dl', function() require('dap').run_last() end, desc = 'Run Last' },
  { '<leader>do', function() require('dap').step_out() end, desc = 'Step Out' },
  { '<leader>dO', function() require('dap').step_over() end, desc = 'Step Over' },
  { '<leader>dp', function() require('dap').pause() end, desc = 'Pause' },
  { '<leader>dr', function() require('dap').repl.toggle() end, desc = 'Toggle REPL' },
  { '<leader>ds', function() require('dap').session() end, desc = 'Session' },
  { '<leader>dt', function() require('dap').terminate() end, desc = 'Terminate' },
  { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle DAP UI' },
  { '<leader>dw', function() require('dap.ui.widgets').hover() end, desc = 'Widgets' },
  { '<leader>dR', function() require('dap').clear_breakpoints() end, desc = 'Remove All Breakpoints' },
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Neotest                                     │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- stylua: ignore
M.neotest = {
  { '<leader>tt', function() require('neotest').run.run() end, desc = 'Run Nearest Test' },
  { '<leader>tf', function() require('neotest').run.run(vim.fn.expand '%') end, desc = 'Run File Tests' },
  { '<leader>tT', function() require('neotest').run.run(vim.uv.cwd()) end, desc = 'Run All Tests' },
  { '<leader>tS', function() require('neotest').run.run { suite = true } end, desc = 'Run Test Suite' },
  { '<leader>tl', function() require('neotest').run.run_last() end, desc = 'Run Last Test' },
  { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Toggle Summary' },
  { '<leader>to', function() require('neotest').output.open { enter = true, auto_close = true } end, desc = 'Show Output' },
  { '<leader>tp', function() require('neotest').output_panel.toggle() end, desc = 'Toggle Output Panel' },
  { '<leader>tq', function() require('neotest').run.stop() end, desc = 'Stop Test' },
  { '<leader>ta', function() require('neotest').run.attach() end, desc = 'Attach to Test' },
  { '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand '%') end, desc = 'Watch File' },
  {
    '<leader>td',
    function()
      require('neotest').summary.close()
      require('neotest').output_panel.close()
      if vim.bo.filetype == 'go' then
        require('dap-go').debug_test()
      else
        require('neotest').run.run { suite = false, strategy = 'dap' }
      end
    end,
    desc = 'Debug Nearest Test',
  },
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Sidekick                                    │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- stylua: ignore
M.sidekick = {
  { '<leader>ac', function() require('sidekick.cli').toggle() end, desc = 'Sidekick Toggle CLI' },
  { '<leader>as', function() require('sidekick.cli').select() end, desc = 'Select CLI' },
  { '<leader>at', function() require('sidekick.cli').send({ msg = '{this}' }) end, mode = { 'x', 'n' }, desc = 'Send This' },
  { '<leader>av', function() require('sidekick.cli').send({ msg = '{selection}' }) end, mode = { 'x' }, desc = 'Send Visual Selection' },
  { '<leader>ap', function() require('sidekick.cli').prompt() end, mode = { 'n', 'x' }, desc = 'Sidekick Select Prompt' },
  { '<c-.>', function() require('sidekick.cli').focus() end, mode = { 'n', 'x', 'i', 't' }, desc = 'Sidekick Switch Focus' },
  { '<leader>ac', function() require('sidekick.cli').toggle({ name = 'cursor', focus = true }) end, desc = 'Sidekick Toggle Cursor agent' },
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              CodeDiff                                    │
-- ╰──────────────────────────────────────────────────────────────────────────╯

M.codediff = {
  { '<leader>gd', '<cmd>CodeDiff<CR>', desc = 'Git Codediff Open' },
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Mini Files                                  │
-- ╰──────────────────────────────────────────────────────────────────────────╯

M.mini_files = {
  {
    '<leader>fm',
    function()
      require('mini.files').open()
    end,
    desc = 'Mini Files (root)',
  },
  {
    '<leader>fM',
    function()
      require('mini.files').open(vim.fn.expand '%')
    end,
    desc = 'Mini Files (current file)',
  },
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Arrow                                       │
-- ╰──────────────────────────────────────────────────────────────────────────╯

M.arrow = {
  { '<leader>;', desc = 'Arrow (bookmarks)' },
  { '<leader>m', desc = 'Arrow (buffer)' },
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Conform                                     │
-- ╰──────────────────────────────────────────────────────────────────────────╯

M.conform = {
  {
    '<leader>cf',
    function()
      require('conform').format {
        lsp_format = 'fallback',
        timeout_ms = 3000,
      }
    end,
    mode = { 'n', 'v' },
    desc = 'Format buffer',
  },
  {
    '<leader>cF',
    function()
      require('conform').format {
        formatters = { 'injected' },
        timeout_ms = 3000,
      }
    end,
    mode = { 'n', 'v' },
    desc = 'Format injected languages',
  },
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Treesitter Context                          │
-- ╰──────────────────────────────────────────────────────────────────────────╯

M.treesitter_context = {
  {
    '<leader>ut',
    function()
      require('treesitter-context').toggle()
    end,
    desc = 'Toggle Treesitter Context',
  },
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Tmux Navigation                             │
-- ╰──────────────────────────────────────────────────────────────────────────╯

M.tmux_navigation = {
  { '<C-h>', '<cmd>NvimTmuxNavigateLeft<CR>' },
  { '<C-j>', '<cmd>NvimTmuxNavigateDown<CR>' },
  { '<C-k>', '<cmd>NvimTmuxNavigateUp<CR>' },
  { '<C-l>', '<cmd>NvimTmuxNavigateRight<CR>' },
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Neogit                                      │
-- ╰──────────────────────────────────────────────────────────────────────────╯

M.neogit = {
  { '<leader>gg', '<cmd>Neogit<CR>', desc = '[G]it Neo[g]it' },
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Mini Surround                               │
-- ╰──────────────────────────────────────────────────────────────────────────╯

M.surround = {
  { 'gsa', desc = 'Add Surround', mode = { 'n', 'v' } },
  { 'gsd', desc = 'Delete Surround' },
  { 'gsf', desc = 'Find Surround (right)' },
  { 'gsF', desc = 'Find Surround (left)' },
  { 'gsh', desc = 'Highlight Surround' },
  { 'gsr', desc = 'Replace Surround' },
  { 'gsn', desc = 'Update N Lines' },
}

return M
