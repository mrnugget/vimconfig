call plug#begin('~/.vim/plugged')

let g:polyglot_disabled = ['go', 'markdown']

Plug 'AndrewRadev/splitjoin.vim'
Plug 'bronson/vim-visual-star-search'
Plug 'christoomey/vim-tmux-navigator'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'sheerun/vim-polyglot'
Plug 'plasticboy/vim-markdown'
Plug 'junegunn/fzf.vim'
Plug 'sjl/tslime.vim'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-unimpaired'
Plug 'janko-m/vim-test'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'typescript.jsx', 'typescript.tsx', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'html'] }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jonathanfilip/vim-lucius'

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
set clipboard=unnamed
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

set statusline=%<\ %{mode()}\ \|\ %f%m\ \|\ %{fugitive#statusline()\ }
set statusline+=\|\ %{coc#status()}
set statusline+=%{&paste?'\ \ \|\ PASTE\ ':'\ '}
set statusline+=%=\ %{&fileformat}\ \|\ %{&fileencoding}\ \|\ %{&filetype}\ \|\ %l/%L\(%c\)\ 

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

"""""""""""""""""""
" Mappings
"
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
nmap <silent> <leader>bw :%bwipeout<CR>
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
vmap <silent> <leader>word :w !cat\|pandoc -s -f markdown --metadata title="foo" -o ~/tmp/pandoc_out.docx && open ~/tmp/pandoc_out.docx <CR>

" Node.js
nmap <leader>no :!node %<CR>
" Ruby
nmap <leader>ru :!ruby %<CR>

"""""""""""""""""""
" Plugin Configuration

" Enable the cfilter plugin that ships with Vim/NeoVim
packadd cfilter

" prettier
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx PrettierAsync

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
  autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
  nnoremap <silent> <buffer> <c-l> :TmuxNavigateRight<CR>
endfunction

" fugitive.vim
nmap <leader>gb :Gblame<CR>

" Tabular
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>ah :Tabularize /=>\?<CR>
vmap <leader>ah :Tabularize /=>\?<CR>

" vim-test
let test#strategy = "neovim"
" ,rt runs rspec on current (or previously set ) single spec ('run this')
" ,rf runs rspec on current (or previously set) spec file ('run file')
" ,ra runs all specs ('run all')
nmap <silent> <leader>rt :TestNearest<CR>
nmap <silent> <leader>rf :TestFile<CR>
nmap <silent> <leader>ra :TestSuite<CR>

" Ale
" let g:ale_linters = {'go': ['go build', 'gofmt'], 'rust': ['cargo', 'rls']}
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_insert_leave = 'never'
" let g:ale_ocaml_ocamlformat_options = '--enable-outside-detected-project'
" let g:ale_fixers = {'ocaml': ['ocp-indent'], 'c': ['clang-format']}
" let g:ale_fix_on_save = 1
" let g:ale_set_loclist = 1
" let g:ale_set_quickfix = 0
" let g:ale_open_list = 1
" nmap <silent> <leader>aj :ALENextWrap<cr>
" nmap <silent> <leader>ak :ALEPreviousWrap<cr>

" Markdown
let g:markdown_fenced_languages = ['go', 'ruby', 'html', 'javascript', 'bash=sh', 'sql']
let g:vim_markdown_fenced_languages = ['go', 'ruby', 'html', 'javascript', 'bash=sh', 'sql']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_level = 6
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_default_key_mappings = 1

" tslime.vim
let g:tslime_ensure_trailing_newlines = 1 " Always send newline
let g:tslime_normal_mapping = '<leader>sl'
let g:tslime_visual_mapping = '<leader>sl'
let g:tslime_vars_mapping = '<leader>csl' " Connect SLime

" FZF mappings and custom functions
nnoremap <silent> <leader>fc :BCommits<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fr :History<CR>
nnoremap <silent> <leader>ft :Tags<CR>
nnoremap <silent> <leader>fi :FZF<CR>
nnoremap <silent> <C-p> :FZF<CR>

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

""""""""""""""""
" Notes
""""""""""""""""
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

"""""""""""""""""""
" Filetypes

" Markdown
augroup ft_markdown
  au!
  au BufNewFile,BufRead *.md setlocal filetype=markdown

  " au BufNewFile,BufRead *.md setlocal wrap
  " au BufNewFile,BufRead *.md setlocal linebreak

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
  " Kernel Settings
  " au FileType c setlocal tabstop=8 shiftwidth=8 textwidth=80 noexpandtab
  " au FileType c setlocal cindent formatoptions=tcqlron cinoptions=:0,l1,t0,g0
augroup END

" Python
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

" Go
nmap <leader>gos :e /usr/local/go/src/<CR>
" let g:go_fmt_command = "goimports"
let g:go_highlight_structs = 0
let g:go_rename_command = "gopls"

" let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_test_show_name = 1

let g:go_term_mode = "split"
let g:go_term_height = 10
" let g:go_term_enabled = 1
"
" Disabling everything for coc.vim
let g:go_fmt_command = "gopls"
let g:go_fmt_autosave = 1
let g:go_echo_command_info = 0
let g:go_auto_type_info = 0
let g:go_diagnostics_enabled = 0
let g:go_highlight_diagnostic_errors = 0
let g:go_highlight_diagnostic_warnings = 0
let g:go_def_mapping_enabled = 0

" coc.vim config
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt :CocAction('jumpTypeDefinition')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>cf <Plug>(coc-fix-current)
nmap <leader>f  <Plug>(coc-format-selected)
nnoremap <silent> <leader>cd :CocDiagnostics<cr>
nnoremap <silent> <leader>ce :<C-u>CocList extensions<cr>
nnoremap <silent> <leader>cc :<C-u>CocList commands<cr>
nnoremap <silent> <leader>co :<C-u>CocList outline<cr>
nnoremap <silent> <leader>cs :<C-u>CocList -I symbols<cr>
nnoremap <silent> <leader>cj :<C-u>CocNext<CR>
nnoremap <silent> <leader>ck :<C-u>CocPrev<CR>
nnoremap <silent> <leader>cp :<C-u>CocListResume<CR>
" autocmd CursorHold * silent call CocActionAsync('doHover')
"
augroup ft_golang
  au!

  au BufEnter,BufNewFile,BufRead *.go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4 nolist
  " au BufEnter,BufNewFile,BufRead *.go setlocal completeopt-=preview
  " Enable automatic continuation of comment inserting
  au BufEnter,BufNewFile,BufRead *.go setlocal formatoptions+=ro
  au BufEnter,BufNewFile,BufRead *.tmpl setlocal filetype=html

  au BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

  au Filetype go nmap <c-]> <Plug>(go-def)
  au Filetype go nmap <leader>gdt :GoDefType<CR>
  au Filetype go nmap <leader>gre :GoReferrers<CR>
  au Filetype go nmap <leader>goi <Plug>(go-info)
  au Filetype go nmap <leader>god :GoDeclsDir<CR>
  au Filetype go nmap <leader>gou <Plug>(go-run)
  au Filetype go nmap <leader>gor <Plug>(go-rename)
  au Filetype go nmap <leader>got :GoTest!<CR>
  au Filetype go nmap <leader>gie <Plug>(go-iferr)
  au Filetype go nmap <leader>gdi :GoDiagnostics<CR>

  au Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  au Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  au Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
augroup END

" Rust
let g:rustfmt_autosave = 1
let g:rustfmt_fail_silently = 0
let g:racer_cmd = "/Users/thorstenball/.cargo/bin/racer"

augroup ft_rust
  au!
  au BufEnter,BufNewFile,BufRead *.rs :compiler cargo

  au FileType rust set nolist
  au Filetype rust nmap <c-]> :call CocAction('jumpDefinition', 'drop')<CR>
