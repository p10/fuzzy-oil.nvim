local action_set = require('telescope.actions.set')
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local conf = require('telescope.config').values
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local time = require('fuzzy-oil.time')

local M = {}

function M.get_dirs(opts, fn)
  if opts.debug then
    time.start('get_dirs')
  end

  local function getPreviewer()
    if opts.show_preview then
      return conf.file_previewer(opts)
    else
      return nil
    end
  end

  vim.fn.jobstart(opts.find_command, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local filtered = vim.tbl_filter(function(el)
          return el ~= ''
        end, data)
        pickers
          .new({}, {
            prompt_title = 'Select a Directory',
            finder = finders.new_table({
              results = filtered,
              entry_maker = make_entry.gen_from_file(opts),
            }),
            previewer = getPreviewer(),
            sorter = conf.file_sorter(opts),
            attach_mappings = function(prompt_bufnr)
              action_set.select:replace(function()
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                local dir
                local selections = current_picker:get_multi_selection()
                if vim.tbl_isempty(selections) then
                  dir = action_state.get_selected_entry().value
                else
                  dir = selections[1].value
                end
                actions.close(prompt_bufnr)
                fn({ dir = dir })
              end)
              return true
            end,
          })
          :find()

        if opts.debug then
          print('get_dirs took ' .. time.stop('get_dirs') .. ' seconds')
        end
      else
        vim.notify('No directories found', vim.log.levels.ERROR)
      end
    end,
  })
end

return M
