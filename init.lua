-- ============================================================================
-- Thorsten Ball's Neovim Configuration (Lua-only)
-- ============================================================================

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- ============================================================================
-- Basic Settings
-- ============================================================================

-- Leader keys - must be set before lazy.nvim
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Disable compatibility with vi
vim.opt.compatible = false

-- Syntax and filetype
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- Make syntax highlighting faster
vim.cmd("syntax sync minlines=256")

-- Shut up
vim.opt.errorbells = false
vim.opt.visualbell = true

-- Basic settings
vim.opt.clipboard:append("unnamedplus")
vim.opt.showmode = true
vim.opt.showcmd = true
vim.opt.history = 500
vim.opt.hidden = true
vim.opt.wildmenu = true
vim.opt.scrolloff = 3
vim.opt.number = true
vim.opt.colorcolumn = "80"
vim.opt.wrap = false
vim.opt.showmatch = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.joinspaces = false
vim.opt.exrc = true

-- Timeouts
vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 10

-- Performance
vim.opt.ttyfast = true

-- Backup and undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/tmp/undo//")
vim.opt.backupdir = vim.fn.expand("~/.vim/tmp/backup//")
vim.opt.backup = true
vim.opt.swapfile = false

-- Searching
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Indenting
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

-- List characters
vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", eol = "¬", extends = "❯", precedes = "❮" }
vim.opt.ruler = true
vim.opt.laststatus = 2

-- Tags
vim.opt.tags = "./tags;"

-- Wildignore
vim.opt.wildignore:append({ "*/.git/*", "*/.hg/*", "*/.svn/*", "*/vendor/bundle/*", "*/node_modules/*" })

-- Grep
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep"
end

-- Neovim specific
vim.opt.inccommand = "nosplit"
vim.opt.signcolumn = "yes"

-- Ghostty config
if vim.env.GHOSTTY_RESOURCES_DIR then
  local ghostty_vim = vim.env.GHOSTTY_RESOURCES_DIR .. "/../vim/vimfiles"
  if vim.fn.isdirectory(ghostty_vim) == 1 then
    vim.opt.runtimepath:prepend(ghostty_vim)
  end
end

-- ============================================================================
-- Plugin Setup
-- ============================================================================

require("lazy").setup({
  -- Navigation and search
  { "christoomey/vim-tmux-navigator" },

  -- Text manipulation
  { "AndrewRadev/splitjoin.vim" },
  { "bronson/vim-visual-star-search" },
  { "tpope/vim-surround" },
  { "tpope/vim-abolish" },
  { "tpope/vim-rsi" },
  { "tpope/vim-unimpaired" },
  { "tpope/vim-commentary" },

  -- Git integration
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },

  -- File operations
  { "tpope/vim-eunuch" },

  -- Testing
  { "janko-m/vim-test" },
  { "kassio/neoterm" },

  -- Go
  { "benmills/vim-golang-alternate" },

  -- Zig
  { "ziglang/zig.vim" },

  -- Sourcegraph
  { "camdencheek/sgbrowse" },

  -- Colorscheme
  { "gruvbox-community/gruvbox", commit = "143a3b8" },

  -- File browser
  { "stevearc/oil.nvim" },

  -- Terminal editing
  { "chomosuke/term-edit.nvim", tag = "v1.*" },

  -- LSP
  { "neovim/nvim-lspconfig" },
  { "rafcamlet/nvim-luapad" },
  { "simrat39/rust-tools.nvim" },
  { "simrat39/inlay-hints.nvim" },

  -- Telescope
  { "nvim-lua/popup.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "tami5/sqlite.lua" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-fzy-native.nvim" },
  { "nvim-telescope/telescope-file-browser.nvim" },
  { "nvim-telescope/telescope.nvim" },

  -- Completion & Snippets
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "rafamadriz/friendly-snippets" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/nvim-cmp" },

  -- UI enhancements
  { "onsails/lspkind-nvim" },
  { "ray-x/lsp_signature.nvim" },
  { "kyazdani42/nvim-web-devicons" },
  { "folke/lsp-trouble.nvim" },
  { "j-hui/fidget.nvim", tag = "legacy" },

  -- Treesitter
  { "nvim-treesitter/playground" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "Wansmer/treesj" },

  -- Formatting and linting
  { "jose-elias-alvarez/null-ls.nvim" },

  -- Mason for LSP installation
  { "williamboman/mason.nvim" },
})

