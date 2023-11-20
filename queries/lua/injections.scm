; Injections in nvim config
(
 (function_call
   (identifier) @_identifier
   (arguments _ (string content: _ @lua)))
 (#match? @_identifier "lua_command"))

(
 (function_call
   (identifier) @_identifier
   (arguments (string content: _ @lua)))
 (#match? @_identifier "luacmd"))

(
 (function_call
   (identifier) @_identifier
   (arguments (string content: _ @vim)))
 (#match? @_identifier "vimcmd"))

; Injections in awesome config
(
 (function_call
   (identifier) @_identifier
   (arguments (string content: _ @bash)))
 (#match? @_identifier "spawn"))

(
 (function_call
   (_ _ (identifier) @_identifier)
   (arguments (string content: _ @bash)))
 (#match? @_identifier "with_shell"))

(
 (function_call
   (dot_index_expression (identifier) (identifier) @_identifier)
   (arguments (string content: _ @bash)))
 (#match? @_identifier "with_shell"))
