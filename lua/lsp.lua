-- Setup local vars for easier access
local lspconfig = require('lspconfig')
local completion = require('completion')

local on_attach = function(client)
  completion.on_attach(client)
  -- Let's try this:
  client.config.flags.allow_incremental_sync = true

  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  if filetype == 'rust' then
    vim.cmd [[autocmd BufWritePre <buffer> :lua require('lsp.helpers').format_rust()]]
  end
  if filetype == 'go' then
    vim.cmd [[autocmd BufWritePre <buffer> :lua require('lsp.helpers').goimports(1000)]]

    -- gopls requires a require to list workspace arguments.
    vim.cmd [[autocmd BufEnter,BufNewFile,BufRead <buffer> map <buffer> <leader>fs <cmd>lua require('telescope.builtin').lsp_workspace_symbols { query = vim.fn.input("Query: ") }<cr>]]
  end
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
  lspconfig[ls].setup {
    on_attach = on_attach,
    settings = settings,
  }
end

require('nlua.lsp.nvim').setup(lspconfig, {
  on_attach = on_attach
})

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


function _G.workspace_diagnostics_status()
  if #vim.lsp.buf_get_clients() == 0 then
    return ''
  end

  local ws_diag = require('lsp_extensions.workspace.diagnostic')

  local status = {}
  local errors = ws_diag.get_count(0, 'Error')
  if errors > 0 then
    table.insert(status, "E: " .. errors)
  end

  local warnings = ws_diag.get_count(0, 'Warning')
  if warnings > 0 then
    table.insert(status, "W: " .. warnings)
  end

  local hints = ws_diag.get_count(0, 'Hint')
  if hints > 0 then
    table.insert(status, "H: " .. hints)
  end

  return table.concat(status, " | ")
end
