local M = {}

function M.cmd(command)
	return "<cmd>" .. command .. "<cr>"
end

function M.plug(command)
	return "<plug>" .. command
end

function M.lua(command)
	return M.cmd("lua" .. command)
end

function M.bind(mappings, bufnr)
	for key, rhs in pairs(mappings) do
		local mode, optchars, keymap = string.match(key, "([cinstv])|([ensw]*)|(.*)")
		local options = M.parse_opt_chars(optchars)

		if bufnr then
			vim.api.nvim_buf_set_keymap(bufnr, mode, keymap, rhs, options)
		else
			vim.api.nvim_set_keymap(mode, keymap, rhs, options)
		end
	end
end

function M.parse_opt_chars(optchars)
	local o = {
		expr = false,
		noremap = false,
		silent = false,
		nowait = false,
	}

	for i = 1, #optchars do
		local c = optchars:sub(i, i)
		if c == "e" then
			o.expr = true
		elseif c == "n" then
			o.noremap = true
		elseif c == "s" then
			o.silent = true
		elseif c == "w" then
			o.nowait = true
		end
	end

	return o
end

return M
