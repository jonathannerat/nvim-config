local npairs = require "nvim-autopairs"
local Rule = require "nvim-autopairs.rule"
local cond = require "nvim-autopairs.conds"

local M = {}

M.config = {
	fast_wrap = {},
	disable_filetype = { "TelescopePrompt" },
}

M.rules = {
	Rule("$", "$", { "tex", "latex" })
		:with_pair(cond.not_after_regex_check "%%")
		:with_move(cond.done())
		:with_cr(cond.none()),
	Rule("$", "$", { "pandoc" }):with_move(cond.done()):with_cr(cond.none()),
}

M.setup = function()
	npairs.setup(M.config)

	npairs.add_rules(M.rules)
end

return M
