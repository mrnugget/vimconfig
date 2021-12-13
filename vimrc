call plug#begin('~/.vim/plugged')

let g:polyglot_disabled = ['go', 'markdown']

Plug 'AndrewRadev/splitjoin.vim'
Plug 'bronson/vim-visual-star-search'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/fzf.vim'
Plug 'benmills/vim-golang-alternate'
Plug 'plasticboy/vim-markdown'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
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
Plug 'gruvbox-community/gruvbox'

if has('nvim')
" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
" Extensions to built-in LSP, for example, providing type inlay hints
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'rafcamlet/nvim-luapad'
Plug 'tjdevries/nlua.nvim'

Plug 'simrat39/rust-tools.nvim'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Completion
Plug 'hrsh7th/cmp-nvim-lsp', { 'branch': 'main' }
Plug 'hrsh7th/cmp-buffer', { 'branch': 'main' }
Plug 'hrsh7th/cmp-path', { 'branch': 'main' }
Plug 'hrsh7th/cmp-vsnip', { 'branch': 'main' }
Plug 'hrsh7th/nvim-cmp', { 'branch': 'main' }

" Fancy icons for completion
Plug 'onsails/lspkind-nvim'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/lsp-trouble.nvim', { 'branch': 'main' }

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'jose-elias-alvarez/null-ls.nvim', {'branch': 'main'}
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils', {'branch': 'main'}
end

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

" Check if we can load the FZF vim plugin
if filereadable("/usr/local/opt/fzf/bin/fzf")
  set rtp+=/usr/local/opt/fzf
end

if filereadable("/home/mrnugget/.fzf/bin/fzf")
  set rtp+=/home/mrnugget/.fzf
end

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

" Show incremental search/replace
if has('nvim')
  set inccommand=nosplit
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


if has('nvim')
  lua require('globals')
end
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

" In visual mode don't include the newline-character when jumping to
" end-of-line with $
vnoremap $ $h

" Paste and reformat with = to the last part of the previous
" paste. Let's see how this works.
"nnoremap p p=`]

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
" Converting symbols from ruby 1.8 syntax to 1.9
nmap <silent> <leader>19 hf:xepld3l
" Converting ruby symbols to strings
nmap <silent> <leader>tst f:xviwS"
" Repeat last command in tmux window below (if two-pane setup)
nmap <leader>rep :!tmux send-keys -t 2 C-p C-j <CR><CR>
" `puts` the selected expression in the line above
" like this: `puts "<myexpression>=#{<myexpression>}"`
vmap <silent> <leader>pe mz"eyOputs "<ESC>"epa=#{<ESC>"epa}"<ESC>`z
" Pipes the selected region to `jq` for formatting
vmap <silent> <leader>jq :!cat\|jq . <CR>
" Pipes the selection region to `pandoc` to convert it to HTML, opens the temp
" file.
vmap <silent> <leader>pan :w !cat\|pandoc -s -f markdown --metadata title="foo" -o ~/tmp/pandoc_out.html && open ~/tmp/pandoc_out.html <CR>
vmap <silent> <leader>word :w !cat\|pandoc -s -f markdown --toc --metadata title="foo" -o ~/tmp/pandoc_out.docx && open ~/tmp/pandoc_out.docx <CR>

" Center cursor
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Switch or create new tmux session
nnoremap <silent> <C-f> :silent !tmux neww tmux-sessionizer<CR>

nnoremap <C-n> :silent cnext<CR>
nnoremap <C-p> :silent cprevious<CR>

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

" Tabular
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>ah :Tabularize /=>\?<CR>
vmap <leader>ah :Tabularize /=>\?<CR>

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

" Markdown
let g:markdown_fenced_languages = ['go', 'ruby', 'html', 'javascript', 'bash=sh', 'sql']
let g:vim_markdown_fenced_languages = ['go', 'ruby', 'html', 'javascript', 'bash=sh', 'sql']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_level = 6
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_default_key_mappings = 1

" FZF mappings and custom functions
" nnoremap <silent> <leader>fc :BCommits<CR>
" nnoremap <silent> <leader>fb :Buffers<CR>
" nnoremap <silent> <leader>fr :History<CR>
" nnoremap <silent> <leader>ft :Tags<CR>
" nnoremap <silent> <leader>fi :FZF<CR>
" nnoremap <silent> <C-p> :FZF<CR>

" Hide statusline
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

