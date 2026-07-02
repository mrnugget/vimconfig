vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.cmd.syntax('enable')
vim.cmd('filetype plugin indent on')

vim.filetype.add({
  extension = {
    svx = 'markdown',
  },
  pattern = {
    ['.*%.md%.njk'] = 'markdown',
  },
})

local state_dir = vim.fn.stdpath('state')
local backup_dir = state_dir .. '/backup'
local undo_dir = state_dir .. '/undo'

vim.fn.mkdir(backup_dir, 'p')
vim.fn.mkdir(undo_dir, 'p')

vim.opt.clipboard:append('unnamedplus')
vim.o.showmode = true
vim.o.showcmd = true
vim.o.history = 500
vim.o.wildmenu = true
vim.o.scrolloff = 3
vim.o.number = true
vim.o.colorcolumn = '80'
vim.o.wrap = false
vim.o.showmatch = true
vim.o.backspace = 'indent,eol,start'
vim.o.joinspaces = false
vim.o.timeout = false
vim.o.ttimeout = true
vim.o.ttimeoutlen = 10
vim.o.termguicolors = true
vim.o.inccommand = 'nosplit'
vim.o.signcolumn = 'yes'

vim.o.undofile = true
vim.o.undodir = undo_dir .. '//'
vim.o.backup = true
vim.o.backupdir = backup_dir .. '//'
vim.o.swapfile = false

vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.shiftround = true
vim.o.expandtab = true

vim.o.list = true
vim.o.listchars = 'tab:▸ ,eol:¬,extends:❯,precedes:❮'
vim.o.ruler = true
vim.o.laststatus = 2
vim.o.tags = './tags;'
vim.opt.wildignore:append({ '*/.git/*', '*/.hg/*', '*/.svn/*', '*/vendor/bundle/*', '*/node_modules/*' })

if vim.fn.executable('rg') == 1 then
  vim.o.grepprg = 'rg --vimgrep'
end

vim.api.nvim_create_autocmd('VimResized', {
  command = 'wincmd =',
})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind

    if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd('fff.nvim')
      end

      require('fff.download').download_or_build_binary()
    elseif name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end

      vim.cmd.TSUpdate()
    end
  end,
})

vim.pack.add({
  'https://github.com/ellisonleao/gruvbox.nvim',
  { src = 'https://github.com/dmtrKovalenko/fff.nvim', name = 'fff.nvim' },
  'https://github.com/tpope/vim-surround',
  'https://github.com/bronson/vim-visual-star-search',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/Wansmer/treesj',
  'https://github.com/neovim/nvim-lspconfig',
}, { confirm = false })

require('gruvbox').setup({
  contrast = 'hard',
})

vim.o.background = 'dark'
vim.cmd.colorscheme('gruvbox')

local function set_fff_highlights()
  vim.api.nvim_set_hl(0, 'FFFNormal', { fg = '#ebdbb2', bg = '#1d2021' })
  vim.api.nvim_set_hl(0, 'FFFBorder', { fg = '#665c54', bg = '#1d2021' })
  vim.api.nvim_set_hl(0, 'FFFCursor', { bg = '#3c3836' })
end

set_fff_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = set_fff_highlights,
})

require('fff').setup({
  hl = {
    normal = 'FFFNormal',
    border = 'FFFBorder',
    cursor = 'FFFCursor',
    winhl = 'Normal:FFFNormal,FloatBorder:FFFBorder,FloatTitle:Title',
  },
})

require('oil').setup()

local treesitter_languages = {
  'bash',
  'c',
  'css',
  'go',
  'html',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'rust',
  'svelte',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

require('nvim-treesitter').setup()

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local installed = {}
    for _, language in ipairs(require('nvim-treesitter').get_installed()) do
      installed[language] = true
    end

    local missing = {}
    for _, language in ipairs(treesitter_languages) do
      if not installed[language] then
        table.insert(missing, language)
      end
    end

    if #missing > 0 then
      require('nvim-treesitter').install(missing)
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'c',
    'css',
    'go',
    'html',
    'javascript',
    'json',
    'jsonc',
    'lua',
    'markdown',
    'python',
    'rust',
    'sh',
    'svelte',
    'toml',
    'typescript',
    'typescriptreact',
    'vim',
    'vimdoc',
    'yaml',
  },
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = [[v:lua.require'nvim-treesitter'.indentexpr()]]
  end,
})

