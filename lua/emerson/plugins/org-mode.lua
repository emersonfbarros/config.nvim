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
    org_todo_keywords = { 'TODO', 'IN-PROGRESS', '|', 'DONE', 'CANCELED' },
    org_log_into_drawer = 'LOGBOOK',
    mappings = {
      org = {
        org_toggle_checkbox = '<M-Space>',
      },
    },
  },
}
