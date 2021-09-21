local m = require "my.util.mapper"
local custom = require "my.custom"
local bind, cmd, lua = m.bind, m.cmd, m.lua

-- if true, replace the package list with local clones that
-- should be in ~/projects
local DEBUG_PACKAGES = custom.DEBUG
local DEBUG_PACKAGES_LIST = {
	"nvim-telescope/telescope.nvim"
}

local M = {}

M.packages = {
	"editorconfig/editorconfig-vim",
	"folke/lua-dev.nvim",
	"folke/tokyonight.nvim",
	"nvim-treesitter/nvim-treesitter-textobjects",
	"ray-x/lsp_signature.nvim",
	"stsewd/gx-extended.vim",
	"tpope/vim-commentary",
	"tpope/vim-surround",
	'JoosepAlviste/nvim-ts-context-commentstring',
	'RRethy/nvim-treesitter-textsubjects',
	'iosmanthus/vim-nasm',
	'lewis6991/impatient.nvim',
	'nvim-telescope/telescope-media-files.nvim',

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
	["vim-pandoc/vim-pandoc-syntax"] = { ft = "pandoc" },

	["neovim/nvim-lspconfig"] = {
		requires = { 'onsails/lspkind-nvim' },
		config = function()
			require("my.plugins.lspconfig").config()
		end,
		user = {
			m = {
				["n|ns|<leader>zi"] = lua 'require("my.plugins.zk").index()',
				["n|ns|<leader>zn"] = lua 'require("my.plugins.zk").new { title = vim.fn.input "Title: ", dir = vim.fn.input "Dir: " }'
			}
		}
	},

	["folke/todo-comments.nvim"] = {
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup {}
		end,
	},

	["andweeb/presence.nvim"] = {
		opt = true,
		config = function()
			require("presence"):setup()
		end,
	},

	["L3MON4D3/LuaSnip"] = {
		config = function()
			require("my.plugins.luasnip").config()
		end,
		user = {
			m = require("my.plugins.luasnip").mappings,
		},
	},

	["norcalli/nvim-colorizer.lua"] = {
		config = function()
			require("colorizer").setup(nil, { css = true })
		end,
	},

	["folke/trouble.nvim"] = {
		config = function()
			require("trouble").setup {
				icons = false,
			}
		end,
		user = {
			m = {
				["n|ns|<leader>tR"] = cmd "TroubleRefresh",
				["n|ns|<leader>tD"] = cmd "Trouble lsp_document_diagnostics",
				["n|ns|<leader>td"] = cmd "Trouble lsp_definitions",
				["n|ns|<leader>tr"] = cmd "Trouble lsp_references",
				["n|ns|<leader>tt"] = cmd "TroubleToggle",
			},
		},
	},

	["iamcco/markdown-preview.nvim"] = {
		run = "cd app && yarn install",
		cmd = "MarkdownPreview",
		ft = { "markdown", "pandoc.markdown", "rmd" },
		user = {
			g = {
				mkdp_open_to_the_world = 1,
				mkdp_echo_preview_url = 1,
				mkdp_port = 8007,
			},
			m = {
				["n|ns|<leader>mP"] = cmd "MarkdownPreviewStop",
				["n|ns|<leader>mp"] = cmd "MarkdownPreview",
			},
		},
	},

	["hrsh7th/nvim-cmp"] = {
		requires = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-path",
		},
		config = function()
			require("my.plugins.cmp").config()
		end,
	},

	["nvim-treesitter/nvim-treesitter"] = {
		run = ":TSUpdate",
		config = function()
			require("my.plugins.treesitter").config()
		end,
	},

	["hoob3rt/lualine.nvim"] = {
		config = function()
			require("my.plugins.lualine").config()
		end,
	},

	["nvim-telescope/telescope.nvim"] = {
		requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("my.plugins.telescope").config()
		end,
		user = {
			m = require("my.plugins.telescope").mappings,
		},
	},

	["vhyrro/neorg"] = {
		config = function()
			require("my.plugins.neorg").config()
		end,
		ft = "norg",
	},

	["steelsojka/pears.nvim"] = {
		config = function()
			require("pears").setup()
		end
	},

	["vim-pandoc/vim-pandoc"] = {
		user = {
			g = {
				["pandoc#formatting#mode"] = "h",
				["pandoc#formatting#textwidth"] = 120,
			},
		},
	},

	["eddyekofo94/gruvbox-flat.nvim"] = {
		user = {
			g = {
				gruvbox_flat_style = "hard",
			},
		},
	},

	["glacambre/firenvim"] = {
		run = ":call firenvim#install(0)",
		user = {
			g = {
				firenvim_config = {
					localSettings = {
						[".*"] = { cmdline = "neovim", takeover = "never" },
					},
				},
			},
		},
	},

	["lervag/vimtex"] = {
		user = {
			g = {
				tex_flavor = "latex",
				tex_conceal = "adbmg",
				vimtex_compiler_latexmk = {
					build_dir = "build",
					callback = 1,
					continuous = 1,
					executable = "latexmk",
					options = { "-verbose", "-file-line-error", "-synctex=1", "-interaction=nonstopmode" },
				},
			},
		},
	},

	["tpope/vim-fugitive"] = {
		user = {
			m = {
				["n|ns|<leader>g"] = cmd "G",
				["n|ns|<leader>gc"] = cmd "Git commit",
				["n|ns|<leader>gm"] = cmd "Git mergetool",
			},
		},
	},

	["kyazdani42/nvim-tree.lua"] = {
		user = {
			m = {
				["n|ns|<c-n>"] = cmd "NvimTreeToggle",
				["n|ns|<leader>N"] = cmd "NvimTreeFocus",
				["n|ns|<leader>n"] = cmd "NvimTreeFindFile",
			},
		},
	},
	["wbthomason/packer.nvim"] = {
		user = {
			m = {
				["n|ns|<leader>pc"] = cmd "PackerClean",
				["n|ns|<leader>pi"] = cmd "PackerInstall",
				["n|ns|<leader>pp"] = cmd "PackerCompile profile=true",
				["n|ns|<leader>ps"] = cmd "PackerSync",
				["n|ns|<leader>pu"] = cmd "PackerUpdate",
			},
		},
	},

	["lambdalisue/suda.vim"] = {
		user = {
			m = {
				["n|ns|<leader>sr"] = cmd "SudaRead",
				["n|ns|<leader>sw"] = cmd "SudaWrite",
			},
		},
	},

	["nvim-treesitter/playground"] = {
		run = ":TSUpdate query",
		user = {
			m = {
				["n|ns|<leader>th"] = cmd "TSHighlightCapturesUnderCursor",
				["n|ns|<leader>tp"] = cmd "TSPlaygroundToggle",
			},
		},
	},

	["~/projects/nvim-toggleterm.lua"] = {
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
		user = {
			m = {
				["n|ns|<leader>gp"] = cmd 'TermExec cmd="git pull"',
				["n|ns|<leader>gP"] = cmd 'TermExec cmd="git push"'
			}
		}
	},
}

if DEBUG_PACKAGES then
	for _, p in ipairs(DEBUG_PACKAGES_LIST) do
		local local_path = string.gsub(p, ".*/", "~/projects/")
		M.packages[local_path] = M.packages[p]
		M.packages[p] = nil
	end
end

local function packer_setup(use)
	local useropts = {}

	-- setup packages
	for k, package in pairs(M.packages) do
		if type(k) == "number" then
			package = { package }
		elseif type(k) == "string" then
			package[1] = k
		end

		if package.user then
			useropts[k] = package.user
			package.user = nil
		end

		use(package)
	end

	-- setup user options
	for _, opts in pairs(useropts) do
		-- define globals
		if opts.g then
			for gk, gv in pairs(opts.g) do
				vim.g[gk] = gv
			end
		end

		-- run commands
		if opts.c then
			for _, cmd in ipairs(opts.c) do
				if cmd:sub(1, 1) == ":" then
					vim.api.nvim_command(cmd:sub(2))
				end
			end
		end

		-- setup mappings
		if opts.m then
			bind(opts.m)
		end
	end
end

M.setup = function()
	require("packer").startup {
		packer_setup,
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
