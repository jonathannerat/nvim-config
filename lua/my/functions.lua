local M = {}

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
	local col = vim.fn.col "." - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match "%s" ~= nil
end

function M.tab_complete()
	if vim.fn.pumvisible() == 1 then
		return t "<c-n>"
	elseif check_back_space() then
		return t "<tab>"
	end
end

function M.s_tab_complete()
	if vim.fn.pumvisible() == 1 then
		return t "<c-p>"
	else
		return t "<s-tab>"
	end
end

local has_custom, custom = pcall(function()
	return require "my.custom"
end)

if has_custom then
	custom.mt = {
		__index = require "my.defaults"
	}
	setmetatable(custom, custom.mt)
else
	custom = require "my.defaults"
end

function M.custom(key)
	return custom[key]
end

return M
