local conditions = require 'heirline.conditions'
local utils = require 'heirline.utils'

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Color Setup                                 │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Use Kanagawa colorscheme palette
local function setup_colors()
  local palette = require('kanagawa.colors').setup().palette

  return {
    -- Base colors from Kanagawa palette
    bright_bg = palette.sumiInk4,
    bright_fg = palette.fujiWhite,
    red = palette.dragonRed,
    dark_red = palette.winterRed,
    green = palette.dragonGreen,
    blue = palette.dragonBlue,
    gray = palette.dragonGray,
    orange = palette.dragonOrange,
    purple = palette.dragonViolet,
    cyan = palette.springBlue,
    yellow = palette.dragonYellow,

    -- Diagnostic colors
    diag_warn = palette.roninYellow,
    diag_error = palette.samuraiRed,
    diag_hint = palette.waveAqua1,
    diag_info = palette.dragonBlue,

    -- Git colors
    git_branch = palette.dragonPink,
    git_del = palette.dragonRed,
    git_add = palette.dragonGreen,
    git_change = palette.dragonOrange,

    -- Terminal colors
    terminal_bg = palette.dragonGreen,
    terminal_fg = palette.sumiInk0, -- dark background color for good contrast
  }
end

require('heirline').load_colors(setup_colors())

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                            Helper Components                             │
-- ╰──────────────────────────────────────────────────────────────────────────╯

local Align = { provider = '%=' }
local Space = { provider = ' ' }

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Vi Mode                                     │
-- ╰──────────────────────────────────────────────────────────────────────────╯

local ViMode = {
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_names = {
      n = 'N',
      no = 'N?',
      nov = 'N?',
      noV = 'N?',
      ['no\22'] = 'N?',
      niI = 'Ni',
      niR = 'Nr',
      niV = 'Nv',
      nt = 'Nt',
      v = 'V',
      vs = 'Vs',
      V = 'V_',
      Vs = 'Vs',
      ['\22'] = '^V',
      ['\22s'] = '^V',
      s = 'S',
      S = 'S_',
      ['\19'] = '^S',
      i = 'I',
      ic = 'Ic',
      ix = 'Ix',
      R = 'R',
      Rc = 'Rc',
      Rx = 'Rx',
      Rv = 'Rv',
      Rvc = 'Rv',
      Rvx = 'Rv',
      c = 'C',
      cv = 'Ex',
      r = '...',
      rm = 'M',
      ['r?'] = '?',
      ['!'] = '!',
      t = 'T',
    },
    mode_colors = {
      n = 'red',
      i = 'green',
      v = 'cyan',
      V = 'cyan',
      ['\22'] = 'cyan',
      c = 'orange',
      s = 'purple',
      S = 'purple',
      ['\19'] = 'purple',
      R = 'orange',
      r = 'orange',
      ['!'] = 'red',
      t = 'green',
    },
  },
  provider = function(self)
    return '  %2(' .. self.mode_names[self.mode] .. '%) '
  end,
  hl = function(self)
    local mode = self.mode:sub(1, 1)
    return { fg = self.mode_colors[mode], bold = true }
  end,
  update = {
    'ModeChanged',
    pattern = '*:*',
    callback = vim.schedule_wrap(function()
      vim.cmd 'redrawstatus'
    end),
  },
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                          File Name Block                                 │
-- ╰──────────────────────────────────────────────────────────────────────────╯

local FileIcon = {
  init = function(self)
    local filename = self.filename or vim.api.nvim_buf_get_name(0)
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. ' ')
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

local FileType = {
  provider = function()
    return vim.bo.filetype, '^%l'
  end,
  hl = { fg = utils.get_highlight('Type').fg, bold = true },
}

local FileName = {
  provider = function(self)
    -- first, trim the pattern relative to the current directory. For other
    -- options, see :h filename-modifers
    local filename = vim.fn.fnamemodify(self.filename, ':.')
    if filename == '' then
      return '[No Name]'
    end
    -- now, if the filename would occupy more than 1/4th of the available
    -- space, we trim the file path to its initials
    -- See Flexible Components section below for dynamic truncation
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = { fg = utils.get_highlight('Directory').fg },
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = ' [+]',
    hl = { fg = 'green' },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = ' ',
    hl = { fg = 'orange' },
  },
}

local FileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  hl = function()
    if vim.bo.modified then
      return { fg = 'cyan', bold = true }
    end
    return { fg = utils.get_highlight('Directory').fg }
  end,
  FileName,
  FileFlags,
  { provider = '%<' }, -- truncation point
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                                Git                                       │
-- ╰──────────────────────────────────────────────────────────────────────────╯

local Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict or {}
    self.has_changes = (self.status_dict.added or 0) ~= 0 or (self.status_dict.removed or 0) ~= 0 or (self.status_dict.changed or 0) ~= 0
  end,

  hl = { fg = 'orange' },

  {
    provider = function()
      return ' ('
    end,
    hl = { bold = true },
  },
  {
    provider = function(self)
      return self.status_dict.head
    end,
    hl = { fg = 'git_branch', bold = true },
  },
  {
    condition = function(self)
      return not self.has_changes
    end,
    provider = ')',
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and (' +' .. count)
    end,
    hl = { fg = 'git_add' },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and (' -' .. count)
    end,
    hl = { fg = 'git_del' },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and (' ~' .. count)
    end,
    hl = { fg = 'git_change' },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ')',
  },
  Space,
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                            Diagnostics                                   │
-- ╰──────────────────────────────────────────────────────────────────────────╯

