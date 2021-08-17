local ls = require "luasnip"
local S, c, s, t, i = ls.s, ls.c, ls.sn, ls.t, ls.i

---snippet builder for AutoPairs like behavious
---@param p 'string'|'table' table with 2 entries with the pair, or a single string to be duplicated
---@param opts table options to be aplied to the pair snippet
---@return Snippet
local function pairs(p, opts)
	local l = type(p) == "table" and p[1] or p
	local r = type(p) == "table" and p[2] or p

	local choices = {
		s(nil, { t(l), i(1), t(r) }),
	}

	if opts and opts.spaced then
		choices[#choices + 1] = s(nil, { t(l .. " "), i(1), t(" " .. r) })
	end

	if opts and opts.newline then
		choices[#choices + 1] = s(nil, { t { l, "\t" }, i(1), t { "", r } })
	end

	return S({ trig = l, wordTrig = false }, {
		c(1, choices),
	})
end

return {
	pairs({ "(", ")" }, { spaced = true, newline = true }),
	pairs({ "{", "}" }, { spaced = true, newline = true }),
	pairs({ "[", "]" }, { spaced = true, newline = true }),
	pairs { "[[", "]]" },
	pairs "`",
	pairs "'",
	pairs '"',
}