-- ============================================================================
-- Load Neovim Configuration Modules
-- ============================================================================

require("mrnugget.globals")
require("mrnugget.telescope")
require("mrnugget.lsp")
require("mrnugget.markdown")

-- Load plugin configurations
-- These are in after/plugin/ and will be loaded automatically by Neovim

-- ============================================================================
-- Autocommands
-- ============================================================================

-- Resize vim windows when resizing the main window
vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  command = "wincmd =",
})

-- Filetype: Markdown
vim.api.nvim_create_augroup("ft_markdown", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = "ft_markdown",
  pattern = "*.md",
  callback = function()
    vim.opt_local.filetype = "markdown"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = "ft_markdown",
  pattern = "markdown",
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.smartindent = true
    vim.opt_local.list = false
    vim.opt_local.formatoptions:remove("q")
    vim.opt_local.formatlistpat = [[^\s*\d\+\.\s\+\|^\s*[-*+]\s\+]]
  end,
})

-- Filetype: C
vim.api.nvim_create_augroup("ft_c", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = "ft_c",
  pattern = "*.h",
  callback = function()
    vim.opt_local.filetype = "c"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = "ft_c",
  pattern = "c",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.cinoptions = "l1,t0,g0"
  end,
})

-- Filetype: Python
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Filetype: Go
vim.api.nvim_create_augroup("ft_golang", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile", "BufRead" }, {
  group = "ft_golang",
  pattern = "*.go",
  callback = function()
    vim.opt_local.formatoptions:append("roq")
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.list = false
  end,
})
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile", "BufRead" }, {
  group = "ft_golang",
  pattern = "*.tmpl",
  callback = function()
    vim.opt_local.filetype = "html"
  end,
})

-- Filetype: Rust
vim.api.nvim_create_augroup("ft_rust", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile", "BufRead" }, {
  group = "ft_rust",
  pattern = "*.rs",
  command = "compiler cargo",
})
vim.api.nvim_create_autocmd("FileType", {
  group = "ft_rust",
  pattern = "rust",
  callback = function()
    vim.opt_local.list = false
  end,
})

-- Filetype: Racket
vim.api.nvim_create_augroup("ft_racket", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile", "BufRead" }, {
  group = "ft_racket",
  pattern = "*.rkt",
  callback = function()
    vim.opt_local.filetype = "racket"
  end,
})

-- Filetype: GNU Assembler
vim.api.nvim_create_augroup("ft_asm", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "ft_asm",
  pattern = "asm",
  callback = function()
    vim.opt_local.formatoptions:append("ro")
    vim.opt_local.commentstring = "# %s"
  end,
})

-- Filetype: Tucan
vim.api.nvim_create_augroup("ft_tucan", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile", "BufRead" }, {
  group = "ft_tucan",
  pattern = "*.tuc",
  callback = function()
    vim.opt_local.filetype = "tucan"
  end,
})
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile", "BufRead" }, {
  group = "ft_tucan",
  pattern = "*.tucir",
  callback = function()
    vim.opt_local.filetype = "tucanir"
  end,
})

-- Filetype: YAML
vim.api.nvim_create_augroup("ft_yaml", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "ft_yaml",
  pattern = "yaml",
  callback = function()
    vim.opt_local.list = false
    vim.opt_local.number = true
    vim.opt_local.colorcolumn = "0"
  end,
})

-- Filetype: SQL
vim.api.nvim_create_augroup("ft_sql", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "ft_sql",
  pattern = "sql",
  callback = function()
    vim.opt_local.commentstring = "-- %s"
  end,
})

-- Filetype: Quickfix List
vim.api.nvim_create_augroup("ft_quickfix", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "ft_quickfix",
  pattern = "qf",
  callback = function()
    vim.opt_local.wrap = true
    -- Adjust height
    local height = math.max(math.min(vim.fn.line("$"), 10), 3)
    vim.cmd(height .. "wincmd _")
  end,
})

-- ============================================================================
-- Mappings
-- ============================================================================

