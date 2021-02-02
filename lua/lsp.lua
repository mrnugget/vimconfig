-- lsp_status
local lsp_status = require('lsp-status')
lsp_status.register_progress()
lsp_status.config({
  indicator_errors = 'E',
  indicator_warnings = 'W',
  indicator_info = 'i',
  indicator_hint = '?',
  indicator_ok = 'Ok',
})

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- function to attach completion/lsp-satus when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
    lsp_status.on_attach(client)
end

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({
  on_attach=on_attach,
})

-- Enable gopls
nvim_lsp.gopls.setup({
  on_attach=on_attach,
  cmd = {"gopls", "serve"},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
    },
  },
})

function goimports(timeoutms)
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

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

-- populate quickfix list with diagnostics
local method = "textDocument/publishDiagnostics"
local default_callback = vim.lsp.callbacks[method]

vim.lsp.callbacks[method] = function(err, method, result, client_id)
  default_callback(err, method, result, client_id)

  if result and result.diagnostics then
    local item_list = {}

    for _, v in ipairs(result.diagnostics) do
      local fname = result.uri
      table.insert(item_list, {
        filename = fname,
        lnum = v.range.start.line + 1,
        col = v.range.start.character + 1;
        text = v.message;
      })
    end

    local old_items = vim.fn.getqflist()
    for _, old_item in ipairs(old_items) do
      local bufnr = vim.uri_to_bufnr(result.uri)
      if vim.uri_from_bufnr(old_item.bufnr) ~= result.uri then
        table.insert(item_list, old_item)
      end
    end
    vim.fn.setqflist({}, ' ', { title = 'LSP'; items = item_list; })
  end
end
