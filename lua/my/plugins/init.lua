local m = require "my.util.mapper"
local bind, cmd, lua = m.bind, m.cmd, m.lua

local M = {}

M.packages = {
	"editorconfig/editorconfig-vim",
	"folke/lua-dev.nvim",
	"folke/tokyonight.nvim",
	"nvim-treesitter/nvim-treesitter-textobjects",
	"ray-x/lsp_signature.nvim",
	"tpope/vim-commentary",
	"tpope/vim-surround",

	["arrufat/vala.vim"] = { ft = "vala" },
	["asciidoc/vim-asciidoc"] = { ft = { "adoc", "asciidoc" } },
	["cakebaker/scss-syntax.vim"] = { ft = "scss" },
	["cespare/vim-toml"] = { ft = "toml" },
	["embark-theme/vim"] = { as = "embark-theme" },
	["gkz/vim-ls"] = { as = "livescript-syntax", ft = "ls" },
	["leafo/moonscript-vim"] = { ft = "moon" },
	["neomutt/neomutt.vim"] = { ft = { "mutt", "neomutt" } },
	["nvim-telescope/telescope-fzf-native.nvim"] = { run = "make" },
	["tbastos/vim-lua"] = { ft = "lua" },
	["tridactyl/vim-tridactyl"] = { ft = "tridactyl" },
	["vhyrro/tree-sitter-norg"] = { ft = "norg" },
	["vim-pandoc/vim-pandoc-syntax"] = { ft = "pandoc" },

	["neovim/nvim-lspconfig"] = {
		config = function()
			require("my.plugins.lspconfig").config()
		end,
	},

	["folke/todo-comments.nvim"] = {
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup {}
		end,
	},

	["andweeb/presence.nvim"] = {
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
				["n|ns|<leader>td"] = cmd "Trouble lsp_document_diagnostics",
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

	["hrsh7th/nvim-compe"] = {
		config = function()
			require("my.plugins.compe").config()
		end,
		user = {
			m = require("my.plugins.compe").mappings,
		},
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

	["ahmedkhalf/project.nvim"] = {
		config = function()
			require("project_nvim").setup {
				silent_chdir = false,
				datapath = vim.fn.stdpath "data" .. "/projects",
			}
		end,
		user = {
			g = {
				nvim_tree_update_cwd = 1,
				nvim_tree_respect_buf_cwd = 1,
			},
		},
	},

	["vim-pandoc/vim-pandoc"] = {
		user = {
			g = {
				["pandoc#formattings#mode"] = "h",
				["pandoc#formattings#textwidth"] = 100,
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
}

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
