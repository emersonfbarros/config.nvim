return {
  'folke/lazydev.nvim',
  ft = 'lua',
  cmd = 'LazyDev',
  opts = {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      -- Load snacks types when Snacks is found
      { path = 'snacks.nvim', words = { 'Snacks' } },
      -- Lazy.nvim
      { path = 'lazy.nvim', words = { 'LazyVim' } },
    },
    -- Only enable in Neovim config directories
    enabled = function(root_dir)
      -- Check if we're in a Neovim config directory
      local nvim_config = vim.fn.stdpath 'config'
      local nvim_data = vim.fn.stdpath 'data'

      -- Enable for stdpath config
      if vim.startswith(root_dir, nvim_config) then
        return true
      end

      -- Enable for plugin directories in lazy folder
      if vim.startswith(root_dir, nvim_data .. '/lazy') then
        return true
      end

      -- Check for .luarc.json or .luarc.jsonc (indicates Neovim/Lua project)
      if vim.uv.fs_stat(root_dir .. '/.luarc.json') or vim.uv.fs_stat(root_dir .. '/.luarc.jsonc') then
        return true
      end

      -- Disable for other Lua files (like Lua projects not related to Neovim)
      return false
    end,
  },
}