require('treesj').setup({
  use_default_keymaps = false,
})

vim.diagnostic.config({
  float = { source = 'always' },
  severity_sort = true,
})

local format_on_save_enabled = true
local formatting_augroup = vim.api.nvim_create_augroup('FormatOnSave', {})

local function project_root(bufnr)
  return vim.fs.root(bufnr, {
    'pnpm-lock.yaml',
    'package-lock.json',
    'yarn.lock',
    'bun.lock',
    'bun.lockb',
    'package.json',
    '.git',
  }) or vim.fn.getcwd()
end

local function project_executable(bufnr, name)
  local local_executable = vim.fs.joinpath(project_root(bufnr), 'node_modules/.bin', name)
  if vim.fn.executable(local_executable) == 1 then
    return local_executable
  end

  if vim.fn.executable(name) == 1 then
    return name
  end
end

local function start_project_executable(name, args)
  return function(dispatchers, config)
    local cmd = name
    if config and config.root_dir then
      local local_executable = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', name)
      if vim.fn.executable(local_executable) == 1 then
        cmd = local_executable
      end
    end

    local rpc_cmd = { cmd }
    vim.list_extend(rpc_cmd, args)
    return vim.lsp.rpc.start(rpc_cmd, dispatchers)
  end
end

local function run_formatter(bufnr, command, args)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == '' then
    return false
  end

  local executable = project_executable(bufnr, command)
  if not executable then
    return false
  end

  local cmd = { executable }
  vim.list_extend(cmd, args(path))

  local input = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n')
  if vim.bo[bufnr].endofline then
    input = input .. '\n'
  end

  local result = vim.system(cmd, {
    cwd = project_root(bufnr),
    stdin = input,
    text = true,
  }):wait(10000)

  if result.code ~= 0 or result.stdout == input then
    if result.code ~= 0 then
      vim.notify(result.stderr, vim.log.levels.WARN)
    end
    return result.code == 0
  end

  local lines = vim.split(result.stdout, '\n', { plain = true })
  if result.stdout:sub(-1) == '\n' then
    table.remove(lines)
  end

  local view = vim.fn.winsaveview()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.fn.winrestview(view)
  return true
end

local function format_with_lsp(bufnr, filter)
  local has_formatter = false
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client.server_capabilities.documentFormattingProvider and filter(client) then
      has_formatter = true
      break
    end
  end

  if not has_formatter then
    return false
  end

  vim.lsp.buf.format({
    bufnr = bufnr,
    timeout_ms = 10000,
    filter = filter,
  })
  return true
end

local biome_filetypes = {
  javascript = true,
  javascriptreact = true,
  json = true,
  jsonc = true,
  typescript = true,
  typescriptreact = true,
}

local prettier_filetypes = {
  css = true,
  svelte = true,
}

local function format_buffer(bufnr)
  if not format_on_save_enabled then
    return
  end

  local filetype = vim.bo[bufnr].filetype
  if biome_filetypes[filetype] then
    if run_formatter(bufnr, 'biome', function(path)
      return { 'check', '--write', '--stdin-file-path', path }
    end) then
      return
    end

    format_with_lsp(bufnr, function(client)
      return client.name == 'biome'
    end)
    return
  end

  if prettier_filetypes[filetype] then
    if run_formatter(bufnr, 'prettier', function(path)
      return { '--stdin-filepath', path }
    end) then
      return
    end
  end

  format_with_lsp(bufnr, function(client)
    return client.name ~= 'ts_ls' and client.name ~= 'svelte'
  end)
end

