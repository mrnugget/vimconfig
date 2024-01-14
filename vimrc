call plug#begin('~/.vim/plugged')

Plug 'AndrewRadev/splitjoin.vim'
Plug 'bronson/vim-visual-star-search'
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vim-golang-alternate'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'

Plug 'janko-m/vim-test'
Plug 'kassio/neoterm'

Plug 'camdencheek/sgbrowse'

Plug 'jonathanfilip/vim-lucius'
Plug 'gruvbox-community/gruvbox', {'commit': 'dd4bf4cbc764d280886f1bc1881b23ab7c25b556'}

Plug 'ziglang/zig.vim'

if has('nvim')

Plug 'stevearc/oil.nvim'

Plug 'chomosuke/term-edit.nvim', {'tag': 'v1.*'}

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
Plug 'rafcamlet/nvim-luapad'
Plug 'simrat39/rust-tools.nvim'
Plug 'simrat39/inlay-hints.nvim'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'tami5/sqlite.lua'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Completion & Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'

" Fancy icons for completion
Plug 'onsails/lspkind-nvim'

" LSP signature
Plug 'ray-x/lsp_signature.nvim'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/lsp-trouble.nvim'

Plug 'nvim-treesitter/playground'
Plug 'nvim-treesitter/nvim-treesitter', {'tag': '9567185621e532a9e29a671c66a11011334b80ea', 'do': ':TSUpdate'}
Plug 'Wansmer/treesj'

Plug 'jose-elias-alvarez/null-ls.nvim'

Plug 'williamboman/mason.nvim'

Plug 'j-hui/fidget.nvim', { 'tag': 'legacy' }

Plug 'sourcegraph/sg.nvim', { 'tag': 'master', 'do': 'nvim -l build/init.lua' }

end

" Ghostty config
if isdirectory($GHOSTTY_RESOURCES_DIR . "/../vim/vimfiles")
  set runtimepath^=$GHOSTTY_RESOURCES_DIR/../vim/vimfiles
endif

call plug#end()

" Syntax and filetype specific indentation and plugins on
syntax enable
filetype on
filetype plugin on
filetype indent on

" Make syntax highlighting faster
syntax sync minlines=256

" Shut up.
set noerrorbells
set visualbell

" Basic stuff
" set clipboard=unnamed
set clipboard+=unnamedplus

set showmode
set showcmd
set history=500
set nocompatible
set hidden
set wildmenu
set scrolloff=5
set number
" set cursorline
set colorcolumn=80
set nowrap
set showmatch
set backspace=2
" Make J not insert whitespace
set nojoinspaces
" Allow project-specific vimrc files
set exrc

" Time out on key codes, not mappings.
set notimeout
set ttimeout
set ttimeoutlen=10

" Some tuning for macvim
set ttyfast
if !has('nvim')
  set lazyredraw
end

" Backup
set undofile
set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//
set backup
set noswapfile

" Resize vim windows when resizing the main window
au VimResized * :wincmd =

" Searching
set incsearch
set hlsearch
set ignorecase
set smartcase " Do not ignore case, if uppercase is in search term

" Indenting
set tabstop=2
set shiftwidth=2
set softtabstop=2
set shiftround
set expandtab

set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set ruler
set laststatus=2

" ctags tags file
set tags=./tags;

