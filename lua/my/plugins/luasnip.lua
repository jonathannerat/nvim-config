local ls = require "luasnip"
local cmd = require("my.util.mapper").cmd

local M = {}

M.config = function()
	ls.config.set_config {
		history = true,
	}

	ls.snippets = {
		all = require "my.snippets.all",
		c = require "my.snippets.c",
		cpp = require "my.snippets.cpp",
		html = require "my.snippets.html",
		lua = require "my.snippets.lua",
		norg = require "my.snippets.norg",
		pandoc = require "my.snippets.pandoc",
		tex = require "my.snippets.tex",
	}
end

M.mappings = {
	["i|es|<c-e>"] = "luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<c-e>'",
	["i|es|<c-space>"] = "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-space>'",
	["i|ns|<c-b>"] = cmd "lua require'luasnip'.jump(-1)",
	["i|ns|<c-f>"] = cmd "lua require'luasnip'.jump(1)",
	["s|es|<c-e>"] = "luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<c-e>'",
	["s|ns|<c-b>"] = cmd "lua require'luasnip'.jump(-1)",
	["s|ns|<c-f>"] = cmd "lua require'luasnip'.jump(1)",
	["s|ns|<c-space>"] = cmd "lua require'luasnip'.expand_or_jump()",
}

return M
