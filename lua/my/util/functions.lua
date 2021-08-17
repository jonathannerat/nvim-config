local M = {}

function M.shallowcopy(orig)
	local dup = {}

	for k, v in ipairs(orig) do
		dup[k] = v
	end

	return dup
end

return M
