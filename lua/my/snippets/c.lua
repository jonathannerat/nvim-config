local u = require "my.util.snippets"
local ls = require "luasnip"
local S, c, d, f, i, s, t = ls.s, ls.c, ls.d, ls.f, ls.i, ls.sn, ls.t

local function get_defguard()
	local filename = vim.fn.expand "%:t"
	filename = filename:gsub("-", "_"):gsub("%.(%w+)$", "_%1"):upper()

	return s(nil, { i(1), i(2, filename) })
end

local rec_case
rec_case = function()
	return s(nil, {
		c(1, {
			t "",
			s(nil, { t { "", "\tdefault:", "\t\t" }, i(1, "// code") }),
			s(nil, {
				t { "", "\tcase " },
				i(1, "value"),
				t { ":", "\t\t" },
				i(2, "// code"),
				t { "", "\t\tbreak;" },
				d(3, rec_case, {}),
			}),
		}),
	})
end

local c_snippets = {
	skel = [[#include <stdio.h>

int main(int argc, char** arv) {
	${1:printf("Hello world!\n");}
	return 0;
\}]],
	["while"] = [[while (${1:condition}) {
	${2:// code}
\}]],
}

local snippets = {
	S("pragma", {
		t { "#ifndef " },
		d(1, get_defguard, {}),
		t { "", "#define " },
		f(u.copy, 1),
		t { "", "", "" },
		i(2, "// code"),
		t { "", "", "#endif // " },
		f(u.copy, 1),
	}),
	S("sw", {
		t "switch (",
		i(1, "condition"),
		t { ") {", "\tcase " },
		i(2, "value"),
		t { ":", "\t\t" },
		i(3, "// code"),
		t { "", "\t\tbreak;" },
		d(4, rec_case, {}),
		t { "", "}" },
	}),
	S("case", {
		t { "case " },
		i(2, "value"),
		t { ":", "\t\t" },
		i(3, "// code"),
		t { "", "\t\tbreak;" },
		d(4, rec_case, {}),
	}),
	S("printf", {
		t "printf(",
		c(1, {
			s(nil, { t '"', i(1), t '\\n", ', i(2) }),
			s(nil, { t '"', i(1), t '\\n"' }),
			s(nil, { t '"', i(1), t '"' }),
		}),
		t ");",
	}),
}

for trigger, snippet_def in pairs(c_snippets) do
	snippets[#snippets + 1] = ls.parser.parse_snippet(trigger, snippet_def)
end

return snippets
