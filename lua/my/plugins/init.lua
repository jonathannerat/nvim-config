-- ensure packer.nvim is installed
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

local packages = {
	"editorconfig/editorconfig-vim",
	"folke/lua-dev.nvim",
	"folke/tokyonight.nvim",
	"lambdalisue/suda.vim",
	"nvim-treesitter/nvim-treesitter-textobjects",
	"ray-x/lsp_signature.nvim",
	"stsewd/gx-extended.vim",
	"tpope/vim-commentary",
	"tpope/vim-fugitive",
	"tpope/vim-surround",
	"wbthomason/packer.nvim",
	"windwp/nvim-ts-autotag",
	"JoosepAlviste/nvim-ts-context-commentstring",
	"RRethy/nvim-treesitter-textsubjects",
	"eddyekofo94/gruvbox-flat.nvim",
	"iosmanthus/vim-nasm",
	"lervag/vimtex",
	"nvim-telescope/telescope-media-files.nvim",

	["arrufat/vala.vim"] = { ft = "vala" },
	["asciidoc/vim-asciidoc"] = { ft = { "adoc", "asciidoc" } },
	["cakebaker/scss-syntax.vim"] = { ft = "scss" },
	["cespare/vim-toml"] = { ft = "toml", branch = "main" },
	["embark-theme/vim"] = { as = "embark-theme" },
	["gkz/vim-ls"] = { as = "livescript-syntax", ft = "ls" },
	["jidn/vim-dbml"] = { ft = "dbml" },
	["leafo/moonscript-vim"] = { ft = "moon" },
	["neomutt/neomutt.vim"] = { ft = { "mutt", "neomutt" }, branch = "main" },
	["tridactyl/vim-tridactyl"] = { ft = "tridactyl" },
	["vhyrro/tree-sitter-norg"] = { ft = "norg" },
	["vim-pandoc/vim-pandoc"] = { ft = "pandoc" },
	["vim-pandoc/vim-pandoc-syntax"] = { ft = "pandoc" },

	["nvim-telescope/telescope-fzf-native.nvim"] = { run = "make" },
	["nvim-treesitter/playground"] = { run = ":TSUpdate query" },

	["kyazdani42/nvim-tree.lua"] = { _auto = "nvim-tree" },
	["nanozuki/tabby.nvim"] = { _auto = "my.plugins.tabby" },
	["windwp/nvim-autopairs"] = { _auto = "my.plugins.autopairs" },
	["nvim-lualine/lualine.nvim"] = { _auto = "my.plugins.lualine" },
	["mhartington/formatter.nvim"] = { _auto = "my.plugins.formatter" },

	["neovim/nvim-lspconfig"] = {
		requires = { "onsails/lspkind-nvim", "williamboman/nvim-lsp-installer" },
		_auto = "my.plugins.lspconfig",
	},

	["folke/todo-comments.nvim"] = {
		requires = "nvim-lua/plenary.nvim",
		_auto = "todo-comments",
	},

	["L3MON4D3/LuaSnip"] = { _auto = "my.plugins.luasnip" },

	["folke/trouble.nvim"] = {
		_auto = { "trouble", opts = { icons = false } },
	},

	["nvim-neorg/neorg"] = {
		ft = "norg",
		_auto = {
			opts = {
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
			},
		},
	},

	["iamcco/markdown-preview.nvim"] = {
		run = "cd app && yarn install",
		cmd = "MarkdownPreview",
		ft = { "markdown", "pandoc.markdown", "rmd" },
	},

	["hrsh7th/nvim-cmp"] = {
		requires = {
			{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
			{ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
			{ "hrsh7th/cmp-path", after = "nvim-cmp" },
		},
		_auto = "my.plugins.cmp",
	},

	["nvim-treesitter/nvim-treesitter"] = {
		run = ":TSUpdate",
		_auto = "my.plugins.treesitter",
	},

	["nvim-telescope/telescope.nvim"] = {
		requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
		_auto = "my.plugins.telescope",
	},

	["glacambre/firenvim"] = {
		run = ":call firenvim#install(0)",
	},

	["~/projects/nvim-toggleterm.lua"] = {
		_auto = {
			"toggleterm",
			opts = {
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
			},
		},
	},

	["norcalli/nvim-colorizer.lua"] = {
		_auto = { "colorizer", unpack = true, opts = { nil, { css = true } } },
	},

	["marioortizmanero/adoc-pdf-live.nvim"] = {
		ft = { "adoc", "asciidoc" },
		_auto = { "adoc_pdf_live",
			opts = {
				binary = 'asciidoctor-pdf',
				params = '-r asciidoctor-mathematical'
			}
		},
	},
}

_G.Autosetup = {}

local function packer_setup(use)
	local i = 1

	-- setup packages
	for k, package in pairs(packages) do
		if type(k) == "number" then
			package = { package }
		elseif type(k) == "string" then
			package[1] = k
		end

		local auto = package._auto

		if auto then
			Autosetup[i] = {}

			if type(auto) == "string" then
				Autosetup[i].package = auto
			elseif type(auto) == "table" then
				Autosetup[i].package = auto[1] or string.match(package[1], ".*/(.*)")
				Autosetup[i].options = auto.opts
			end

			local confstr = "require(Autosetup[%d].package).setup(Autosetup[%d].options)"

			if auto.unpack then
				confstr = "require(Autosetup[%d].package).setup(unpack(Autosetup[%d].options))"
			end

			package.config = string.format(confstr, i, i)
			i = i + 1
		end

		package._auto = nil

		use(package)
	end
end

local packer_config = {
	display = {
		open_fn = function()
			return require("packer.util").float { border = "single" }
		end,
	},
	profile = {
		enabled = true,
		threshold = 1,
	},
}

require("packer").startup {
	packer_setup,
	config = packer_config,
}
