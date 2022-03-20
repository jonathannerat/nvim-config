local ls = require "luasnip"

local function get_repo_from_clipboard()
	local clipboard = vim.fn.getreg("+", 1)
	local content = string.match(clipboard, "https?://github.com/([%w-_%.]*/[%w-_%.]*)")

	return sn(nil, { i(1, content or "username/repository") })
end

local lua_snippets = {
	mod = [[local ${1:M} = {\}

$1.${2:key} = ${3:value}

return $1]],
	class = [[local ${1:Class}
$1 = {
	__index = $1
\}

function $1:new(o)
	o = o or {\}
	setmetatable(o, self)
	o.__index = o

	$2

	return o
end

$0

return $1]],
}

local snippets = {
	s("pplug", {
		c(1, {
			sn(nil, {
				t '"',
				d(1, get_repo_from_clipboard, {}),
				t '",',
			}),
			sn(nil, {
				t { "{", "\t'" },
				d(1, get_repo_from_clipboard, {}),
				t { "'", "}," },
			}),
			sn(nil, {
				t '["',
				d(1, get_repo_from_clipboard, {}),
				t '"] = {',
				t { "", "\t" },
				i(2),
				t { "", "}," },
			}),
		}),
	}),
	s("snip", {
		t "s(",
		c(1, {
			sn(nil, { t "'", i(1, "trigger"), t { "', {", "\t" }, i(2), t { "", "}" } }),
			sn(nil, { t "{ trig='", i(1, "trigger"), t "', ", t { "wordTrig=false }, {", "\t" }, i(2), t "}" }),
			sn(nil, {
				t "{ trig='",
				i(1, "trigger"),
				t "', ",
				t { "regTrig=true }, {", "\t" },
				i(2),
				t { "", "}" },
			}),
		}),
		t ")",
	}),
	s("key", {
		c(1, {
			sn(nil, { i(1, "key"), t " = ", i(2, '"value"'), t "," }),
			sn(nil, {
				t '["',
				i(1, "key"),
				t '"] = ',
				c(2, {
					sn(nil, { t '"', i(1, "value"), t '"' }),
					sn(nil, { t { "{", "\t" }, i(1), t { "", "}" } }),
					sn(nil, { i(1, "value") }),
				}),
				t ",",
			}),
		}),
	}),
}

for trigger, snippet_def in pairs(lua_snippets) do
	snippets[#snippets + 1] = ls.parser.parse_snippet(trigger, snippet_def)
end

return snippets
