local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")

local M = {}

M.setup_config = {
	fast_wrap = {},
	disable_filetype = { "TelescopePrompt" }
}

M.rules = {
	Rule("$", "$", { "tex", "latex" })
		:with_pair(cond.not_after_regex_check("%%"))
		:with_move(cond.done())
		:with_cr(cond.none()),
	Rule("$", "$", { "pandoc" })
		:with_move(cond.done())
		:with_cr(cond.none()),
}

M.setup = function ()
	npairs.setup(M.setup_config)

	-- you need setup cmp first put this after cmp.setup()
	require("nvim-autopairs.completion.cmp").setup {
		map_cr = true, --  map <CR> on insert mode
		map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
		auto_select = true, -- automatically select the first item
		insert = false, -- use insert confirm behavior instead of replace
		map_char = { -- modifies the function or method delimiter by filetypes
			all = '(',
			tex = '{'
		}
	}

	npairs.add_rules(M.rules)
end

return M
