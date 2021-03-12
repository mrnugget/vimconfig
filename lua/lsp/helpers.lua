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

helpers.goimports = function(timeoutms)
  local context = { source = { organizeImports = true } }
  vim.validate { context = { context, "t", true } }
  local params = vim.lsp.util.make_range_params()
  params.context = context
  local method = "textDocument/codeAction"
  local resp = vim.lsp.buf_request_sync(0, method, params, timeoutms)
  if resp and resp[1] then
    local result = resp[1].result
    if result and result[1] then
      local edit = result[1].edit
      vim.lsp.util.apply_workspace_edit(edit)
    end
  end
  vim.lsp.buf.formatting()
end

return helpers
