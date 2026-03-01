return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'helix',
    plugins = {
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
    spec = {
      mode = { 'n', 'v' },
      -- Leader groups
      { '<leader>a', group = 'AI/Sidekick', icon = '󰚩' },
      { '<leader>b', group = 'Buffer', icon = '' },
      { '<leader>c', group = 'Code', icon = '' },
      { '<leader>d', group = 'Debug', icon = '' },
      { '<leader>f', group = 'File/Find', icon = '' },
      { '<leader>g', group = 'Git', icon = '󰊢' },
      { '<leader>gh', group = 'Hunks' },
      { '<leader>G', group = 'GitHub/Go', icon = '' },
      { '<leader>n', group = 'Notifications', icon = '' },
      { '<leader>s', group = 'Search', icon = '' },
      { '<leader>t', group = 'Test', icon = '' },
      { '<leader>u', group = 'UI/Toggle', icon = '' },
      { '<leader>w', group = 'Window', icon = '' },
      { '<leader>x', group = 'Trouble/Diagnostics', icon = '' },

      -- Bracket groups
      { '[', group = 'Prev' },
      { ']', group = 'Next' },

      -- Go-to groups
      { 'g', group = 'Goto' },
      { 'gs', group = 'Surround' },

      -- Hidden
      { '<leader><tab>', hidden = true },
    },
  },
}
