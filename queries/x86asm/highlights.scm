(label (label_name) @label)

[
    (builtin)
    (global)
    (extern)
] @function.builtin

(ins (mnemonic) @function.builtin)

(register) @keyword

(global (identifier) @function)
(extern (identifier) @function)

(string_literal) @string

(integer_literal) @number

(comment) @comment

[
  ","
  "+"
  "-"
] @punctuation.delimiter

[
  "["
  "]"
] @punctuation.bracket

(section) @namespace
