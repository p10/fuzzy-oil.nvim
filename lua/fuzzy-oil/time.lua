local M = {}

local table = {}

function M.start(name)
	table[name] = os.clock()
end

function M.stop(name)
	if table[name] then
		local time = os.clock() - table[name]
		table[name] = nil
		return time
	else
		return nil
	end
end

return M
