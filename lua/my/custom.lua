local expand = require("my.util.functions").expand

local M = {
	theme = "gruvbox-flat",
	lualine_theme = "gruvbox-flat",
}

local vim_cmds = [[
colorscheme ${theme}
]]

M.setup = function()
	vim.api.nvim_exec(expand(vim_cmds, M), false)
end

return M
