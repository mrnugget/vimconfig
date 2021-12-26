local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  -- keybindings
  buf_set_keymap('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K',     '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gD',    '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '1gD',   '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gR',    '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'g0',    '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap('n', 'gW',    '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  buf_set_keymap('n', 'gd',    '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'ga',    '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr',    '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gld',  [[<cmd>lua require('lsp_extensions.workspace.diagnostic').set_qf_list()<CR>]], opts)
  buf_set_keymap('n', 'g[', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', 'g]', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  if filetype == 'rust' then
    vim.cmd [[autocmd BufWritePre <buffer> :lua require('lsp.helpers').format_rust()]]
    -- Disable this, since we have rust-tools
    -- vim.cmd [[autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost <buffer> :lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Whitespace", enabled = {"ChainingHint", "TypeHint", "ParameterHint"} } ]]

    vim.cmd [[autocmd BufEnter,BufNewFile,BufRead <buffer> nmap <buffer> gle <cmd>lua vim.lsp.codelens.refresh()<CR>]]
    vim.cmd [[autocmd BufEnter,BufNewFile,BufRead <buffer> nmap <buffer> glr <cmd>lua vim.lsp.codelens.run()<CR>]]
  end
  if filetype == 'go' then
    vim.cmd [[autocmd BufWritePre <buffer> :lua require('lsp.helpers').goimports(2000)]]

    -- gopls requires a require to list workspace arguments.
    vim.cmd [[autocmd BufEnter,BufNewFile,BufRead <buffer> map <buffer> <leader>fs <cmd>lua require('telescope.builtin').lsp_workspace_symbols { query = vim.fn.input("Query: ") }<cr>]]
  end

  if filetype == 'typescriptreact' or filetype == 'typescript' then
    -- TypeScript/ESLint/Prettier
    -- Requirements:
    --   npm install -g typescript-language-server prettier eslint_d
    --   asdf reshim nodejs

    -- disable tsserver formatting because we use prettier/eslint for that
    client.resolved_capabilities.document_formatting = false

    buf_set_keymap("n", "gs", ":TSLspOrganize<CR>", opts)
    buf_set_keymap("n", "gi", ":TSLspImportAll<CR>", opts)

    vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()")

    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup {
        eslint_enable_code_actions = true,
        eslint_enable_disable_comments = true,
        eslint_bin = "eslint_d",
        eslint_enable_diagnostics = true,
        eslint_show_rule_id = true,

        enable_formatting = true,
        formatter = "prettier",
    }

    ts_utils.setup_client(client)
  end

  vim.cmd [[autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })]]
  -- 300ms of no cursor movement to trigger CursorHold
  vim.cmd [[set updatetime=300]]
  -- have a fixed column for the diagnostics to appear in
  -- this removes the jitter when warnings/errors flow in
  vim.cmd [[set signcolumn=yes]]
end

vim.diagnostic.config({ float = { source = 'always', } })

local servers = {
  -- NOTE: See below. rust-analyzer is initialized by rust-tools
  -- rust_analyzer = {
  --   ["rust-analyzer"] = {
  --     checkOnSave = {
  --       command = "clippy",
  --     },
  --     completion = {
  --       autoimport = {
  --         enable = true
  --       }
  --     }
  --   },
  -- },
  gopls = {
    gopls = {
      completeUnimported = true,
      buildFlags = {"-tags=debug"},
      ["local"] = "github.com/sourcegraph/sourcegraph",
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      experimentalPostfixCompletions = true,
    }
  },
}

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

for ls, settings in pairs(servers) do
  lspconfig[ls].setup {
    on_attach = on_attach,
    settings = settings,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 200,
    },
  }
end

local utils = require("rust-tools.utils.utils")
local  rust_execute_command = function(command, args, cwd)
  vim.cmd("T " .. utils.make_command_from_args(command, args))
end

local tools = {
    autoSetHints = true,
    runnables = {use_telescope = true},
    inlay_hints = {
      show_parameter_hints = true,
      highlight = 'Whitespace',
    },
    hover_actions = {auto_focus = true},
    executor = {
      execute_command = rust_execute_command
    },
}

require('rust-tools').setup({
  tools = tools,
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 200,
    },
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
        completion = {
          autoimport = {
            enable = true
          }
        }
      },
    },
  }
})

require("null-ls").setup({
  sources = {
    require("null-ls").builtins.diagnostics.golangci_lint,
  }
})

local util = require "lspconfig/util"
lspconfig.tsserver.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 200,
  },
  root_dir = util.root_pattern(".git"),
}

-- The sumneko lua-language-server setup is based on this:
-- https://jdhao.github.io/2021/08/12/nvim_sumneko_lua_conf/
local sumneko_binary_path = "/home/mrnugget/bin/lua-language-server/bin/lua-language-server"
local sumneko_root_path = "/home/mrnugget/bin/lua-language-server"

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
    on_attach = on_attach,
    cmd = { sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua" };
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
}

-- Enable diagnostics with the workspace diagnostics handler
-- See the "gld" ("load diagnostics')binding:
--    nnoremap <silent> gld <cmd>lua require('lsp_extensions.workspace.diagnostic').set_qf_list()<CR>
-- to load all diagnostics in the workspace into the quickfix list
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  require('lsp_extensions.workspace.diagnostic').handler, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
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

-- lsp-trouble.nvim
require("trouble").setup({
  auto_preview = false,
  auto_close = true,
})
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle workspace_diagnostics<cr>", {silent = true, noremap = true})
