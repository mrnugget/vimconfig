(
 (let_declaration
   pattern: (identifier) @_id
   value: (raw_string_literal) @c)

 (#offset! @c 0 3 0 -2)
 (#eq? @_id "tucan")
)
