; extends

((member_call_expression
   (scoped_call_expression
     (name) @_cls_id
     (name) @_cls_method_id)
   (name) @_method_id
   (arguments (argument (encapsed_string (string_content) @injection.content))))
  (#set! injection.language "sql")
  (#eq? @_cls_id "DB")
  (#eq? @_cls_method_id "connection")
  (#eq? @_method_id "select"))

((assignment_expression
   left: (variable_name (name) @_var)
   right: (_ (string_content) @injection.content))
  (#set! injection.language "sql")
  (#eq? @_var "sql"))