local Diagnostics = {
  condition = conditions.has_diagnostics,
  static = {
    error_icon = '',
    warn_icon = '',
    info_icon = '󰋇',
    hint_icon = '󰌵',
  },
  init = function(self)
    -- Try to get custom diagnostic icons from config, fallback to defaults
    local ok, config = pcall(vim.diagnostic.config)
    if ok and config and config.signs and config.signs.text then
      self.error_icon = config.signs.text[vim.diagnostic.severity.ERROR] or self.error_icon
      self.warn_icon = config.signs.text[vim.diagnostic.severity.WARN] or self.warn_icon
      self.info_icon = config.signs.text[vim.diagnostic.severity.INFO] or self.info_icon
      self.hint_icon = config.signs.text[vim.diagnostic.severity.HINT] or self.hint_icon
    end
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  update = { 'DiagnosticChanged', 'BufEnter' },
  {
    provider = '![',
  },
  {
    provider = function(self)
      return self.errors > 0 and (self.error_icon .. self.errors)
    end,
    hl = { fg = 'diag_error' },
  },
  {
    -- Separator after errors (only if errors exist and there's something after)
    condition = function(self)
      return self.errors > 0 and (self.warnings > 0 or self.info > 0 or self.hints > 0)
    end,
    provider = ' ',
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings)
    end,
    hl = { fg = 'diag_warn' },
  },
  {
    -- Separator after warnings (only if warnings exist and there's something after)
    condition = function(self)
      return self.warnings > 0 and (self.info > 0 or self.hints > 0)
    end,
    provider = ' ',
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info)
    end,
    hl = { fg = 'diag_info' },
  },
  {
    -- Separator after info (only if info exists and there are hints after)
    condition = function(self)
      return self.info > 0 and self.hints > 0
    end,
    provider = ' ',
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = { fg = 'diag_hint' },
  },
  {
    provider = ']',
  },
  Space,
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                       Cursor Position & ScrollBar                        │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- ScrollBar with dash style
local ScrollBar = {
  static = {
    sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' },
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return ' ' .. string.rep(self.sbar[i], 2)
  end,
  hl = { fg = 'blue', bg = 'bright_bg' },
}

local Ruler = {
  provider = '%7(%l/%3L%):%2c %P ',
  hl = { fg = 'bright_fg' },
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                          Assembling Statuslines                          │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Default statusline for active windows
local DefaultStatusline = {
  -- Far Left: Vi Mode
  { provider = '▊', hl = { fg = 'bg' } },
  utils.surround({ '' }, 'bright_bg', { ViMode }),
  Space,

  -- Left Section: File info
  Git,
  Space,
  Diagnostics,
  Space,
  FileNameBlock,
  Space,
  -- FlexibleNavic,

  -- Far Right: Position info
  Align,
  FileIcon,
  FileType,
  Space,
  Ruler,
  ScrollBar,
  { provider = '▊', hl = { fg = 'bright_bg' } },
}

-- Inactive statusline
local InactiveStatusline = {
  condition = conditions.is_not_active,
  hl = { fg = 'gray', force = true },

  { provider = '▊ ', hl = { fg = 'gray' } },
  FileNameBlock,
  Align,
}

-- Special statusline for special buffers
local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches {
      buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
      filetype = { '^git.*', 'fugitive', 'Trouble', 'Neogit*', 'lazy' },
    }
  end,

  { provider = '▊ ', hl = { fg = 'purple' } },
  {
    provider = function()
      return string.upper(vim.bo.filetype)
    end,
    hl = { fg = 'purple', bold = true },
  },
  Space,
  {
    provider = function()
      local filename = vim.api.nvim_buf_get_name(0)
      return vim.fn.fnamemodify(filename, ':t')
    end,
    hl = { fg = 'gray' },
  },
  Align,
}

-- Terminal statusline
local TerminalStatusline = {
  condition = function()
    return conditions.buffer_matches { buftype = { 'terminal' } }
  end,

  hl = { bg = 'terminal_bg', fg = 'terminal_fg' },

  {
    condition = conditions.is_active,
    utils.surround({ '' }, 'bright_bg', { ViMode }),
    Space,
  },
  {
    provider = ' TERMINAL',
    hl = { fg = 'terminal_fg', bold = true },
  },
  Space,
  {
    provider = function()
      local tname, _ = vim.api.nvim_buf_get_name(0):gsub('.*:', '')
      return tname
    end,
    hl = { fg = 'terminal_fg' },
  },
  Align,
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                          Final StatusLine                                │
-- ╰──────────────────────────────────────────────────────────────────────────╯

local StatusLines = {
  hl = function()
    if conditions.is_active() then
      return 'StatusLine'
    else
      return 'StatusLineNC'
    end
  end,

  fallthrough = false,

  SpecialStatusline,
  TerminalStatusline,
  InactiveStatusline,
  DefaultStatusline,
}

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                              Setup                                       │
-- ╰──────────────────────────────────────────────────────────────────────────╯

require('heirline').setup {
  statusline = StatusLines,
  opts = {
    colors = setup_colors,
  },
}

-- Handle colorscheme changes to update Kanagawa colors
vim.api.nvim_create_augroup('Heirline', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    utils.on_colorscheme(setup_colors)
  end,
  group = 'Heirline',
})
