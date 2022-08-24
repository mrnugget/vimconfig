; Function definitions

(function_definition
  name: (identifier) @function)

; Call expression
(call_expression
  target: (identifier) @function)

; Identifiers

(parameter (identifier) @parameter)

; Types
(type) @type

; Expressions
(identifier) @variable
(number) @number
(string) @string

(true) @boolean
(false) @boolean

; Operators

[
  "-"
  "+"
  "="
  ">"
  "<"
  "=>"
  "<="
  "=="
  "!="
] @operator

; Keywords

"for" @repeat

"funk" @keyword.function
"return" @keyword.return
[
  "let"
] @keyword

[
  "else"
  "if"
 ] @conditional

; Punctuation
["(" ")" "{" "}"]  @punctuation.bracket
["," ":" ";"] @punctuation.delimiter

; Comments
(comment) @comment
