local M = {}

function M.nop() end

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

function M.vimexec(vimcode, dict)
	vim.api.nvim_exec(M.expand(vimcode, dict), false)
end

function M.partial(func, ...)
	local args = { ... }
	return function()
		return func(unpack(args))
	end
end

return M
