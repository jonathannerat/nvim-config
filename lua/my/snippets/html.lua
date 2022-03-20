local ls = require "luasnip"

local html_snippets = {
	skel = [[<!DOCTYPE html>
<html>
<head>
	<title>${1:Title}</title>
	<meta charset="utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1, shrint-to-fit=no"/>
</head>
<body>
	$0
</body>]],
}

local snippets = {
	s("script", {
		t "<script",
		c(1, {
			sn(nil, {
				t ' src="',
				i(1, "path/to/file.js"),
				t '">',
			}),
			sn(nil, {
				t { ">", "\t" },
				i(1, "// code"),
				t { "", "" },
			}),
		}),
		i(0),
		t "</script>",
	}),
}

for trigger, snippet_def in pairs(html_snippets) do
	snippets[#snippets + 1] = ls.parser.parse_snippet(trigger, snippet_def)
end

return snippets
