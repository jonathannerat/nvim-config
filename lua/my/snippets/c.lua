local ls = require "luasnip"
local u = require "my.util.snippets"

local function get_defguard()
	local filename = vim.fn.expand "%:t"
	filename = filename:gsub("-", "_"):gsub("%.(%w+)$", "_%1"):upper()

	return sn(nil, { i(1), i(2, filename) })
end

local rec_case
rec_case = function()
	return sn(nil, {
		c(1, {
			t "",
			sn(nil, { t { "", "\tdefault:", "\t\t" }, i(1, "// code") }),
			sn(nil, {
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
}

local snippets = {
	s("pragma", {
		t { "#ifndef " },
		d(1, get_defguard, {}),
		t { "", "#define " },
		f(u.copy, 1),
		t { "", "", "" },
		i(2, "// code"),
		t { "", "", "#endif // " },
		f(u.copy, 1),
	}),
	s("sw", {
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
	s("case", {
		t { "case " },
		i(1, "value"),
		t { ":", "\t\t" },
		i(2, "// code"),
		t { "", "\t\tbreak;" },
		d(3, rec_case, {}),
	}),
	s("printf", {
		t "printf(",
		c(1, {
			sn(nil, { t '"', i(1), t '\\n", ', i(2) }),
			sn(nil, { t '"', i(1), t '\\n"' }),
			sn(nil, { t '"', i(1), t '"' }),
		}),
		t ");",
	}),
}

for trigger, snippet_def in pairs(c_snippets) do
	snippets[#snippets + 1] = ls.parser.parse_snippet(trigger, snippet_def)
end

return snippets
