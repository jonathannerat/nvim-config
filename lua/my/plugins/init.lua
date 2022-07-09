local M = {}

-- ensure packer.nvim is installed
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system {
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	}
end

local packer = require "packer"
local use = packer.use

-- Use plugin only for specified filetypes, using apropiate folder name
local function use_syntax(plugin, filetypes)
	local alias
	if type(filetypes) == "string" then
		alias = filetypes
	else
		for k, _ in pairs(filetypes) do
			if type(k) == "string" then
				alias = k
				break
			end
		end

		if alias then
			local filetype = filetypes[alias]
			filetypes[alias] = nil
			filetypes[#filetypes + 1] = filetype
		else
			alias = filetypes[1]
		end
	end

	use {
		plugin,
		as = "syntax-" .. alias,
		ft = filetypes,
	}
end

-- Use plugin generating a trivial config call
local function use_setup(plugin_spec, module)
	plugin_spec = type(plugin_spec) == "string" and { plugin_spec } or plugin_spec
	module = module and module or string.match(plugin_spec[1], ".*/(.*)")
	plugin_spec.config = "require('" .. module .. "').setup()"

	use(plugin_spec)
end

-- Try to use local clone of plugin if available, fallback to original
local function use_local(plugin_spec)
	local plugin = type(plugin_spec) == "string" and plugin_spec or plugin_spec[1]
	local plugin_name = string.match(plugin, ".*/(.*)")
	local plugins_dir = "~/projects/nvim-plugins/"

	if fn.isdirectory(fn.expand(plugins_dir .. plugin_name)) == 1 then
		plugin_spec[1] = plugins_dir .. plugin_name
	end

	use(plugin_spec)
end

M.packer_setup = function()
	use "wbthomason/packer.nvim"

	-- === Language Specific ===
	use_syntax("arrufat/vala.vim", "vala")
	use_syntax("asciidoc/vim-asciidoc", { "asciidoc", "adoc" })
	use_syntax("cakebaker/scss-syntax.vim", "scss")
	use_syntax("cespare/vim-toml", "toml")
	use_syntax("gkz/vim-ls", { livescript = "ls" })
	use_syntax("jidn/vim-dbml", "dbml")
	use_syntax("leafo/moonscript-vim", "moon")
	use_syntax("neomutt/neomutt.vim", { "mutt", "neomutt" })
	use_syntax("tridactyl/vim-tridactyl", "tridactyl")
	use_syntax("iosmanthus/vim-nasm", "nasm")
	use_syntax("vim-pandoc/vim-pandoc-syntax", "pandoc")
	use_syntax("mechatroner/rainbow_csv", "csv")
	use { "vim-pandoc/vim-pandoc", ft = "pandoc" } -- Pandoc integration & utilities
	use { "lervag/vimtex", ft = { "tex", "latex" } } -- Latex integration & utilities

	-- === Colorschemes ===
	use "eddyekofo94/gruvbox-flat.nvim"
	use "rebelot/kanagawa.nvim"
	use {
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").setup { style = "warmer" }
		end,
	}

	--{{{ UI
	use_setup("nanozuki/tabby.nvim", "my.plugins.tabby") -- Tabline
	use_setup("nvim-lualine/lualine.nvim", "my.plugins.lualine") -- Statusline
	use_setup("j-hui/fidget.nvim", "fidget") -- LSP Progress
	use_setup("goolord/alpha-nvim", "my.plugins.alpha") -- Dashboard

	use { -- Pretty list for diagnostics, references, quickfix, etc.
		"folke/trouble.nvim",
		cmd = { "Trouble", "TroubleToggle" },
		config = function()
			require("trouble").setup { icons = true }
		end,
	}

	use { -- Sidebar File Explorer
		"kyazdani42/nvim-tree.lua",
		cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeFocus" },
		config = function()
			require("nvim-tree").setup {
				auto_close = true,
				update_cwd = true,
				trash = { cmd = "trash-rm" },
			}
		end,
	}

	use_setup("stevearc/dressing.nvim", "dressing")

	use_setup({ -- Todo Highlighting
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
	}, "todo-comments")

	use {
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup {
				open_mapping = [[<c-\>]],
				persist_size = false,
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.3
					end
				end,
			}
		end,
	}

	--}}}

	-- === Treesitter ===
	use_setup({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	}, "my.plugins.treesitter")

	use { -- Syntax aware text-objects
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
	}

	use { -- Smarter text-objects
		"RRethy/nvim-treesitter-textsubjects",
		after = "nvim-treesitter",
	}

	use { -- Context aware comment string (injections)
		"JoosepAlviste/nvim-ts-context-commentstring",
		after = "nvim-treesitter",
	}

	use { -- TreeSitter node viewer
		"nvim-treesitter/playground",
		after = "nvim-treesitter",
		cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
		run = ":TSUpdate query",
	}

	use { -- Show cursor context block (class / function / if / for / etc.)
		"nvim-treesitter/nvim-treesitter-context",
		after = "nvim-treesitter",
		config = function()
			require("treesitter-context").setup {
				enabled = true,
				max_lines = 3,
			}
		end,
	}

	use {
		"nvim-neorg/tree-sitter-norg",
		after = "nvim-treesitter",
		ft = "norg",
	}

	-- === Telescope ===
	use_setup({
		"nvim-telescope/telescope.nvim",
		after = { "telescope-fzf-native.nvim", "telescope-media-files.nvim" },
		cmd = "Telescope",
		module = "telescope",
		requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
	}, "my.plugins.telescope")

	use "nvim-telescope/telescope-media-files.nvim"
	use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }

	-- === LSP ===
	use_setup({
		"neovim/nvim-lspconfig",
		requires = {
			"williamboman/nvim-lsp-installer",
			"onsails/lspkind-nvim", -- LSP Completion symbols
			"folke/lua-dev.nvim", -- sumneko_lua lsp + nvim integration
			"ray-x/lsp_signature.nvim", -- LSP signature viewer
		},
	}, "my.plugins.lspconfig")

	use_setup({ -- Completion engine for LSPs
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
			{ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
			{ "hrsh7th/cmp-path", after = "nvim-cmp" },
		},
	}, "my.plugins.cmp")

	-- === Debuggers ===
	use_setup("mfussenegger/nvim-dap", "my.plugins.dap")
	use_setup({ "rcarriga/nvim-dap-ui", requires = "mfussenegger/nvim-dap" }, "dapui")

	-- === Editing ===
	use "editorconfig/editorconfig-vim"
	use_setup("windwp/nvim-autopairs", "my.plugins.autopairs")
	use_setup("numToStr/Comment.nvim", "Comment")

	use {
		"ur4ltz/surround.nvim",
		config = function()
			require("surround").setup { mappings_style = "surround" }
		end,
	}

	use_setup({ -- File formatting
		"mhartington/formatter.nvim",
		cmd = { "Format", "FormatWrite" },
	}, "my.plugins.formatter")

	use_setup { -- Annotation generation
		"danymat/neogen",
		cmd = "Neogen",
	}

	-- === Utilities ===
	use "tpope/vim-fugitive" -- Git integration
	use "rafamadriz/friendly-snippets" -- Collection of snippets
	use_setup("L3MON4D3/LuaSnip", "my.plugins.luasnip") -- Snippets engine

	use { "glacambre/firenvim", run = ":call firenvim#install(0)" } -- Browser integration

	use { -- Organization tool (note taking / todo lists / etc.)
		"nvim-neorg/neorg",
		ft = "norg",
		config = function()
			require("neorg").setup {
				load = {
					["core.defaults"] = {},
					["core.keybinds"] = {
						config = { default_keybinds = true },
					},
					["core.norg.concealer"] = {},
					["core.norg.dirman"] = {
						config = { workspaces = { notes = "~/documents/notes" } },
					},
					["core.norg.completion"] = {
						config = { engine = "nvim-cmp" },
					},
				},
			}
		end,
	}

	use {
		"iamcco/markdown-preview.nvim",
		run = "cd app && yarn install",
		cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
		ft = { "markdown", "pandoc.markdown", "rmd" },
	}

	use { -- Preview color #aaaaaa
		"norcalli/nvim-colorizer.lua",
		cmd = "ColorizerToggle",
		config = function()
			require("colorizer").setup(nil, {
				RRGGBB = true,
			})
		end,
	}

	-- === External Integrations ===
	use {
		"andweeb/presence.nvim",
		config = function()
			require("presence"):setup {
				auto_update = false,
			}
		end,
	}

	if packer_bootstrap then
		packer.sync()
	end
end

M.setup = function()
	require("packer").startup {
		M.packer_setup,
		config = {
			display = {
				open_fn = function()
					return require("packer.util").float { border = "single" }
				end,
			},
			profile = {
				enabled = true,
				threshold = 1,
			},
		},
	}
end

return M