augroup END

" Racket
augroup ft_racket
  au!
  au BufEnter,BufNewFile,BufRead *.rkt set filetype=racket
augroup END

" Typescript
augroup ft_typescript
  au!

  autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript

  au Filetype typescript nmap <c-]> :call CocAction('jumpDefinition', 'drop')<CR>
  au Filetype typescript setlocal shiftwidth=4 softtabstop=4 expandtab
augroup END

" GNU Assembler
" Insert comments automatically on return in insert and when using O/o in
" normal mode
augroup ft_asm
  au!
  autocmd FileType asm setlocal formatoptions+=ro
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


augroup ft_yaml
  au!
  au FileType yaml setlocal nolist
  au FileType yaml setlocal nonumber
  au FileType yaml setlocal colorcolumn=0
augroup END

" Quickfix List
" Autowrap long lines in the quickfix window
augroup ft_quickfix
    autocmd!
    autocmd FileType qf setlocal wrap
augroup END
" Adjust height of quickfix window
au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" GVim
if has("gui_running")
  set guioptions=gc
  set lines=60 columns=90
  if has("mac")
    set guifont=Hack:h12
  else
    set guifont=Monospace\ 9
  endif
endif

set background=light
let g:lucius_style  = 'light'
let g:lucius_contrast  = 'high'
let g:lucius_contrast_bg  = 'normal'
let g:lucius_no_term_bg  = 1
colorscheme lucius
" Give the active window a blue background and white foreground
hi StatusLine ctermfg=15 ctermbg=32 cterm=bold
hi SignColumn ctermfg=255 ctermbg=15

" Only allow secure commands from this point on. Necessary because further up
" project-specific vimrc files were allowed with `set exrc`
set secure
