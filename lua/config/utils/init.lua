local M = {}

--- Create an augroup with clear = true
---@param name string
---@return number
function M.augroup(name)
  return vim.api.nvim_create_augroup('nvim_' .. name, { clear = true })
end

return M
