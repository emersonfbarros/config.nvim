return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  dependencies = {
    {
      'nvim-orgmode/org-bullets.nvim',
      opts = {},
    },
  },
  ft = { 'org' },
  opts = {
    org_agenda_files = '~/Org/**/*',
    org_default_notes_file = '~/Org/refile.org',
    mappings = {
      org = {
        org_toggle_checkbox = '<M-Space>',
      },
    },
  },
}
