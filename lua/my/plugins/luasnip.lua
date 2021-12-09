local ls = require "luasnip"
local cmd = require("my.util.mapper").cmd

local M = {}

M.setup = function()
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

	require("luasnip.loaders.from_vscode").lazy_load()

end

return M
