local M = {}

--- Run go:generate command from current line
function M.run_go_generate()
  local line = vim.api.nvim_get_current_line()

  -- Check if line starts with //go:generate
  if not line:match '^%s*//go:generate' then
    vim.notify('Not on a go:generate line', vim.log.levels.WARN)
    return
  end

  -- Strip //go:generate prefix and trim whitespace
  local command = line:gsub('^%s*//go:generate%s*', ''):gsub('^%s*(.-)%s*$', '%1')

  if command == '' then
    vim.notify('Empty go:generate command', vim.log.levels.WARN)
    return
  end

  -- Get the directory of the current file
  local file_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')

  vim.notify('Running: ' .. command, vim.log.levels.INFO)

  vim.fn.jobstart(command, {
    cwd = file_dir,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        -- Create a horizontal split for the result buffer
        vim.cmd '12split'
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(0, buf)
        vim.bo[buf].filetype = 'gogenres'

        local msg = exit_code == 0 and 'Command completed successfully'
          or ('Command failed with exit code: ' .. exit_code)

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { msg })

        local level = exit_code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
        vim.notify(msg, level)
      end)
    end,
  })
end

--- Setup Go filetype keymaps
---@param bufnr number
function M.setup(bufnr)
  vim.keymap.set('n', '<leader>Gg', M.run_go_generate, {
    desc = 'Run go:generate',
    buffer = bufnr,
  })
end

return M
