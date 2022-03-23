local m = require "my.util.mapper"
local lua, cmd, bind = m.lua, m.cmd, m.bind

local M = {}

local mappings = {
	["c|n|<c-j>"] = "<down>",
	["c|n|<c-k>"] = "<up>",

	["i|ns|<m-j>"] = "<esc>:m .+1<CR>==gi",
	["i|ns|<m-k>"] = "<esc>:m .-2<CR>==gi",
	["i|n|jj"] = "<esc>",
	["i|n|kk"] = "<esc>",

	["n|ns|<F10>"] = lua "require('dap').step_over()",
	["n|ns|<F11>"] = lua "require('dap').step_into()",
	["n|ns|<F12>"] = lua "require('dap').step_out()",
	["n|ns|<F5>"] = lua "require('dap').continue()",
	["n|ns|<c-n>"] = cmd "NvimTreeToggle",
	["n|ns|<c-t>"] = cmd "tabnew",
	["n|ns|<leader>A"] = cmd "Alpha",
	["n|ns|<leader>C"] = cmd "ColorizerToggle",
	["n|ns|<leader>F"] = cmd "FormatWrite",
	["n|ns|<leader>Q"] = cmd "q!",
	["n|ns|<leader>Qa"] = cmd "qa!",
	["n|ns|<leader>b"] = lua "require('dap').toggle_breakpoint()",
	["n|ns|<leader>cd"] = cmd "lcd %:h",
	["n|ns|<leader>ci"] = cmd "exe 'e ' .. stdpath('config') .. '/init.lua'",
	["n|ns|<leader>cm"] = cmd "exe 'e ' .. stdpath('config') .. '/lua/my/mappings.lua'",
	["n|ns|<leader>co"] = cmd "exe 'e ' .. stdpath('config') .. '/lua/my/options.lua'",
	["n|ns|<leader>cp"] = cmd "exe 'e ' .. stdpath('config') .. '/lua/my/plugins/init.lua'",
	["n|ns|<leader>f"] = cmd "Format",
	["n|ns|<leader>fF"] = cmd "Telescope find_files find_command=fd,-t,f,-t,l,-H,--no-ignore-vcs",
	["n|ns|<leader>fG"] = cmd "Telescope git_files git_dir=~/.local/src/dotrepo show_untracked=false",
	["n|ns|<leader>fM"] = cmd "Telescope media_files",
	["n|ns|<leader>fb"] = cmd "Telescope buffers",
	["n|ns|<leader>fd"] = cmd "Telescope find_files find_command=fd,-t,d,-L cwd=~",
	["n|ns|<leader>ff"] = cmd "Telescope find_files find_command=fd,-t,f,-t,l,-H",
	["n|ns|<leader>fg"] = cmd "Telescope git_files show_untracked=false",
	["n|ns|<leader>fh"] = cmd "Telescope help_tags",
	["n|ns|<leader>fl"] = cmd "Telescope live_grep layout_strategy=vertical",
	["n|ns|<leader>fm"] = cmd "Telescope man_pages",
	["n|ns|<leader>ft"] = cmd "Telescope treesitter",
	["n|ns|<leader>g"] = cmd "G",
	["n|ns|<leader>gP"] = cmd 'TermExec cmd="git push"',
	["n|ns|<leader>gT"] = cmd "tabmove-",
	["n|ns|<leader>gc"] = cmd "Git commit",
	["n|ns|<leader>gm"] = cmd "Git mergetool",
	["n|ns|<leader>gp"] = cmd 'TermExec cmd="git pull"',
	["n|ns|<leader>gt"] = cmd "tabmove+",
	["n|ns|<leader>hh"] = cmd "noh",
	["n|ns|<leader>ht"] = [[/\s\+$<cr>]],
	["n|ns|<leader>lp"] = lua "require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))",
	["n|ns|<leader>mp"] = cmd "MarkdownPreviewToggle",
	["n|ns|<leader>n"] = cmd "NvimTreeFindFile",
	["n|ns|<leader>pc"] = cmd "PackerClean",
	["n|ns|<leader>pi"] = cmd "PackerInstall",
	["n|ns|<leader>pp"] = cmd "PackerCompile profile=true",
	["n|ns|<leader>ps"] = cmd "PackerSync",
	["n|ns|<leader>pu"] = cmd "PackerUpdate",
	["n|ns|<leader>q"] = cmd "q",
	["n|ns|<leader>qa"] = cmd "qa",
	["n|ns|<leader>r"] = cmd "e %",
	["n|ns|<leader>tD"] = cmd "Trouble lsp_document_diagnostics",
	["n|ns|<leader>tR"] = cmd "TroubleRefresh",
	["n|ns|<leader>td"] = cmd "Trouble lsp_definitions",
	["n|ns|<leader>th"] = cmd "TSHighlightCapturesUnderCursor",
	["n|ns|<leader>tp"] = cmd "TSPlaygroundToggle",
	["n|ns|<leader>tr"] = cmd "Trouble lsp_references",
	["n|ns|<leader>tt"] = cmd "TroubleToggle",
	["n|ns|<leader>w"] = cmd "w",
	["n|ns|<leader>zi"] = lua 'require("my.plugins.zk").index()',
	["n|ns|<leader>zn"] = lua 'require("my.plugins.zk").new { title = vim.fn.input "Title: ", dir = vim.fn.input "Dir: " }',
	["n|ns|<m-j>"] = ":m .+1<CR>==",
	["n|ns|<m-k>"] = ":m .-2<CR>==",
	["n|n|<leader>p"] = ":Packer",
	["n|n|<space>"] = "",
	["n|n|Q"] = "",

	["s|es|<c-e>"] = "luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<c-e>'",

	["t|ns|<c-m-q>"] = [[<c-\><c-n>]],

	["v|ns|<m-j>"] = ":m '>+1<cr>gv=gv",
	["v|ns|<m-k>"] = ":m '<-2<cr>gv=gv",
}

function M.setup()
	bind(mappings)
end

return M
