local ls = require "luasnip"

local M = {}

M.setup = function()
	ls.config.set_config {
		history = true,
		ft_func = require("luasnip.extras.filetype_functions").from_filetype,
	}

	require("luasnip.loaders.from_lua").load {
		paths = vim.fn.stdpath "config" .. "/lua/my/snippets",
	}

	ls.filetype_extend("cpp", {"c"})
	ls.filetype_extend("pandoc", {"html", "tex"})

	require("luasnip.loaders.from_vscode").lazy_load()
end

return M
