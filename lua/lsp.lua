-- Setup local vars for easier access
local nvim_lsp = require('lspconfig')
local configs = require('lspconfig/configs')

local lsp_status = require('lsp-status')
local completion = require('completion')

-- Setup lsp-status
lsp_status.register_progress()
lsp_status.config({
  indicator_errors = "×",
  indicator_warnings = "!",
  indicator_info = "i",
  indicator_hint = "›",
  -- the default is a wide codepoint which breaks absolute and relative
  -- line counts if placed before airline's Z section
  status_symbol = "",
})


local on_attach = function(client)
  completion.on_attach(client)
  lsp_status.on_attach(client)
end

local servers = {
  rust_analyzer = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
  gopls = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
    }
  },
}
for ls, settings in pairs(servers) do
  nvim_lsp[ls].setup {
    on_attach = on_attach,
    settings = settings,
    capabilities = vim.tbl_extend("keep", configs[ls].capabilities or {}, lsp_status.capabilities),
  }
end

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
    update_in_insert = false,
  }
)

-- This is taken from https://www.reddit.com/r/neovim/comments/iil3jt/nvimlsp_how_to_display_all_diagnostics_for_entire/
-- and *always* shows all the diagnostics for the current workspace.
local method = "textDocument/publishDiagnostics"
local default_callback = vim.lsp.callbacks[method]

vim.lsp.callbacks[method] = function(err, method, result, client_id)
  default_callback(err, method, result, client_id)

  if result and result.diagnostics then
    local item_list = {}
    for _, v in ipairs(result.diagnostics) do
      local fname = vim.uri_to_fname(result.uri)
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

    vim.fn.setqflist({}, ' ', { title = 'LSP Diagnostics'; items = item_list; })
  end
end


function all_diagnostics()
  local result = {}

  if vim.lsp.buf_get_clients() == 0 then
    return result
  end

  local levels = {
    errors = 'Error',
    warnings = 'Warning',
    info = 'Information',
    hints = 'Hint'
  }

  for k, level in pairs(levels) do
    result[k] = 0
  end

  for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      for k, level in pairs(levels) do
        result[k] = result[k] + vim.lsp.diagnostic.get_count(bufnr, level)
      end
    end
  end

  return result
end
