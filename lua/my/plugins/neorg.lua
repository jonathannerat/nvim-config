local M = {}

M.config = function()
require'neorg'.setup {
	load = {
		['core.defaults'] = {},
		['core.keybinds'] = {
			config = { default_keybinds = true }
		},
		['core.norg.concealer'] = {},
		['core.norg.dirman'] = {
			config = { workspaces = { notes = '~/docs/notes' } }
		},
	}
}
end

return M
