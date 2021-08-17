local M = {}

M.packages = {
	"editorconfig/editorconfig-vim",
	"folke/lua-dev.nvim",
	"folke/tokyonight.nvim",
	"kyazdani42/nvim-tree.lua",
	"lambdalisue/suda.vim",
	"nvim-treesitter/nvim-treesitter-textobjects",
	"ray-x/lsp_signature.nvim",
	"tpope/vim-commentary",
	"tpope/vim-fugitive",
	"tpope/vim-surround",
	"wbthomason/packer.nvim",

	["arrufat/vala.vim"] = { ft = "vala" },
	["asciidoc/vim-asciidoc"] = { ft = { "adoc", "asciidoc" } },
	["cakebaker/scss-syntax.vim"] = { ft = "scss" },
	["cespare/vim-toml"] = { ft = "toml" },
	["embark-theme/vim"] = { as = "embark-theme" },
	["gkz/vim-ls"] = { as = "livescript-syntax", ft = "ls" },
	["leafo/moonscript-vim"] = { ft = "moon" },
	["neomutt/neomutt.vim"] = { ft = { "mutt", "neomutt" } },
	["nvim-telescope/telescope-fzf-native.nvim"] = { run = "make" },
	["nvim-treesitter/playground"] = { run = ":TSUpdate query" },
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
			require("my.snippets").setup()
		end,
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
		},
	},

	["hrsh7th/nvim-compe"] = {
		config = function()
			require("my.plugins.compe").config()
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

		if opts.c then
			for _, cmd in ipairs(opts.c) do
				if cmd:sub(1, 1) == ":" then
					vim.api.nvim_command(cmd:sub(2))
				end
			end
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
