local utils = require "my.utils"
local config = utils.config

local tabwidth = config "vim.tabwidth"

utils.set {
	autoindent = false,
	background = "dark",
	backup = false,
	conceallevel = 2,
	copyindent = true,
	cursorline = true,
	expandtab = true,
	fillchars = { eob = "~", horiz = "━", horizup = "┻", horizdown = "┳", vert = "┃", vertleft = "┨", vertright = "┣", verthoriz = "╋" },
	hidden = true,
	ignorecase = true,
	inccommand = "split",
	laststatus = 3,
	lazyredraw = true,
	linebreak = true,
	list = true,
	listchars = { tab = "│ ", trail = "·", extends = "…", precedes = "…", nbsp = "☠" },
	mouse = "nv",
	number = true,
	preserveindent = true,
	relativenumber = true,
	scrolloff = 3,
	shiftwidth = tabwidth,
	shortmess = { append = "ac" },
	showmatch = true,
	showmode = false,
	smartcase = true,
	spelllang = { "es", "en" },
	splitbelow = true,
	splitkeep = "cursor",
	splitright = true,
	swapfile = false,
	tabstop = tabwidth,
	termguicolors = true,
	textwidth = config "vim.textwidth",
	timeoutlen = config "vim.timeoutlen",
	undofile = true,
	wrap = true,
	writebackup = false,
}

vim.g.mapleader = " "

vim.cmd.colorscheme(config "ui.colorscheme")
