local utils = require("my.utils")

-- Bootstrapping paq.nvim
utils.bootstrap({
	url = "https://github.com/savq/paq-nvim",
	branch = "master",
	package = "paqs",
})

require("paq")({
	-- Self update
	"savq/paq-nvim",

	-- Common dependencies
	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",

	-- Finder
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	"nvim-telescope/telescope-live-grep-args.nvim",
	"nvim-telescope/telescope.nvim",
	"stevearc/oil.nvim",

	-- LSP
	"b0o/SchemaStore.nvim",
	"hrsh7th/cmp-nvim-lsp",
	"folke/lazydev.nvim",
	"neovim/nvim-lspconfig",
	"williamboman/mason-lspconfig.nvim",
	"williamboman/mason.nvim",

	-- Completion
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"onsails/lspkind-nvim",
	"dcampos/nvim-snippy",
	"dcampos/cmp-snippy",
	"mattn/emmet-vim",
	"dcampos/cmp-emmet-vim",
	"hrsh7th/nvim-cmp",

	-- UI
	"SmiteshP/nvim-navic",
	"rebelot/heirline.nvim",
	"numToStr/FTerm.nvim",

	-- Text editing
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	"nvim-treesitter/nvim-treesitter-context",
	"windwp/nvim-autopairs",
	"kylechui/nvim-surround",
	"mhartington/formatter.nvim",
	"Wansmer/treesj",
	"folke/zen-mode.nvim",
	"danymat/neogen",

	-- Integration with third party tools
	"lewis6991/gitsigns.nvim",

	-- Colorschemes
	"rebelot/kanagawa.nvim",
})

utils.setup({
	"my.plugins.telescope",
	"my.plugins.oil",
	"my.plugins.lsp",
	"my.plugins.cmp",
	"my.plugins.heirline",
	"my.plugins.formatter",

	"nvim-surround",
	"zen-mode",
	"gitsigns",
	"neogen",

	["treesitter-context"] = {
		enabled = true,
		max_lines = 3,
	},

	["nvim-autopairs"] = {
		disable_filetype = { "TelescopePrompt" },
	},

	treesj = {
		use_default_keymaps = false,
	},
})
