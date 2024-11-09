;; Inject the tucan grammar into Rust strings that are bound to `let tucan =`
((let_declaration
   pattern: (identifier) @_new
   (#eq? @_new "tucan")
   value: [(raw_string_literal
             (string_content) @injection.content)
           (string_literal
             (string_content) @injection.content)])
 (#set! injection.language "tucan"))
