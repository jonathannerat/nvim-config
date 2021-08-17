local M = {}

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

function M.tab_complete ()
	if vim.fn.pumvisible() == 1 then
		return t '<c-n>'
	elseif check_back_space() then
		return t '<tab>'
	end
end

function M.s_tab_complete ()
	if vim.fn.pumvisible() == 1 then
		return t '<c-p>'
	else
		return t '<s-tab>'
	end
end

return M
