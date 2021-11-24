-- ensure packer.nvim is installed
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local packages = {
	"editorconfig/editorconfig-vim",
	"wbthomason/packer.nvim",
	"folke/lua-dev.nvim",
	"folke/tokyonight.nvim",
	"nvim-treesitter/nvim-treesitter-textobjects",
	"ray-x/lsp_signature.nvim",
	"stsewd/gx-extended.vim",
	"tpope/vim-commentary",
	"tpope/vim-surround",
	"windwp/nvim-ts-autotag",
	'JoosepAlviste/nvim-ts-context-commentstring',
	'RRethy/nvim-treesitter-textsubjects',
	'iosmanthus/vim-nasm',
	'norcalli/nvim-colorizer.lua',
	'nvim-telescope/telescope-media-files.nvim',
	"lambdalisue/suda.vim",
	'eddyekofo94/gruvbox-flat.nvim',
	'lervag/vimtex',
	"tpope/vim-fugitive",

	["arrufat/vala.vim"] = { ft = "vala" },
	["asciidoc/vim-asciidoc"] = { ft = { "adoc", "asciidoc" } },
	["cakebaker/scss-syntax.vim"] = { ft = "scss" },
	["cespare/vim-toml"] = { ft = "toml", branch = "main" },
	["embark-theme/vim"] = { as = "embark-theme" },
	["gkz/vim-ls"] = { as = "livescript-syntax", ft = "ls" },
	["leafo/moonscript-vim"] = { ft = "moon" },
	["neomutt/neomutt.vim"] = { ft = { "mutt", "neomutt" } },
	["nvim-telescope/telescope-fzf-native.nvim"] = { run = "make" },
	["tridactyl/vim-tridactyl"] = { ft = "tridactyl" },
	["vhyrro/tree-sitter-norg"] = { ft = "norg" },
	["vim-pandoc/vim-pandoc"] = { ft = 'pandoc' },
	["vim-pandoc/vim-pandoc-syntax"] = { ft = "pandoc" },
	["jidn/vim-dbml"] = { ft = "dbml" },

	['neovim/nvim-lspconfig'] = {
		requires = { 'onsails/lspkind-nvim', 'williamboman/nvim-lsp-installer' },
		autosetup = 'my.plugins.lspconfig',
	},

	['folke/todo-comments.nvim'] = {
		requires = 'nvim-lua/plenary.nvim',
		autosetup = 'todo-comments',
	},

	['L3MON4D3/LuaSnip'] = {
		autosetup = 'my.plugins.luasnip',
	},


	['folke/trouble.nvim'] = {
		autosetup = {
			as = 'trouble',
			opts = { icons = false }
		}
	},

	['nvim-neorg/neorg'] = {
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
						config = {
							engine = "nvim-cmp"
						}
					},
				},
			}
		end,
		ft = "norg",
	},

	['iamcco/markdown-preview.nvim'] = {
		run = 'cd app && yarn install',
		cmd = 'MarkdownPreview',
		ft = { 'markdown', 'pandoc.markdown', 'rmd' },
	},

	["hrsh7th/nvim-cmp"] = {
		requires = {
			{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
			{ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
			{ "hrsh7th/cmp-path", after = "nvim-cmp" },
		},
		autosetup = 'my.plugins.cmp'
	},


	['nvim-treesitter/nvim-treesitter'] = {
		run = ':TSUpdate',
		autosetup = 'my.plugins.treesitter',
	},

	['hoob3rt/lualine.nvim'] = {
		autosetup = 'my.plugins.lualine',
	},

	['rmagatti/session-lens'] = {
		after = 'auto-session',
		config = function()
			require('auto-session').setup {
				path_display = { 'tail' },
				preview = false,
			}
		end,
	},

	['rmagatti/auto-session'] = {
		autosetup = {
			opts = {
				auto_save_enabled = false,
				auto_restore_enabled = true,
				auto_session_allowed_dirs = { '~/projects' },
			}
		}
	},

	['nvim-telescope/telescope.nvim'] = {
		requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
		autosetup = 'my.plugins.telescope',
	},

	['windwp/nvim-autopairs'] = {
		autosetup = 'my.plugins.autopairs',
	},

	['glacambre/firenvim'] = {
		run = ':call firenvim#install(0)',
	},

	['kyazdani42/nvim-tree.lua'] = {
		autosetup = 'nvim-tree'
	},

	['nvim-treesitter/playground'] = {
		run = ':TSUpdate query',
	},

	['nanozuki/tabby.nvim'] = {
		autosetup = 'my.plugins.tabby',
	},

	['~/projects/nvim-toggleterm.lua'] = {
		autosetup = {
			as = 'toggleterm',
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
			}
		}
	},

	['lukas-reineke/format.nvim'] = {
		autosetup = {
			as = 'format',
			opts = {
				['*'] = {
					{ cmd = {"sed -i 's/[ \t]*$//'"} } -- remove trailing whitespace
				},
				php = {
					cmd = { 'php-formatter formatter:use:sort'}
				}
			}
		}
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

		local autosetup = package.autosetup

		if autosetup then
			Autosetup[i] = {}

			if type(autosetup) == "string" then
			Autosetup[i].package = autosetup
			elseif type(autosetup) == "table" then
				Autosetup[i].package = autosetup.as or string.match(package[1], '.*/(.*)')
				Autosetup[i].config = autosetup.opts
			end

			local istr = tostring(i)
			package.config = "require(Autosetup[" .. istr .. "].package).setup(Autosetup[" .. istr .. "].config)"
			i = i + 1
		end

		package.autosetup = nil

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

require('colorizer').setup(nil, { css = true })
