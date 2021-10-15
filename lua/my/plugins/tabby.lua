local filename = require('tabby.filename')
local util = require('tabby.util')

local hl_tabline = util.extract_nvim_hl('TabLine')
local hl_tabline_sel = util.extract_nvim_hl('TabLineSel')

local M = {}

---@type TabbyTablineOpt
M.tabline = {
	hl = 'TabLineFill',
	layout = 'active_wins_at_tail',
	active_tab = {
		label = function(tabid)
			return {
				'  ' .. vim.api.nvim_tabpage_get_number(tabid) .. '  ',
				hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = 'bold' },
			}
		end,
		right_sep = { ' ', hl = 'TabLineFill' },
	},
	inactive_tab = {
		label = function(tabid)
			return {
				'  ' .. vim.api.nvim_tabpage_get_number(tabid) .. '  ',
				hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = 'bold' },
			}
		end,
		right_sep = { ' ', hl = 'TabLineFill' },
	},
	top_win = {
		label = function(winid)
			return {
				' > ' .. filename.unique(winid) .. ' ',
				hl = 'TabLine',
			}
		end,
		left_sep = { ' ', hl = 'TabLineFill' },
	},
	win = {
		label = function(winid)
			return {
				' - ' .. filename.unique(winid) .. ' ',
				hl = 'TabLine',
			}
		end,
		left_sep = { ' ', hl = 'TabLineFill' },
	},
}

M.config = function ()
	require('tabby').setup({
		tabline = M.tabline,
	})
end

return M