local M = {}

function M.shallowcopy(orig)
	local dup = {}

	for k, v in ipairs(orig) do
		dup[k] = v
	end

	return dup
end

---expands "${key}" strings in text with values from dict
---@param text string to be parsed
---@param dict table to get the values
function M.expand(text, dict)
	return text:gsub("$(%b{})", function(m)
		return dict[m:sub(2, -2)]
	end)
end

return M
