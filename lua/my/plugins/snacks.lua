require("snacks").setup({
	dashboard = {
		sections = {
			{ section = "header" },
			{ section = "keys", icon = " ", title = "Keymaps", indent = 2, padding = 1 },
			{ section = "recent_files", icon = " ", title = "Recent Files", indent = 2, padding = 1 },
			{
				icon = " ",
				title = "Git Status",
				section = "terminal",
				enabled = function()
					return Snacks.git.get_root() ~= nil
				end,
				cmd = "git status --short --branch --renames",
				height = 5,
				padding = 1,
				ttl = 5 * 60,

				indent = 3,
			},
		},
	},
	input = { enabled = true },
	lazygit = { enabled = true },
	notifier = { enabled = true },
	picker = { enabled = true },
	quickfile = { enabled = true },
	scratch = { enabled = true },
	statuscolumn = { enabled = true },
	terminal = { enabled = true },
	words = { enabled = true },
	zen = { enabled = true },
})
