local helpers = {}

-- See https://github.com/neovim/nvim-lspconfig/issues/465
-- Can hopefully be removed when these are fixed:
-- - https://github.com/neovim/neovim/pull/13692
-- - https://github.com/neovim/neovim/pull/13703
helpers.format_rust = function()
  local lineno = vim.api.nvim_win_get_cursor(0)
  vim.lsp.buf.formatting_sync(nil, 1000)
  vim.api.nvim_win_set_cursor(0, lineno)
end

-- Taken from here: https://github.com/neovim/nvim-lspconfig/issues/115
helpers.goimports = function(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit)
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end

  vim.lsp.buf.formatting()
end

return helpers
