local M = {}

M.options = {
	autoindent = false,
	background = "dark",
	backup = false,
	completeopt = "menuone,noselect",
	conceallevel = 2,
	copyindent = true,
	cursorline = true,
	expandtab = false,
	fillchars = "eob:~",
	hidden = true,
	ignorecase = true,
	inccommand = "split",
	lazyredraw = true,
	linebreak = true,
	list = true,
	listchars = "eol:↵,tab:│ ,trail:·,extends:…,precedes:…,nbsp:☠",
	number = true,
	preserveindent = true,
	relativenumber = true,
	scrolloff = 5,
	shiftwidth = 2,
	shortmess = vim.o.shortmess .. "ac",
	showmatch = true,
	showmode = false,
	smartcase = true,
	spelllang = "es,en",
	splitbelow = true,
	splitright = true,
	swapfile = false,
	tabstop = 2,
	termguicolors = true,
	timeoutlen = 300,
	undofile = true,
	wrap = true,
	writebackup = false,
	["+"] = {
		sessionoptions = { "options", "resize", "winpos", "terminal" },
	},
}

M.globals = {
	mapleader = " ",
}

M.setup = function()
	local appendopts = M.options["+"]
	M.options["+"] = nil
	if appendopts then
		for aopt, avalue in pairs(appendopts) do
			vim.opt[aopt]:append(avalue)
		end
	end

	for opt, value in pairs(M.options) do
		vim.o[opt] = value
	end

	for opt, value in pairs(M.globals) do
		vim.g[opt] = value
	end
end

return M
