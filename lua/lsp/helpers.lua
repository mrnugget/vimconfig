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

helpers.goimports = function()
    vim.lsp.buf.formatting_sync(nil, 1000)
end

return helpers
