((local_variable_declaration
	(variable_declarator (identifier) @_identifier)
	(table
		(field (string) @html)
	)
	(#eq? @_identifier "html_snippets")
))

((local_variable_declaration
	(variable_declarator (identifier) @_identifier)
	(table
		(field (string) @c)
	)
	(#eq? @_identifier "c_snippets")
))

((local_variable_declaration
	(variable_declarator (identifier) @_identifier)
	(table
		(field (string) @latex)
	)
	(#eq? @_identifier "tex_snippets")
))

((local_variable_declaration
	(variable_declarator (identifier) @_identifier)
	(string) @vim
	(#match? @_identifier "vim_cmds_(pre|post)")
))

((function_call
	(field_expression) @_caller
	(arguments (string) @vim)
	(#eq? @_caller "vim.cmd")
))