set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/vendor/bundle/*,*/node_modules/*

" Use ripgrep with fzz as :grep
if executable('rg')
  set grepprg=rg\ --vimgrep
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <leader> is ,
let mapleader = ","
noremap \ ,
map <space> <leader>
let maplocalleader = ","

" Move around splits with <C-[hjkl]> in normal mode
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Move visual block selection with <C-[jk]> in visual mode
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Move sanely through wrapped lines
nnoremap k gk
nnoremap j gj

" Use Ctrl-[ as Esc in neovim terminal mode
tnoremap <C-[> <C-\><C-n>
tnoremap <Esc> <C-\><C-n>

" In visual mode don't include the newline-character when jumping to
" end-of-line with $
vnoremap $ $h

" Select the last pasted text, line/block/characterwise
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Toggle paste mode
nmap <silent> <leader>p :set invpaste<CR>:set paste?<CR>

" Make Y behave like C and D
nmap <silent> Y y$

" Toggle hlsearch
nmap <silent> <leader>h :set invhlsearch<CR>
" Toggle case sensitive search
nmap <silent> <leader>c :set invignorecase<CR>

" Open and source vimrc file
nmap <silent> <leader>ev :e ~/.vimrc<CR>
nmap <silent> <leader>sv :so ~/.vimrc<CR>
" Wipe out ALL the buffers
nmap <silent> <leader>bw :%bwipeout \| Tclose!<CR>
" Delete all trailing whitespaces
nmap <silent> <leader>tw :%s/\s\+$//<CR>:let @/=''<CR>``
" Make the just typed word uppercase
imap <C-f> <esc>gUiwgi
" Yank the whole file
nmap <leader>yf ggyG
" Highlight the current word under the cursor
nmap <leader>sw :set hlsearch<CR>mm*N`m
" Greps the current word under the cursor
nmap <leader>gr :gr! <C-r><C-w><CR>
" Find duplicate words
nnoremap <silent> <leader>du /\(\<\w\+\>\)\_s*\<\1\><CR>
" Repeat last command in tmux window below (if two-pane setup)
nmap <leader>rep :!tmux send-keys -t 2 C-p C-j <CR><CR>

" Pipes the selected region to `jq` for formatting
vmap <silent> <leader>jq :!cat\|jq . <CR>

" Pipes the selection region to `pandoc` to convert it to HTML, opens the temp
" file.
vmap <silent> <leader>pan :w !cat\|pandoc -s -f markdown --metadata title="foo" -o ~/tmp/pandoc_out.html && open ~/tmp/pandoc_out.html <CR>
vmap <silent> <leader>word :w !cat\|pandoc -s -f markdown --toc --metadata title="foo" -o ~/tmp/pandoc_out.docx && open ~/tmp/pandoc_out.docx <CR>

" Pipes the selected region to `awk` to turn hard line-break paragraphs in
" Markdown to single-line-per-paragraph.
vmap <silent> <leader>lw :!cat \|awk 'BEGIN { RS="\n\n"; ORS="\n\n" } { gsub("\n", " "); print $0 }'<CR>

" Wrap selected text in `backticks` using vim-surround, saving 2 (!)
" keystrokes
vmap <silent> ` S`

" Center cursor
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Switch or create new tmux session
nnoremap <silent> <C-f> :silent !tmux neww tmux-sessionizer<CR>

" Open/close quickfix
nnoremap <silent> <leader>co :silent copen<CR>
nnoremap <silent> <leader>cl :silent cclose<CR>
" Next/previous quickfix result
nnoremap <silent> <C-n> :silent cnext<CR>
nnoremap <silent> <C-p> :silent cprevious<CR>

function! OpenURLUnderCursor()
  let s:uri = expand('<cWORD>')
  let s:uri = matchstr(s:uri, '[a-z]*:\/\/[^ >,;()]*')
  let s:uri = substitute(s:uri, '?', '\\?', '')
  let s:uri = shellescape(s:uri, 1)
  if s:uri != ''
    if has('mac') || has('macunix')
      silent exec "!open '".s:uri."'"
    else
      silent exec "!xdg-open '".s:uri."'"
    endif
    :redraw!
  endif
endfunction

nnoremap gx :call OpenURLUnderCursor()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Neovim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
  " Show incremental search/replace
  set inccommand=nosplit

  " Load the rest of the Neovim config from setup.lua
  lua require('setup')
end

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable the cfilter plugin that ships with Vim/NeoVim
packadd cfilter

" Enable matchit.vim, which ships with Vim but isn't enabled by default
" somehow
runtime macros/matchit.vim

" netrw
let g:netrw_liststyle = 3
let g:netrw_keepj="keepj"

" See https://github.com/christoomey/vim-tmux-navigator/issues/189
" for context on the following
augroup netrw_mapping
  autocmd!
  autocmd filetype netrw silent call NetrwMapping()
augroup END

function! NetrwMapping()
  nnoremap <silent> <buffer> <c-l> :TmuxNavigateRight<CR>
endfunction

" fugitive.vim
nmap <leader>gb :Git blame<CR>
vmap <leader>go :GBrowse<CR>
nmap <leader>gs :Git<CR>
nmap <leader>gm :Gsplit main:%<CR>

" neoterm
let g:neoterm_default_mod = "vert botright"
let g:neoterm_autoscroll = 1
let g:neoterm_keep_term_open = 1
" ,tg to[g]gle the terminal window
nmap     <silent> <leader>tg :Ttoggle<CR>
" ,tc [c]lear the terminal window
nmap     <silent> <leader>tc :Tclear<CR>
" ,sl [s]end [line] to REPL in terminal window
nmap     <silent> <leader>sl :TREPLSendLine<CR>
vnoremap <silent> <leader>sl :TREPLSendSelection<CR>
nmap     <silent> <leader>sf :TREPLSendFile<CR>

" vim-test
let g:test#strategy = "neoterm"
" ,rt runs rspec on current (or previously set ) single spec ('run this')
" ,rf runs rspec on current (or previously set) spec file ('run file')
" ,ra runs all specs ('run all')
" ,rl runs the last spec ('run last')
nmap <silent> <leader>rt :TestNearest<CR>
nmap <silent> <leader>rf :TestFile<CR>
nmap <silent> <leader>ra :TestSuite<CR>
nmap <silent> <leader>rl :TestLast<CR>
nmap <silent> <leader>rv :TestVisit<CR>

let g:test#javascript#runner = 'jest'
let g:test#rust#runner = 'cargotest'
let test#rust#cargotest#options = {
  \ 'nearest': '',
  \ 'file':    '-q',
  \ 'suite':   '-q',
\}


" cody
nmap <silent> <leader>cg :CodyToggle<CR>
command CA CodyAsk

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetypes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Markdown
augroup ft_markdown
  au!
  au BufNewFile,BufRead *.md setlocal filetype=markdown

  au Filetype markdown setlocal textwidth=80
  au Filetype markdown setlocal smartindent " Indent lists correctly
  au FileType markdown setlocal nolist
  " Taken from here: https://github.com/plasticboy/vim-markdown/issues/232
  au FileType markdown
      \ set formatoptions-=q |
      \ set formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*\[-*+]\\s\\+
augroup END

" C
augroup ft_c
  au!
  au BufNewFile,BufRead *.h setlocal filetype=c
  au Filetype c setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
  au Filetype c setlocal cinoptions=l1,t0,g0 " This fixes weird indentation of switch/case
augroup END

" Python
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

" Go
augroup ft_golang
  au!

  au BufEnter,BufNewFile,BufRead *.go setlocal formatoptions+=roq
  au BufEnter,BufNewFile,BufRead *.go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4 nolist
  au BufEnter,BufNewFile,BufRead *.tmpl setlocal filetype=html
augroup END

" Rust
augroup ft_rust
  au!
  au BufEnter,BufNewFile,BufRead *.rs :compiler cargo
  au FileType rust set nolist
augroup END

" Racket
augroup ft_racket
  au!
  au BufEnter,BufNewFile,BufRead *.rkt set filetype=racket
augroup END

" GNU Assembler
augroup ft_asm
  au!
  " Insert comments automatically on return in insert and when using O/o in
  " normal mode
  au FileType asm setlocal formatoptions+=ro
  au FileType asm setlocal commentstring=#\ %s
augroup END

" Tucan
augroup ft_tucan
  au!
  au BufEnter,BufNewFile,BufRead *.tuc set filetype=tucan
  au BufEnter,BufNewFile,BufRead *.tucir set filetype=tucanir
augroup END

" Merlin setup for Ocaml
" if executable('opam')
"   let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
"   execute "set rtp+=" . g:opamshare . "/merlin/vim"
"
"   let g:merlin_split_method = "never"
"   let g:merlin_textobject_grow   = 'm'
"   let g:merlin_textobject_shrink = 'M'
" endif

" OCaml
augroup ft_ocaml
  au!

  au Filetype ocaml nmap <c-]> gd

  au Filetype ocaml nmap <leader>ot :MerlinTypeOf<CR>
  au Filetype ocaml nmap <leader>og :MerlinGrowEnclosing<CR>
  au Filetype ocaml nmap <leader>os :MerlinShrinkEnclosing<CR>
augroup END

" YAML
augroup ft_yaml
  au!
  au FileType yaml setlocal nolist
  au FileType yaml setlocal number
  au FileType yaml setlocal colorcolumn=0
augroup END

" SQL
augroup ft_sql
  au!
  au FileType sql setlocal commentstring=--\ %s
augroup END

" Quickfix List
"
" Adjust height of quickfix window
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
augroup ft_quickfix
    autocmd!
    " Autowrap long lines in the quickfix window
    autocmd FileType qf setlocal wrap
    autocmd FileType qf call AdjustWindowHeight(3, 10)
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GVim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
  set guioptions=gc
  set lines=60 columns=90
  if has("mac")
    set guifont=Hack:h12
  else
    set guifont=Monospace\ 9
  endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Statusline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set statusline=%<\ %{mode()}\ \|\ %f%m
if has('nvim')
  set statusline+=\ \|\ %{v:lua.workspace_diagnostics_status()}
endif
set statusline+=%{&paste?'\ \ \|\ PASTE\ ':'\ '}
set statusline+=%=\ %{&fileformat}\ \|\ %{&fileencoding}\ \|\ %{&filetype}\ \|\ %l/%L\(%c\)\ 

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors/colorscheme/etc.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set termguicolors
set t_Co=256
set t_ut=

let color_profile = $COLOR_PROFILE

if color_profile == "dark"
  set background=dark

  let g:gruvbox_contrast_dark = "hard"
  colorscheme gruvbox

  highlight DiagnosticUnderlineError cterm=undercurl gui=undercurl
  highlight DiagnosticUnderlineWarn cterm=undercurl gui=undercurl
  highlight DiagnosticUnderlineInfo cterm=undercurl gui=undercurl
  highlight DiagnosticUnderlineHint cterm=undercurl gui=undercurl

  hi! link LspReferenceRead DiffChange
  hi! link LspReferenceText DiffChange
  hi! link LspReferenceWrite DiffChange
  hi! link LspSignatureActiveParameter GruvboxOrange

  hi! link TelescopeBorder GruvboxYellowBold
  hi! link TelescopePromptBorder Normal
  hi! link TelescopeResultsBorder FloatBorder
  hi! link TelescopePreviewBorder FloatBorder
else
  set background=light
  let g:lucius_style  = 'light'
  let g:lucius_contrast  = 'high'
  let g:lucius_contrast_bg  = 'high'
  let g:lucius_no_term_bg  = 1
  colorscheme lucius

  " Give the active window a blue background and white foreground statusline
  hi StatusLine ctermfg=15 ctermbg=32 guifg=#FFFFFF guibg=#005FAF gui=bold cterm=bold
  hi SignColumn ctermfg=255 ctermbg=15 guifg=#E4E4E4 guibg=#FFFFFF

  " Tweak popup colors
  highlight Pmenu guibg=#E4E4E4 guifg=#000000

  highlight link LspDiagnosticsFloatingError ErrorMsg
  highlight link LspDiagnosticsFloatingWarning WarningMsg
  highlight link LspDiagnosticsFloatingHint Directory
  highlight link LspDiagnosticsFloatingInformation Directory
endif

highlight TelescopeSelection gui=bold " selected item

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" THE END
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Only allow secure commands from this point on. Necessary because further up
" project-specific vimrc files were allowed with `set exrc`
set secure
