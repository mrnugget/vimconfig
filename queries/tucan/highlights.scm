; Function calls

; (call_expression
;   function: (identifier) @function)

; (call_expression
;   function: (selector_expression
;     field: (field_identifier) @function.method))

; Function definitions

(function_declaration
  name: (identifier) @function)

; (method_declaration
;   name: (field_identifier) @function.method)

; Identifiers

(type) @type
(identifier) @variable

; Operators

[
  "-"
  "+"
  "!"
  "!="
  "<"
  "<="
  "="
  "=="
  ">"
  ">="
] @operator

; Keywords

[
  "funk"
  "if"
  "return"
  "let"
] @keyword
