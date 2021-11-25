local ls = require "luasnip"
local S = ls.snippet
local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local s = ls.snippet_node
local t = ls.text_node

local function get_repo_from_clipboard()
	local clipboard = vim.fn.getreg("+", 1)
	local content = string.match(clipboard, "https?://github.com/([%w-_%.]*/[%w-_%.]*)")

	return s(nil, { i(1, content or "username/repository") })
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
	S("pplug", {
		c(1, {
			s(nil, {
				t '"',
				d(1, get_repo_from_clipboard, {}),
				t '",',
			}),
			s(nil, {
				t { "{", "\t'" },
				d(1, get_repo_from_clipboard, {}),
				t { "'", "}," },
			}),
			s(nil, {
				t '["',
				d(1, get_repo_from_clipboard, {}),
				t '"] = {',
				t { "", "\t" },
				i(2),
				t { "", "}," },
			}),
		}),
	}),
	S("snip", {
		t "S(",
		c(1, {
			s(nil, { t "'", i(1, "trigger"), t { "', {", "\t" }, i(2), t { "", "}" } }),
			s(nil, { t "{ trig='", i(1, "trigger"), t "', ", t { "wordTrig=false }, {", "\t" }, i(2), t "}" }),
			s(nil, {
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
	S("key", {
		c(1, {
			s(nil, { i(1, "key"), t " = ", i(2, '"value"'), t "," }),
			s(nil, {
				t '["',
				i(1, "key"),
				t '"] = ',
				c(2, {
					s(nil, { t '"', i(1, "value"), t '"' }),
					s(nil, { t { "{", "\t" }, i(1), t { "", "}" } }),
					s(nil, { i(1, "value") }),
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
