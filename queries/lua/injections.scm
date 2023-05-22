(
    (function_call (identifier) @_identifier (arguments _ (string content: _ @lua)))
    (#match? @_identifier "lua_command")
)

(
    (function_call (identifier) @_identifier (arguments (string content: _ @lua)))
    (#match? @_identifier "luacmd")
)

(
    (function_call (identifier) @_identifier (arguments (string content: _ @vim)))
    (#match? @_identifier "vimcmd")
)
