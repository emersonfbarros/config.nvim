return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    { 'nvim-treesitter/nvim-treesitter-context', opts = {} },
  },
  config = function()
    local treesitter = require 'nvim-treesitter.configs'

    ---@diagnostic disable-next-line: missing-fields
    treesitter.setup { -- enable syntax highlighting
      highlight = {
        enable = true,
        disable = function(_, buf) -- disabling treesitter for files larger than 100KB
          local max_file_size = 100 * 1024 -- 100KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_file_size then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      -- ensure these language parsers are installed
      ensure_installed = {
        'json',
        'javascript',
        'typescript',
        'tsx',
        'python',
        'proto',
        'yaml',
        'markdown',
        'markdown_inline',
        'bash',
        'lua',
        'vim',
        'sql',
        'dockerfile',
        'gitignore',
        'go',
        'gomod',
        'gowork',
        'gosum',
        'rust',
        'make',
        'toml',
        'html',
        'c_sharp',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    }
  end,
}
