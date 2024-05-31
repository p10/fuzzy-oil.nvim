local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local time = require("fuzzy-oil.time")

local M = {}

function M.get_dirs(opts, fn)
	if opts.debug then
		time.start("get_dirs")
	end

	local find_command = (function()
		if 1 == vim.fn.executable("fd") then
			return { "fd", "--type", "d", "--color", "never" }
		elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
			return { "find", ".", "-type", "d" }
		end
	end)()

	if not find_command then
		vim.notify("fuzzy-oil: You need to install either find, fd", vim.log.levels.ERROR)
		return
	end

	local command = find_command[1]
	local hidden = opts.hidden
	local no_ignore = opts.no_ignore

	if command == "fd" then
		if hidden then
			find_command[#find_command + 1] = "--hidden"
		end
		if no_ignore then
			find_command[#find_command + 1] = "--no-ignore"
		end
	elseif command == "find" then
		if not hidden then
			for _, v in ipairs({ "-not", "-path", "*/.*" }) do
				table.insert(find_command, v)
			end
		end
		if no_ignore ~= nil then
			vim.notify("fuzzy-oil: The `no_ignore` key is not available for the `find` command", vim.log.levels.WARN)
		end
	end

	local function getPreviewer()
		if opts.show_preview then
			return conf.file_previewer(opts)
		else
			return nil
		end
	end

	vim.fn.jobstart(find_command, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data then
				pickers
					.new(opts, {
						prompt_title = "Select a Directory",
						finder = finders.new_table({ results = data, entry_maker = make_entry.gen_from_file(opts) }),
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
								actions._close(prompt_bufnr, current_picker.initial_mode == "insert")
								fn({ dir = dir })
							end)
							return true
						end,
					})
					:find()

				if opts.debug then
					print("get_dirs took " .. time.stop("get_dirs") .. " seconds")
				end
			else
				vim.notify("No directories found", vim.log.levels.ERROR)
			end
		end,
	})
end

return M
