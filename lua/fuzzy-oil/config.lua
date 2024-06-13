local M = {}

---@class Options
local defaults = {
  hidden = true,
  debug = false,
  no_ignore = false,
  show_preview = true,
}

---@type Options
M.options = {}

---@param options? Options
function M.setup(options)
  M.options = vim.tbl_deep_extend('force', {}, defaults, options or {})
end

M.setup()

return M
