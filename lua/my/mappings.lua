local m = require "my.util.mapper"
local cmd, bind = m.cmd, m.bind

local M = {}

local mappings = {
	["c|n|<c-j>"] = "<down>",
	["c|n|<c-k>"] = "<up>",

	["i|es|<s-tab>"] = "v:lua.require'my.functions'.s_tab_complete()",
	["i|es|<tab>"] = "v:lua.require'my.functions'.tab_complete()",
	["i|ns|<m-j>"] = "<esc>:m .+1<CR>==gi",
	["i|ns|<m-k>"] = "<esc>:m .-2<CR>==gi",
	["i|n|jj"] = "<esc>",
	["i|n|kk"] = "<esc>",

	["n|ns|<c-t>"] = cmd "tabnew",
	["n|ns|<leader>Q"] = cmd "q!",
	["n|ns|<leader>Qa"] = cmd "qa!",
	["n|ns|<leader>cd"] = cmd "lcd %:h",
	["n|ns|<leader>ci"] = cmd "exe 'e ' .. stdpath('config') .. '/init.lua'",
	["n|ns|<leader>cm"] = cmd "exe 'e ' .. stdpath('config') .. '/lua/my/mappings.lua'",
	["n|ns|<leader>co"] = cmd "exe 'e ' .. stdpath('config') .. '/lua/my/options.lua'",
	["n|ns|<leader>cp"] = cmd "exe 'e ' .. stdpath('config') .. '/lua/my/plugins/init.lua'",
	["n|ns|<leader>gT"] = cmd "tabmove-",
	["n|ns|<leader>gt"] = cmd "tabmove+",
	["n|ns|<leader>hh"] = cmd "noh",
	["n|ns|<leader>ht"] = cmd [[keeppatterns /\s\+$<cr>]],
	["n|ns|<leader>q"] = cmd "q",
	["n|ns|<leader>qa"] = cmd "qa",
	["n|ns|<leader>r"] = cmd "e %",
	["n|ns|<leader>w"] = cmd "w",
	["n|ns|<m-j>"] = ":m .+1<CR>==",
	["n|ns|<m-k>"] = ":m .-2<CR>==",
	["n|n|<leader>p"] = ":Packer",
	["n|n|<space>"] = "",
	["n|n|Q"] = "",

	["s|es|<s-tab>"] = "v:lua.require('my.functions').s_tab_complete()",
	["s|es|<tab>"] = "v:lua.require('my.functions').tab_complete()",
	["t|ns|<c-m-q>"] = [[<c-\><c-n>]],

	["v|ns|<m-j>"] = ":m '>+1<cr>gv=gv",
	["v|ns|<m-k>"] = ":m '<-2<cr>gv=gv",
}

function M.setup()
	bind(mappings)
end

return M