let g:fzf_colors =
\ { "fg":      ["fg", "Normal"],
  \ "bg":      ["bg", "Normal"],
  \ "hl":      ["fg", "IncSearch"],
  \ "fg+":     ["fg", "CursorLine", "CursorColumn", "Normal"],
  \ "bg+":     ["bg", "CursorLine", "CursorColumn"],
  \ "hl+":     ["fg", "IncSearch"],
  \ "info":    ["fg", "IncSearch"],
  \ "border":  ["fg", "Ignore"],
  \ "prompt":  ["fg", "Comment"],
  \ "pointer": ["fg", "IncSearch"],
  \ "marker":  ["fg", "IncSearch"],
  \ "spinner": ["fg", "IncSearch"],
  \ "header":  ["fg", "WildMenu"] }


" Telescope.nvim, see lua/plugins/telescope.lua
if has('nvim')
  lua require('plugins.telescope')
end

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Notes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:notes_folder = "~/Dropbox/notes"
let s:notes_fileending = ".md"

" This is either called with
" 0 lines, which means there's no result and no query
" 1 line, which means there's no result, but a user query
"         in this case: create a new file, based on user query
" 2 lines, which means there are results, so open them
"
function! s:note_handler(lines)
  if len(a:lines) < 1 | return | endif

  if len(a:lines) == 1
    let query = a:lines[0]
    let new_filename = fnameescape(query . s:notes_fileending)
    let new_title = "# " . query

    execute "edit " . new_filename

    " Append the new title and an empty line
    let failed = append(0, [new_title, ''])
    if (failed)
      echo "Unable to insert title file!"
    else
      let &modified = 1
    endif
  else
    execute "edit " fnameescape(a:lines[1])
  endif
endfunction

command! -nargs=* Notes call fzf#run({
\ 'sink*':   function('<sid>note_handler'),
\ 'options': '--print-query ',
\ 'dir':     s:notes_folder
\ })

function! s:rg_to_quickfix(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        \ 'text': join(parts[3:], ':')}
endfunction

function! s:find_notes_handler(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-x': 'split',
               \ 'ctrl-v': 'vertical split',
               \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
  let list = map(a:lines[1:], 's:rg_to_quickfix(v:val)')

  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'

  if len(list) > 1
    call setqflist(list)
    copen
    wincmd p
  endif
endfunction

command! -nargs=* FindNotes call fzf#run({
\ 'source':  printf('rg --column --color=always "%s"',
\                   escape(empty(<q-args>) ? '' : <q-args>, '"\')),
\ 'sink*':    function('<sid>find_notes_handler'),
\ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
\            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
\            '--color hl:68,hl+:110',
\ 'down':    '50%',
\ 'dir':     s:notes_folder
\ })

command! -bang -nargs=* FindNotesWithPreview
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'dir': s:notes_folder}, 'right:50%'),
  \   0,
  \ )

nmap <silent> <leader>nn :Notes<CR>
nmap <silent> <leader>fn :FindNotes<CR>
nmap <silent> <leader>nw :FindNotesWithPreview<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vsnip configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: You can use other key to expand snippet.

" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap  s   <Plug>(vsnip-select-text)
xmap  s   <Plug>(vsnip-select-text)
nmap  S   <Plug>(vsnip-cut-text)
xmap  S   <Plug>(vsnip-cut-text)

" If you want to use snippet for multiple filetypes, you can `g:vsnip_filetypes` for it.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

let g:vsnip_snippet_dir = "~/.vim/snippets"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cmp configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require('cmp')
  local lspkind = require('lspkind')

  cmp.setup({
     formatting = {
       format = lspkind.cmp_format({
         with_text = true,
         menu = ({
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            vsnip = "[vsnip]",
            nvim_lua = "[Lua]",
          })
       }),
     },
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<Tab>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'buffer', keyword_length = 5 },
      { name = 'path' },
    }
  })
EOF
endif
set completeopt=menu,menuone,noselect

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('nvim')
  lua require("lsp")
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treesitter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('nvim')
  lua require("treesitter")
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Markdown helper
if has('nvim')
  lua require("markdown")
endif

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

set statusline=%<\ %{mode()}\ \|\ %f%m\ \|\ %{fugitive#statusline()\ }
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

let kitty_profile = $KITTY_COLORS

if kitty_profile == "dark"
  set background=dark

  let g:gruvbox_contrast_dark = "hard"
  colorscheme gruvbox
  highlight DiagnosticUnderlineError cterm=undercurl gui=undercurl
  highlight DiagnosticUnderlineWarn cterm=undercurl gui=undercurl
  highlight DiagnosticUnderlineInfo cterm=undercurl gui=undercurl
  highlight DiagnosticUnderlineHint cterm=undercurl gui=undercurl
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
