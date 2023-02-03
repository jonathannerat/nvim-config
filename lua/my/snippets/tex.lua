local ls = require "luasnip"
local u = require "my.util.snippets"
local c, d, f, i, s, sn, t = ls.c, ls.d, ls.f, ls.i, ls.s, ls.sn, ls.t

local rec_list
---recursively add `\item`s to a latex list (enumerate, itemize, etc)
---@param indent boolean wether to the next \item or not
rec_list = function(_, _, _, indent)
	indent = indent == nil and true or indent

	return sn(nil, {
		c(1, {
			t "",
			sn(nil, { t { "", (indent and "\t" or "") .. "\\item " }, i(1), d(2, rec_list, {}) }),
		}),
	})
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
	s("begin", {
		t "\\begin{",
		i(1),
		t { "}", "\t" },
		i(0),
		t { "", "\\end{" },
		f(u.copy, 1),
		t "}",
	}),
	s("list", {
		t "\\begin{",
		c(1, { t "enumerate", t "itemize" }),
		t { "}", "\t\\item " },
		i(2),
		d(3, rec_list, {}),
		t { "", "\\end{" },
		f(u.copy, 1),
		t "}",
	}),
	s("-", {
		t "\\item ",
		i(1),
		d(2, rec_list, {}, {user_args = {false}}),
	}),
	s("sec", {
		t { "\\section{" },
		i(1, "Section"),
		t "}",
	}),
	s("ssec", {
		t { "\\subsection{" },
		i(1, "Subsection"),
		t "}",
	}),
	s("bb", {
		t "\\textbf{",
		i(1),
		t "}",
	}),
	s("ii", {
		t "\\textit{",
		i(1),
		t "}",
	}),
	s("tt", {
		t "\\texttt{",
		i(1),
		t "}",
	}),
	s("sc", {
		t "\\textsc{",
		i(1),
		t "}",
	}),
}

for trigger, snippet_def in pairs(tex_snippets) do
	snippets[#snippets + 1] = ls.parser.parse_snippet(trigger, snippet_def, {})
end

return snippets
