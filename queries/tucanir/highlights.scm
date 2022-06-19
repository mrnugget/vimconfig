; Expressions
(identifier) @variable
(number) @number

(true) @boolean
(false) @boolean

(id) @type
(register) @property

; Operators

[
 "<-"
 "->"
  "-"
  "+"
  ">"
  "<"
  "=>"
  "<="
  "=="
  "!="
] @operator

; Keywords

"block_funk" @namespace
"block" @keyword.function
"var" @function
"phi" @function.builtin
"call" @function.builtin

(call target: (identifier) @function)

[
  "block"
] @keyword

; Terminators
(terminator) @keyword
(terminator (goto) @method)
(terminator (if) @method)
(terminator (return) @method)
(terminator (halt) @method)

; ; Punctuation
["(" ")"]  @punctuation.bracket
["," ":"] @punctuation.delimiter
