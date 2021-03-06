local M = {}

M.parsers = {
	norg = {
		install_info = {
			url = "https://github.com/vhyrro/tree-sitter-norg",
			files = { "src/parser.c", "src/scanner.cc" },
			branch = "main",
		},
	},
}

M.config = {
	ensure_installed = {
		"lua",
		"c",
		"cpp",
		"html",
		"css",
		"haskell",
		"javascript",
		"php",
		"vim",
		"vue",
	},
	highlight = {
		enable = true,
		disable = { "tex", "latex", "html", "php" }, -- conflicts with vimtex's concela
	},
	incremental_selection = { enable = true },
	indent = { enable = true },
	playground = { enable = true },
	textobjects = {
		select = {
			enable = true,
			disable = { "tex", "latex" },
			lookahead = true,
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]m"] = "@function.outer",
				["]i"] = "@conditional.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]I"] = "@conditional.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[i"] = "@conditional.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[I"] = "@conditional.outer",
			},
		},
	},
	textsubjects = {
		enable = true,
		prev_selection = ",",
		keymaps = {
			["."] = "textsubjects-smart",
			[";"] = "textsubjects-container-outer",
			["i;"] = "textsubjects-container-inner",
		},
	},
	context_commentstring = {
		enable = true,
	},
	autotag = {
		enable = true,
		filetypes = { "html", "xml", "vue", "php" },
	},
}

M.setup = function()
	local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

	for parser, parser_config in pairs(M.parsers) do
		parser_configs[parser] = parser_config
	end

	require("nvim-treesitter.configs").setup(M.config)
end

return M
