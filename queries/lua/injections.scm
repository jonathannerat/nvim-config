((table_constructor
   (field
     (identifier) @_id
     (string content: _ @injection.content)
     ))
 (#set! injection.language "lua")
 (#eq? @_id "lua"))

((table_constructor
   (field
     (identifier) @_id
     (string content: _ @injection.content)
     ))
 (#set! injection.language "vim")
 (#eq? @_id "vim"))
