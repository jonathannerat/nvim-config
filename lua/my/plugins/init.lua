local packer = require "packer"
local use = packer.use
local fn = vim.fn

local M = {}

-- ensure packer.nvim is installed
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
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

local function use_syntax(plugin, syntax)
	use { plugin, as = (type(syntax) == "string" and syntax or syntax[1]) .. "-syntax", ft = syntax }
end

local function use_setup(plugin, module)
	use { plugin, config = "require('" .. module .. "').setup()" }
end

local function use_local(plugin_spec)
	local plugin = type(plugin_spec) == "string" and plugin_spec or plugin_spec[1]
	local plugin_name = string.match(plugin, ".*/(.*)")
	local plugins_dir = "~/projects/"

	if fn.isdirectory(fn.expand(plugins_dir .. plugin_name)) == 1 then
		plugin_spec[1] = plugins_dir .. plugin_name
	end

	use(plugin_spec)
end

M.packer_setup = function()
	use "editorconfig/editorconfig-vim"
	use "folke/lua-dev.nvim"
	use "nvim-treesitter/nvim-treesitter-textobjects"
	use "ray-x/lsp_signature.nvim"
	use "tpope/vim-fugitive"
	use "wbthomason/packer.nvim"
	use "JoosepAlviste/nvim-ts-context-commentstring"
	use "RRethy/nvim-treesitter-textsubjects"
	use "eddyekofo94/gruvbox-flat.nvim"
	use "lervag/vimtex"
	use "nvim-telescope/telescope-media-files.nvim"
	use "rafamadriz/friendly-snippets"

	use_syntax("arrufat/vala.vim", "vala")
	use_syntax("asciidoc/vim-asciidoc", { "asciidoc", "adoc" })
	use_syntax("cakebaker/scss-syntax.vim", "scss")
	use_syntax("cespare/vim-toml", "toml")
	use_syntax("gkz/vim-ls", "ls")
	use_syntax("jidn/vim-dbml", "dbml")
	use_syntax("leafo/moonscript-vim", "moon")
	use_syntax("neomutt/neomutt.vim", { "mutt", "neomutt" })
	use_syntax("tridactyl/vim-tridactyl", "tridactyl")
	use_syntax("vim-pandoc/vim-pandoc", "pandoc")
	use_syntax("vim-pandoc/vim-pandoc-syntax", "pandoc")
	use_syntax("iosmanthus/vim-nasm", "nasm")

	use { "vhyrro/tree-sitter-norg", ft = "norg" }
	use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
	use { "nvim-treesitter/playground", run = ":TSUpdate query" }
	use { "glacambre/firenvim", run = ":call firenvim#install(0)" }

	use_setup("nanozuki/tabby.nvim", "my.plugins.tabby")
	use_setup("windwp/nvim-autopairs", "my.plugins.autopairs")
	use_setup("nvim-lualine/lualine.nvim", "my.plugins.lualine")
	use_setup("mhartington/formatter.nvim", "my.plugins.formatter")
	use_setup("j-hui/fidget.nvim", "fidget")
	use_setup("goolord/alpha-nvim", "my.plugins.alpha")
	use_setup("numToStr/Comment.nvim", "Comment")
	use_setup("L3MON4D3/LuaSnip", "my.plugins.luasnip")

	use {
		"neovim/nvim-lspconfig",
		requires = { "onsails/lspkind-nvim", "williamboman/nvim-lsp-installer" },
		_auto = "my.plugins.lspconfig",
	}

	use { "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim", _auto = "todo-comments" }

	use {
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup { icons = true }
		end,
	}

	use {
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
		cmd = "MarkdownPreview",
		ft = { "markdown", "pandoc.markdown", "rmd" },
	}

	use {
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
			{ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
			{ "hrsh7th/cmp-path", after = "nvim-cmp" },
		},
		config = "require('my.plugins.cmp').setup()",
	}

	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = "require('my.plugins.treesitter').setup()",
	}

	use {
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
		config = "require('my.plugins.telescope').setup()",
	}

	-- local
	use_local {
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup {
				open_mapping = [[<c-\>]],
				persist_size = false,
				direction = "auto",
				size = function(term)
					if term:get_direction() == "horizontal" then
						return 15
					elseif term:get_direction() == "vertical" then
						return vim.o.columns * 0.3
					end
				end,
			}
		end,
	}

	use {
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup(nil, { css = true })
		end,
	}

	use_local {
		"romgrk/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup {
				enabled = true,
				max_lines = 3,
			}
		end,
	}

	use {
		"blackCauldron7/surround.nvim",
		config = function()
			require("surround").setup { mapping_style = "surround" }
		end,
	}

	use {
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup { auto_close = true }
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
