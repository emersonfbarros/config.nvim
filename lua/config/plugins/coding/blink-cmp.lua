return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  version = '1.*',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = 'make install_jsregexp',
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
      opts = {
        history = true,
        delete_check_events = 'TextChanged',
      },
    },
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      ['<C-y>'] = { 'select_and_accept' },
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          treesitter = { 'lsp' },
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
        },
        border = 'single',
        winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = 'single',
        },
      },
      ghost_text = {
        enabled = false,
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      per_filetype = {
        sql = { 'snippets', 'dadbod', 'buffer' },
        lua = { 'lazydev', 'lsp', 'path', 'snippets' },
      },
      providers = {
        buffer = {
          min_keyword_length = 3,
          max_items = 5,
        },
        dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
        lazydev = {
          name = 'lazydev',
          module = 'lazydev.integrations.blink',
          -- Lazydev provides completions from Neovim runtime, prioritize it for Lua
          score_offset = 100,
          -- Don't show in other filetypes (it's only in per_filetype.lua anyway)
          fallbacks = { 'lsp' },
        },
      },
    },
    snippets = { preset = 'luasnip' },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = {
      enabled = true,
      window = {
        border = 'single',
      },
    },
  },
}