vim.api.nvim_create_autocmd('BufWritePre', {
  group = formatting_augroup,
  callback = function(ev)
    format_buffer(ev.buf)
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    map('<C-]>', vim.lsp.buf.definition, 'Go to definition')
    map('K', vim.lsp.buf.hover, 'Hover')
    map('gD', vim.lsp.buf.implementation, 'Go to implementation')
    map('1gD', vim.lsp.buf.type_definition, 'Go to type definition')
    map('gR', vim.lsp.buf.references, 'References')
    map('g0', vim.lsp.buf.document_symbol, 'Document symbols')
    map('gW', vim.lsp.buf.workspace_symbol, 'Workspace symbols')
    map('gd', vim.lsp.buf.declaration, 'Go to declaration')
    map('ga', vim.lsp.buf.code_action, 'Code action')
    map('gr', vim.lsp.buf.rename, 'Rename')
    map('g[', function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, 'Previous diagnostic')
    map('g]', function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, 'Next diagnostic')
    map('<leader>ft', function()
      format_on_save_enabled = not format_on_save_enabled
      print(string.format('format on save: %s', format_on_save_enabled))
    end, 'Toggle format on save')
  end,
})

vim.lsp.config('svelte', {
  cmd = start_project_executable('svelteserver', { '--stdio' }),
})

vim.lsp.config('ts_ls', {
  settings = {
    javascript = {
      preferences = {
        quoteStyle = 'single',
      },
      updateImportsOnFileMove = 'always',
    },
    typescript = {
      preferences = {
        quoteStyle = 'single',
      },
      tsserver = {
        maxTsServerMemory = 24000,
      },
      updateImportsOnFileMove = 'always',
    },
  },
})

local lsp_executables = {
  biome = 'biome',
  svelte = 'svelteserver',
  ts_ls = 'typescript-language-server',
}

local function enable_lsp_if_executable(name)
  local config = vim.lsp.config[name]
  if not config or not config.cmd then
    return
  end

  local command = lsp_executables[name] or (type(config.cmd) == 'table' and config.cmd[1] or config.cmd)
  if type(command) ~= 'string' then
    return
  end

  if command and project_executable(0, command) then
    vim.lsp.enable(name)
  end
end

for _, server in ipairs({ 'biome', 'clangd', 'pyright', 'marksman', 'svelte', 'zls', 'ts_ls' }) do
  enable_lsp_if_executable(server)
end

vim.schedule(function()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype ~= '' then
      vim.api.nvim_exec_autocmds('FileType', { buffer = bufnr, modeline = false })
    end
  end
end)

vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result centered' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result centered' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines and keep cursor position' })

vim.keymap.set('n', '<leader>h', function()
  vim.o.hlsearch = not vim.o.hlsearch
end, { desc = 'Toggle search highlight' })

vim.keymap.set('n', '<leader>co', vim.cmd.copen, { desc = 'Open quickfix' })
vim.keymap.set('n', '<leader>cl', vim.cmd.cclose, { desc = 'Close quickfix' })

vim.keymap.set('n', '<leader>tw', function()
  local view = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.fn.winrestview(view)
end, { desc = 'Delete trailing whitespace' })

vim.keymap.set('n', '-', function()
  require('oil').open()
end, { desc = 'Open parent directory' })

vim.keymap.set('n', 'gS', function()
  require('treesj').split()
end, { desc = 'Split syntax node' })

vim.keymap.set('n', 'gJ', function()
  require('treesj').join()
end, { desc = 'Join syntax node' })

vim.keymap.set('n', '<leader><leader>', function()
  require('fff').find_files()
end, { desc = 'FFFind files' })

vim.keymap.set('n', '<leader>fg', function()
  require('fff').live_grep()
end, { desc = 'LiFFFe grep' })

vim.keymap.set('n', '<leader>fz', function()
  require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } })
end, { desc = 'Live fffuzy grep' })

vim.keymap.set({ 'n', 'x' }, '<leader>fw', function()
  require('fff').live_grep_under_cursor()
end, { desc = 'Search current word / selection' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.smartindent = true
    vim.opt_local.list = false
    vim.opt_local.formatoptions:remove('q')
    vim.opt_local.formatlistpat = [[^\s*\d\+\.\s\+\|^\s*[-*+]\s\+]]
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'python' },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.opt_local.formatoptions:append('roq')
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.list = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rust', 'yaml' },
  callback = function()
    vim.opt_local.list = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'yaml',
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.colorcolumn = '0'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sql',
  callback = function()
    vim.opt_local.commentstring = '-- %s'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.opt_local.wrap = true
    vim.cmd(math.max(math.min(vim.fn.line('$'), 10), 3) .. 'wincmd _')
  end,
})
