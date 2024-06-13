local config = require('fuzzy-oil.config')
local dirs = require('fuzzy-oil.dirs')

local M = {}

---@param options? Options
function M.setup(options)
  config.setup(options)

  vim.api.nvim_create_user_command('FuzzyOil', function()
    dirs.get_dirs(config.options, function(res)
      vim.cmd('Oil ' .. res.dir)
    end)
  end, {
    desc = 'Search for a directory and open it in Oil',
  })
end

return M