-- Remap \ to original ,
vim.keymap.set("n", "\\", ",", { noremap = true })
vim.keymap.set("n", "<space>", "<leader>", { noremap = true })

-- Move around splits with <C-[hjkl]>
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })

-- Move visual block selection
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { noremap = true })

-- Move sanely through wrapped lines
vim.keymap.set("n", "k", "gk", { noremap = true })
vim.keymap.set("n", "j", "gj", { noremap = true })

-- Terminal mode mappings
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Visual mode: don't include newline when jumping to end-of-line
vim.keymap.set("v", "$", "$h", { noremap = true })

-- Select the last pasted text
vim.keymap.set("n", "gp", "'`[' . strpart(getregtype(), 0, 1) . '`]'", { noremap = true, expr = true })

-- Toggle paste mode
vim.keymap.set("n", "<leader>p", ":set invpaste<CR>:set paste?<CR>", { noremap = true, silent = true })

-- Make Y behave like C and D
vim.keymap.set("n", "Y", "y$", { noremap = true, silent = true })

-- Toggle hlsearch
vim.keymap.set("n", "<leader>h", ":set invhlsearch<CR>", { noremap = true, silent = true })

-- Toggle case sensitive search
vim.keymap.set("n", "<leader>c", ":set invignorecase<CR>", { noremap = true, silent = true })

-- Open and source vimrc file
vim.keymap.set("n", "<leader>ev", ":e ~/.config/nvim/init.lua<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>sv", ":source ~/.config/nvim/init.lua<CR>", { noremap = true, silent = true })

-- Wipe out ALL the buffers
vim.keymap.set("n", "<leader>bw", ":%bwipeout | Tclose!<CR>", { noremap = true, silent = true })

-- Delete all trailing whitespaces
vim.keymap.set("n", "<leader>tw", ":%s/\\s\\+$//<CR>:let @/=''<CR>``", { noremap = true, silent = true })

-- Make the just typed word uppercase
vim.keymap.set("i", "<C-f>", "<esc>gUiwgi", { noremap = true })

-- Yank the whole file
vim.keymap.set("n", "<leader>yf", "ggyG", { noremap = true })

-- Highlight the current word under the cursor
vim.keymap.set("n", "<leader>sw", ":set hlsearch<CR>mm*N`m", { noremap = true })

-- Grep the current word under the cursor
vim.keymap.set("n", "<leader>gr", ":gr! <C-r><C-w><CR>", { noremap = true })

-- Find duplicate words
vim.keymap.set("n", "<leader>du", [[/\(\<\w\+\>\)\_s*\<\1\><CR>]], { noremap = true, silent = true })

-- Repeat last command in tmux window below
vim.keymap.set("n", "<leader>rep", ":!tmux send-keys -t 2 C-p C-j<CR><CR>", { noremap = true })

-- Pipes the selected region to jq
vim.keymap.set("v", "<leader>jq", ":!cat|jq .<CR>", { noremap = true, silent = true })

-- Pandoc conversions
vim.keymap.set(
  "v",
  "<leader>pan",
  ':w !cat|pandoc -s -f markdown --metadata title="foo" -o ~/tmp/pandoc_out.html && open ~/tmp/pandoc_out.html<CR>',
  { noremap = true, silent = true }
)
vim.keymap.set(
  "v",
  "<leader>word",
  ':w !cat|pandoc -s -f markdown --toc --metadata title="foo" -o ~/tmp/pandoc_out.docx && open ~/tmp/pandoc_out.docx<CR>',
  { noremap = true, silent = true }
)

-- Line wrapping for markdown
vim.keymap.set(
  "v",
  "<leader>lw",
  [[:!cat |awk 'BEGIN { RS="\n\n"; ORS="\n\n" } { gsub("\n", " "); print $0 }'<CR>]],
  { noremap = true, silent = true }
)

-- Wrap in backticks
vim.keymap.set("v", "`", "S`", { noremap = true, silent = true })

-- Center cursor
vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })
vim.keymap.set("n", "J", "mzJ`z", { noremap = true })

-- Switch or create new tmux session
vim.keymap.set("n", "<C-f>", ":silent !tmux neww tmux-sessionizer<CR>", { noremap = true, silent = true })

