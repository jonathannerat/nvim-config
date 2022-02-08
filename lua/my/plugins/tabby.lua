local M = {}

M.setup = function()
	local layout = require "tabby.presets".tab_only
	layout.head[1][1] =  '   '
	layout.head[2][1] = ''
	layout.active_tab.left_sep[1] = ''
	layout.active_tab.right_sep[1] = ''
	layout.inactive_tab.left_sep[1] = ''
	layout.inactive_tab.right_sep[1] = ''

	require("tabby").setup {
		tabline = layout,
	}
end

return M
