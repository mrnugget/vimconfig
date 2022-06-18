(
 (let_declaration
   pattern: (identifier) @_id
   ;; capture content
   value: (raw_string_literal) @content)

 ;; remove the r#" at the start and the "# at the end
 (#offset! @content 0 3 0 -2)
 (#set! "language" "tucan")
 (#eq? @_id "tucan")
)
