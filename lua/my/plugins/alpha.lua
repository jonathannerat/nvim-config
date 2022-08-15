local dashboard = require "alpha.themes.dashboard"

local M = {}

-- Set header
dashboard.section.header.val = {
	"                                                     ",
	"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
	"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
	"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
	"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
	"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
	"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
	"                                                     ",
}

-- Set menu
dashboard.section.buttons.val = {
	dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("f", "  > Find file here", ":cd . | :Telescope find_files previewer=false layout={width=0.6}<CR>"),
	dashboard.button("p", "  > Find projects", ":lua require'my.plugins.telescope'.pickers.projects()<CR>"),
	dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
	dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
	dashboard.button("u", "ﮮ  > Update", ":PackerSync<CR>"),
	dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
}

M.config = dashboard.opts

M.setup = function()
	-- Send config to alpha
	require("alpha").setup(M.config)
	-- Disable folding on alpha buffer
	vim.cmd [[
autocmd FileType alpha setlocal nofoldenable
	]]
end

return M
