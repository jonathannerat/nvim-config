local ls = require "luasnip"
local S, c, s, t, i = ls.s, ls.c, ls.sn, ls.t, ls.i

---snippet builder for AutoPairs like behavious
---@param p 'string'|'table' table with 2 entries with the pair, or a single string to be duplicated
---@param opts table options to be aplied to the pair snippet
---@return Snippet
local function pairs(p, opts)
	local l = type(p) == "table" and p[1] or p
	local r = type(p) == "table" and p[2] or p
	opts = opts or { "empty", "spaced", "newline" }

	local choices = {}

	for _, opt in ipairs(opts) do
		if opt == "empty" then
			choices[#choices+1] = s(nil, { t(l), i(1), t(r) })
		elseif opt == "spaced" then
			choices[#choices + 1] = s(nil, { t(l .. " "), i(1), t(" " .. r) })
		elseif opt == "newline" then
			choices[#choices + 1] = s(nil, { t { l, "\t" }, i(1), t { "", r } })
		end
	end

	return S({ trig = l, wordTrig = false }, {
		c(1, choices),
	})
end

return {
	pairs {  "(", ")" },
	pairs {  "[", "]" },
	pairs({  "{", "}" }, { "newline", "spaced", "empty" }),
	pairs({ "[[", "]]" }, { "empty", "newline" }),
	pairs("`", { "empty" }),
	pairs("'", { "empty" }),
	pairs('"', { "empty" }),
}
