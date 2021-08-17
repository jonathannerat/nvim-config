local M = {}

M.setup_config = {
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff'},
		lualine_c = {'filename'},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {},
	},
	options = {
		theme = require'my.custom'.lualine_theme,
	},
	extensions = { 'fzf', 'fugitive' }
}

M.config = function()
	require'lualine'.setup(M.setup_config)
end

return M
