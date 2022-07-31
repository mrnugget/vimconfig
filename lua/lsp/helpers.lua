local helpers = {}

-- Taken from here: https://github.com/neovim/nvim-lspconfig/issues/115
helpers.goimports = function(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end

  vim.lsp.buf.format()
end

helpers.format_lsp = function()
  vim.lsp.buf.format {
    filter = function(clients)
      -- Never request tsserver for formatting, because we use prettier/eslint for that
      return vim.tbl_filter(function(client)
        return client.name ~= "tsserver" and client.name ~= "sumneko_lua"
      end, clients)
    end,
  }
end

return helpers
