require("oil").setup({
	delete_to_trash = true,
	columns = {
		"icon",
		"permissions",
		"size",
		"mtime",
	},
	float = {
		max_width = 0.5,
		max_height = 0.5,
	},
	keymaps = {
		["<BS>"] = "actions.parent",
		q = "actions.close",
		R = "actions.refresh",
		["<C-v>"] = {
			"actions.select",
			opts = { vertical = true },
			desc = "Open file in vertical split",
		},
		["<C-x>"] = {
			"actions.select",
			opts = { horizontal = true },
			desc = "Open file in horizontal split",
		},
		["<C-t>"] = {
			"actions.select",
			opts = { tab = true },
			desc = "Open file in new tab",
		},
		["<C-s>"] = {
			"actions.open_external",
			desc = "Open file using system opener",
		},
	},
})
