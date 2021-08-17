local ls = require'luasnip'

local S = ls.snippet
local d = ls.dynamic_node
local i = ls.insert_node
local s = ls.snippet_node
local t = ls.text_node

local function get_clipboard()
	return s(nil, { i(1, vim.fn.getreg('+', 1)) })
end

return {
	S('href',{
		t '[', i(1, 'description'), t '](', d(2, get_clipboard, {}), t ')', i(0)
	})
}
