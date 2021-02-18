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
  -- TODO: This is disabled because it caused some redraw glitches
  -- lsp_status.on_attach(client)

  -- Let's try this:
  client.config.flags.allow_incremental_sync = true
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
        unusedparams = false,
      },
    }
  },
}
for ls, settings in pairs(servers) do
  nvim_lsp[ls].setup {
    on_attach = on_attach,
    settings = settings,
    -- TODO: This is disabled because it caused some redraw glitches
    -- capabilities = vim.tbl_extend("keep", configs[ls].capabilities or {}, lsp_status.capabilities),
  }
end


-- See https://github.com/neovim/nvim-lspconfig/issues/465
-- Can hopefully be removed when these are fixed:
-- - https://github.com/neovim/neovim/pull/13692
-- - https://github.com/neovim/neovim/pull/13703
function format_rust()
  local lineno = vim.api.nvim_win_get_cursor(0)
  vim.lsp.buf.formatting_sync(nil, 1000)
  vim.api.nvim_win_set_cursor(0, lineno)
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

-- Enable diagnostics with the workspace diagnostics handler
-- See the "gld" ("load diagnostics')binding:
--    nnoremap <silent> gld <cmd>lua require('lsp_extensions.workspace.diagnostic').set_qf_list()<CR>
-- to load all diagnostics in the workspace into the quickfix list
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  require('lsp_extensions.workspace.diagnostic').handler, {
    virtual_text = true,
    signs = true,
    update_in_insert = false,
  }
)


function _G.workspace_diagnostics()
  if #vim.lsp.buf_get_clients() == 0 then
    return ''
  end
  local ws_diag = require('lsp_extensions.workspace.diagnostic')

  local errors = ws_diag.get_count(0, 'Error')
  local warnings = ws_diag.get_count(0, 'Warning')
  local hint = ws_diag.get_count(0, 'Hint')

  return string.format( 'E: %s, W: %s, H: %s', errors, warnings, hint)
end