-- Quickfix navigation
vim.keymap.set("n", "<leader>co", ":silent copen<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cl", ":silent cclose<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-n>", ":silent cnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-p>", ":silent cprevious<CR>", { noremap = true, silent = true })

-- Open URL under cursor
local function open_url_under_cursor()
  local url = vim.fn.expand("<cWORD>")
  url = vim.fn.matchstr(url, [[a-z]*:\/\/[^ >,;()]*]])
  url = vim.fn.substitute(url, [[?]], [[\\?]], "")
  if url ~= "" then
    local open_cmd = vim.fn.has("mac") == 1 and "open" or "xdg-open"
    vim.fn.system(string.format("%s '%s'", open_cmd, url))
    vim.cmd("redraw!")
  end
end

vim.keymap.set("n", "gx", open_url_under_cursor, { noremap = true })

-- ============================================================================
-- Plugin Configuration
-- ============================================================================

-- Enable cfilter plugin
vim.cmd("packadd cfilter")

-- Enable matchit.vim
vim.cmd("runtime macros/matchit.vim")

-- netrw
vim.g.netrw_liststyle = 3
vim.g.netrw_keepj = "keepj"

-- netrw mapping for tmux-navigator
vim.api.nvim_create_augroup("netrw_mapping", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "netrw_mapping",
  pattern = "netrw",
  callback = function()
    vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { buffer = true, silent = true })
  end,
})

-- fugitive.vim
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { noremap = true })
vim.keymap.set("v", "<leader>go", ":GBrowse<CR>", { noremap = true })
vim.keymap.set("n", "<leader>gs", ":Git<CR>", { noremap = true })
vim.keymap.set("n", "<leader>gm", ":Gsplit main:%<CR>", { noremap = true })

-- neoterm
vim.g.neoterm_default_mod = "vert botright"
vim.g.neoterm_autoscroll = 1
vim.g.neoterm_keep_term_open = 1

vim.keymap.set("n", "<leader>tg", ":Ttoggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tc", ":Tclear<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>sl", ":TREPLSendLine<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>sl", ":TREPLSendSelection<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>sf", ":TREPLSendFile<CR>", { noremap = true, silent = true })

-- vim-test
vim.g["test#strategy"] = "neoterm"
vim.g["test#javascript#runner"] = "jest"
vim.g["test#rust#runner"] = "cargotest"
vim.g["test#rust#cargotest#options"] = {
  nearest = "",
  file = "-q",
  suite = "-q",
}

vim.keymap.set("n", "<leader>rt", ":TestNearest<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>rf", ":TestFile<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ra", ":TestSuite<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>rl", ":TestLast<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>rv", ":TestVisit<CR>", { noremap = true, silent = true })

-- Cody
vim.keymap.set("n", "<leader>cg", ":CodyToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_create_user_command("CA", "CodyAsk", {})

-- ============================================================================
-- Statusline
-- ============================================================================

vim.opt.statusline = "%< %{mode()} | %f%m"
  .. " | %{v:lua.workspace_diagnostics_status()}"
  .. "%{&paste?' | PASTE ':' '}"
  .. "%=  %{&fileformat} | %{&fileencoding} | %{&filetype} | %l/%L(%c) "

-- ============================================================================
-- Colors
-- ============================================================================

vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.g.gruvbox_contrast_dark = "hard"
vim.cmd("colorscheme gruvbox")

-- Diagnostics
vim.cmd("highlight DiagnosticUnderlineError cterm=undercurl gui=undercurl")
vim.cmd("highlight DiagnosticUnderlineWarn cterm=undercurl gui=undercurl")
vim.cmd("highlight DiagnosticUnderlineInfo cterm=undercurl gui=undercurl")
vim.cmd("highlight DiagnosticUnderlineHint cterm=undercurl gui=undercurl")

-- LSP highlights
vim.cmd("hi! link LspReferenceRead DiffChange")
vim.cmd("hi! link LspReferenceText DiffChange")
vim.cmd("hi! link LspReferenceWrite DiffChange")
vim.cmd("hi! link LspSignatureActiveParameter GruvboxOrange")

-- Telescope
vim.cmd("highlight TelescopeSelection gui=bold")

-- ============================================================================
-- Security
-- ============================================================================

-- Only allow secure commands from this point on
vim.opt.secure = true
