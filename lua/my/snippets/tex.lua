local ls = require "luasnip"
local u = require "my.util.snippets"
local S = ls.snippet
local c = ls.choice_node
local d = ls.dynamic_node
local f = ls.function_node
local s = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node

local rec_list
---recursively add `\item`s to a latex list (enumerate, itemize, etc)
---@param indent boolean wether to the next \item or not
---@return SnippetNote
rec_list = function(_, _, indent)
	indent = indent == nil and true or indent

	return s(nil, {
		c(1, {
			t "",
			s(nil, { t { "", (indent and "\t" or "") .. "\\item " }, i(1), d(2, rec_list, {}) }),
		}),
	})
end

---choose between different font types
---@param type '"b"'|'"i"'|'"t"' which font type should be the first
---@return SnippetNode
local function text_faces(_, _, type)
	local choices = {
		t "\\textbf{",
		t "\\textit{",
		t "\\texttt{",
	}

	local swap = false
	if type == "i" then
		swap = 2
	elseif type == "t" then
		swap = 3
	end

	if swap then
		local tmp = choices[1]
		choices[1] = choices[swap]
		choices[swap] = tmp
	end

	return s(nil, { c(2, choices), i(1), t "}" })
end

local tex_snippets = {
	skel = [[\documentclass[a4paper,10pt]{article\}

\usepackage[utf8]{inputenc\}
\usepackage[spanish]{babel\}

\usepackage{float\}
\usepackage{graphicx\}
\usepackage{subcaption\}

\author{${1:Jonathan Teran}\}
\title{${2:Document Title}\}
\date{\}

\begin{document\}
$0
\end{document\}]],
	fig = [[\begin{figure\}
	\centering
	\includegraphics[width=${2:\textwidth}]{${1:path/to/image.png}\}
	\caption{${3:Caption}\}
	\label{fig:${4:label}\}
\end{figure\}]],
}

local snippets = {
	S("begin", {
		t "\\begin{",
		i(1),
		t { "}", "\t" },
		i(0),
		t { "", "\\end{" },
		f(u.copy, 1),
		t "}",
	}),
	S("list", {
		t "\\begin{",
		c(1, { t "enumerate", t "itemize" }),
		t { "}", "\t\\item " },
		i(2),
		d(3, rec_list, {}),
		t { "", "\\end{" },
		f(u.copy, 1),
		t "}",
	}),
	S("-", {
		t "\\item ",
		i(1),
		d(2, rec_list, {}, false),
	}),
	S("sec", {
		t { "\\section{" },
		i(1, "Section"),
		t "}",
	}),
	S("ssec", {
		t { "\\subsection{" },
		i(1, "Subsection"),
		t "}",
	}),
	S("b", {
		t "\\textbf{",
		i(1),
		t "}",
	}),
	S("i", {
		t "\\textit{",
		i(1),
		t "}",
	}),
	S("tt", {
		t "\\texttt{",
		i(1),
		t "}",
	}),
	S("mi", {
		t "$",
		i(1),
		t "$",
	}),
	S("mb", {
		t { "\\[", "\t" },
		i(1),
		t { "", "\\]" },
	}),
}

for trigger, snippet_def in pairs(tex_snippets) do
	snippets[#snippets + 1] = ls.parser.parse_snippet(trigger, snippet_def)
end

return snippets
