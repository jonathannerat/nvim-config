(table_constructor
  (field
    name: (identifier) @_field
    value: (string
      content: (_) @injection.content))
  ; limit so only 2-argument functions gets matched before pred handle
  (#eq? @_field "lua")
  (#set! injection.language "lua"))

(table_constructor
  (field
    name: (identifier) @_field
    value: (string
      content: (_) @injection.content))
  ; limit so only 2-argument functions gets matched before pred handle
  (#eq? @_field "vim")
  (#set! injection.language "vim"))
