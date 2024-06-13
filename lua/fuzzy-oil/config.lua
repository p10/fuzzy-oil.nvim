local M = {}

---@class Options
local defaults = {
  debug = false,
  show_preview = true,
  find_command = {
    'fd',
    '--type',
    'd',
    '--color',
    'never',
  },
}

---@type Options
M.options = {}

---@param options? Options
function M.setup(options)
  M.options = vim.tbl_deep_extend('force', {}, defaults, options or {})
end

M.setup()

return M
