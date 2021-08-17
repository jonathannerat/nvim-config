local ls = require "luasnip"

local M = {}

function M.setup()
	ls.config.set_config {
		history = true,
	}

	ls.snippets = {
		all = require "my.snippets.all",
		html = require "my.snippets.html",
		tex = require "my.snippets.tex",
		lua = require "my.snippets.lua",
		norg = require "my.snippets.norg",
		c = require "my.snippets.c",
		cpp = require "my.snippets.cpp",
	}
end

return M
