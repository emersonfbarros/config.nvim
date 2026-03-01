--- Keymaps module
--- - plugins.lua: Centralized plugin keymaps (lazy-loaded via keys = require('config.keymaps.plugins').X)
--- - gitsigns.lua: on_attach function for gitsigns
--- - lsp.lua: on_attach function for LSP

local M = {}

M.plugins = require 'config.keymaps.plugins'
M.gitsigns = require 'config.keymaps.gitsigns'
M.lsp = require 'config.keymaps.lsp'

return M
