local M = {}

local packages = {
	'eddyekofo94/gruvbox-flat.nvim',
	'editorconfig/editorconfig-vim',
	'folke/lua-dev.nvim',
	'folke/tokyonight.nvim',
	'kyazdani42/nvim-tree.lua',
	'lambdalisue/suda.vim',
	'lervag/vimtex',
	'nvim-treesitter/nvim-treesitter-textobjects',
	'ray-x/lsp_signature.nvim',
	'tpope/vim-commentary',
	'tpope/vim-fugitive',
	'tpope/vim-surround',
	'vim-pandoc/vim-pandoc',

	['arrufat/vala.vim']           = { ft = 'vala' },
	['asciidoc/vim-asciidoc']      = { ft = { 'adoc', 'asciidoc' } },
	['cakebaker/scss-syntax.vim']  = { ft = 'scss' },
	['cespare/vim-toml']           = { ft = 'toml' },
	['embark-theme/vim']           = { as = 'embark-theme' },
	['gkz/vim-ls']                 = { as = 'livescript-syntax', ft = 'ls' },
	['glacambre/firenvim']         = { run = ':call firenvim#install(0)' },
	['leafo/moonscript-vim']       = { ft = 'moon' },
	['neomutt/neomutt.vim']        = { ft = { 'mutt', 'neomutt' } },
	['nvim-telescope/telescope-fzf-native.nvim'] = { run = 'make' },
	['nvim-treesitter/playground'] = { run = ':TSUpdate query' },
	['tbastos/vim-lua']            = { ft = 'lua' },
	['tridactyl/vim-tridactyl']    = { ft = 'tridactyl' },
	['vhyrro/tree-sitter-norg']    = { ft = 'norg' },
	['vim-pandoc/vim-pandoc-syntax'] = { ft = 'pandoc' },
	['wbthomason/packer.nvim']     = { opt = true },

	['neovim/nvim-lspconfig'] = {
		config = function() require'my.plugins.lspconfig'.config() end
	},

	['folke/todo-comments.nvim'] = {
		requires = 'nvim-lua/plenary.nvim',
		config = function () require'todo-comments'.setup {} end
	},

	['andweeb/presence.nvim'] = {
		config = function() require'presence':setup() end
	},

	['L3MON4D3/LuaSnip'] = {
		config = function() require'my.snippets'.setup() end
	},

	['norcalli/nvim-colorizer.lua'] = {
		config = function()
			require'colorizer'.setup(nil, { css=true })
		end
	},

	['folke/trouble.nvim'] = {
		config = function()
			require'trouble'.setup{
				icons = false
			}
		end
	},

	['iamcco/markdown-preview.nvim'] = {
		run = 'cd app && yarn install',
		ft = { 'markdown', 'pandoc.markdown', 'rmd' }
	},

	['hrsh7th/nvim-compe'] = {
		config = function() require'my.plugins.compe'.config() end
	},

	['nvim-treesitter/nvim-treesitter'] = {
		run = ':TSUpdate',
		config = function() require'my.plugins.treesitter'.config() end
	},

	['hoob3rt/lualine.nvim'] = {
		config = function() require'my.plugins.lualine'.config() end
	},

	['nvim-telescope/telescope.nvim'] = {
		requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
		config = function() require'my.plugins.telescope'.config() end
	},

	['vhyrro/neorg'] = {
		config = function() require'my.plugins.neorg'.config() end,
		ft = 'norg'
	},
}

local function packer_setup(use)
		for k, package in pairs(packages) do
			if type(k) == 'number' then
				package = { package }
			elseif type(k) == 'string' then
				package[1] = k
			end

			use(package)
		end
end

function M.setup()
	require'packer'.startup {
		packer_setup,
		config = {
			display = {
				open_fn = function()
					return require'packer.util'.float { border = 'single' }
				end
			},
			profile = {
				enabled = true,
				threshold = 1,
			}
		}
	}
end

return M
