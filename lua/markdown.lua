local curl = require "plenary.curl"

local markdown = {}

markdown.markdown_paste = function(link)
  link = link or vim.fn.getreg "+"

  if not vim.startswith(link, "https://") then
    return
  end

  local request = curl.get(link)
  if not request.status == 200 then
    print "Failed to get link"
    return
  end

  local html_parser = vim.treesitter.get_string_parser(request.body, "html")
  if not html_parser then
    print "Must have html parser installed"
    return
  end

  local tree = (html_parser:parse() or {})[1]
  if not tree then
    print "Failed to parse tree"
    return
  end

  local query = vim.treesitter.parse_query(
    "html",
    [[
      (
       (element
        (start_tag
         (tag_name) @tag)
        (text) @text
       )

       (#eq? @tag "title")
      )
    ]]
  )

  for id, node in query:iter_captures(tree:root(), request.body, 0, -1) do
    local name = query.captures[id]
    if name == "text" then
      local title = vim.treesitter.get_node_text(node, request.body)
      vim.api.nvim_input(string.format("a[%s](%s)", title, link))
      return
    end
  end
end

vim.api.nvim_set_keymap("n", "<leader>mdp", "<cmd>lua require('markdown').markdown_paste()<cr>", {silent = true, noremap = true})

return markdown
