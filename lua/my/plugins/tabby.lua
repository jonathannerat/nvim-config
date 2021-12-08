local M = {}

M.setup = function()
	local layout = require "tabby.presets".active_wins_at_tail
	layout.head[1][1] =  '   '
	layout.head[2][1] = ''
	layout.active_tab.left_sep[1] = ''
	layout.active_tab.right_sep[1] = ''
	layout.inactive_tab.left_sep[1] = ''
	layout.inactive_tab.right_sep[1] = ''
	layout.top_win.left_sep[1] = ''
	layout.top_win.right_sep[1] = ''
	layout.win.left_sep[1] = ''
	layout.win.right_sep[1] = ''
	layout.tail[1][1] = ''

	require("tabby").setup {
		tabline = layout,
	}
end

return M
