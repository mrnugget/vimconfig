call plug#begin('~/.vim/plugged')

Plug 'AndrewRadev/splitjoin.vim'
Plug 'bronson/vim-visual-star-search'
Plug 'christoomey/vim-tmux-navigator'
Plug 'fatih/vim-go', { 'tag': 'v1.18', 'do': ':GoInstallBinaries' }
Plug 'sheerun/vim-polyglot'
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf.vim'
Plug 'sjl/tslime.vim'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-leiningen'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-eunuch'
Plug 'saltstack/salt-vim'
Plug 'chr4/vim-gnupg'
Plug 'neomake/neomake'
Plug 'janko-m/vim-test'
Plug 'prettier/vim-prettier', {
  \ 'tag': '0.2.7',
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue'] }

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
set statusline+=%{&paste?'\ \ \|\ PASTE\ ':'\ '}
set statusline+=%{NeomakeStatus()}
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
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
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

" Ruby
let b:ruby_no_expensive = 1
let ruby_no_special_methods = 1
nmap <leader>ru :!ruby %<CR>
" Converting symbols from ruby 1.8 syntax to 1.9
nmap <silent> <leader>19 hf:xepld3l
" Converting ruby symbols to strings
nmap <silent> <leader>tst f:xviwS"
" Insert hashrocket
imap <c-l> =>
" puts the selected expression in the line above
" like this: `puts "<myexpression>=#{<myexpression>}"`
vmap <silent> <leader>pe mz"eyOputs "<ESC>"epa=#{<ESC>"epa}"<ESC>`z
" pipes the selected region to `jq` for formatting
vmap <silent> <leader>jq :!cat\|jq . <CR>

" node.js
nmap <leader>no :!node %<CR>

" Golang
nmap <leader>gos :e /usr/local/go/src/<CR>
let g:go_fmt_command = "goimports"
let g:go_highlight_structs = 0

"""""""""""""""""""
" Plugin Configuration

" vim-polyglot
" I manually upgrade vim-go
let g:polyglot_disabled = ['go']

" prettier
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.ts PrettierAsync

" Enable matchit.vim, which ships with Vim but isn't enabled by default
" somehow
runtime macros/matchit.vim

" netrw
let g:netrw_liststyle = 3
let g:netrw_keepj="keepj"

" fugitive.vim
nmap <leader>gb :Gblame<CR>

" Tabular
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>ah :Tabularize /=>\?<CR>
vmap <leader>ah :Tabularize /=>\?<CR>

" Rails.vim
let g:rails_no_abbreviations = 0

" autocmd FileType ruby set omnifunc=rubycomplete#Complete
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1
let g:rubycomplete_load_gemfile = 1

" Dispatch.vim
" Skip `bundle exec` when trying to determine the compiler for the given
" command
let g:dispatch_compilers = {'bundle exec': '', 'zeus': ''}
" let g:dispatch_compilers = {'bundle exec': ''}

" vim-test
let test#strategy = "neomake"
let g:neomake_open_list = 2

function! NeomakeStarted()
    let g:show_neomake_running = 1
endfunction

function! MyOnNeomakeJobFinished() abort
  let g:show_neomake_running = 0
  let context = g:neomake_hook_context
  if context.jobinfo.exit_code != 0
    echom printf('The job for maker %s exited non-zero: %s',
    \ context.jobinfo.maker.name, context.jobinfo.exit_code)
  endif
endfunction
function! NeomakeStatus()
    if get(g:, 'show_neomake_running', 0) == 0
        return " "
    endif

    return " | RUNNING"
endfunction

augroup neomake_hooks
    au!
    autocmd User NeomakeJobInit nested call NeomakeStarted()
    autocmd User NeomakeJobInit :echom "Build started"
    autocmd User NeomakeFinished :echom "Build complete"
    autocmd User NeomakeJobFinished nested call MyOnNeomakeJobFinished()
augroup END

" Running tests
" ,rt runs rspec on current (or previously set ) single spec ('run this')
" ,rf runs rspec on current (or previously set) spec file ('run file')
" ,ra runs all specs ('run all')
nmap <silent> <leader>rt :TestNearest<CR>
nmap <silent> <leader>rf :TestFile<CR>
nmap <silent> <leader>ra :TestSuite<CR>

" Special bindings to use the neovim strategy, because the neomake strategy
" does not work with synchronous commands, i.e. when I have a breakpoint/repl
" in a test
nmap <silent> <leader>et :TestNearest -strategy=neovim<CR>
nmap <silent> <leader>ef :TestFile -strategy=neovim<CR>


" Markdown
let g:markdown_fenced_languages = ['go', 'ruby', 'html', 'javascript', 'bash=sh', 'sql']
let g:vim_markdown_fenced_languages = ['go', 'ruby', 'html', 'javascript', 'bash=sh', 'sql']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_level = 6
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_default_key_mappings = 1
" Taken from here: https://github.com/plasticboy/vim-markdown/issues/232
autocmd FileType markdown
    \ set formatoptions-=q |
    \ set formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*\[-*+]\\s\\+

" Surround.vim
let g:surround_45 = "<% \r %>"
let g:surround_61 = "<%= \r %>"

" tslime.vim
let g:tslime_ensure_trailing_newlines = 1 " Always send newline
let g:tslime_normal_mapping = '<leader>sl'
let g:tslime_visual_mapping = '<leader>sl'
let g:tslime_vars_mapping = '<leader>csl' " Connect SLime

" FZF mappings and custom functions
" map <leader>fb to fuzzy find open buffers
nnoremap <silent> <leader>fb :Buffers<CR>
" map <leader>fi to fuzzy find files
nnoremap <silent> <leader>fi :FZF<CR>
nnoremap <silent> <C-p> :FZF<CR>

" Notes
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

nmap <silent> <leader>nl :Notes<CR>
nmap <silent> <leader>nn :Notes<CR>

function! s:ripgrep_to_qf(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        \ 'text': join(parts[3:], ':')}
endfunction

function! s:ripgrep_handler(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-x': 'split',
               \ 'ctrl-v': 'vertical split',
               \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
  let list = map(a:lines[1:], 's:ripgrep_to_qf(v:val)')

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
\ 'source':  printf('rg --column --line-number --no-heading --color=always "%s" %s',
\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\'), s:notes_folder),
\ 'sink*':    function('<sid>ripgrep_handler'),
\ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
\            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
\            '--color hl:68,hl+:110',
\ 'down':    '50%'
\ })

nmap <silent> <leader>fn :FindNotes<CR>

" Add a newline after each occurrence of the last search term.
" Splitting array literals, etc. into multiple lines...
" Taken from here:
" https://stackoverflow.com/questions/17667032/how-to-split-text-into-multiple-lines-based-on-a-pattern-using-vim
vnoremap SS :s//&\r/g<CR>


" Repeat last command in tmux window below (if two-pane setup)
nmap <leader>rep :!tmux send-keys -t 2 C-p C-j <CR><CR>

"""""""""""""""""""
" Filetypes

" Ruby
augroup ft_ruby
  au!
augroup END

" Rspec Files
augroup ft_rspec
  au!
  au! BufNewFile,BufRead *_spec.rb syn keyword rubyRspec describe context it specify it_should_behave_like before after setup subject its shared_examples_for shared_context let
  au! BufNewFile,BufRead *_spec.rb highlight def link rubyRspec Function
augroup END

" eruby, slim, html
augroup ft_html
  au!
  au BufNewFile,BufRead *.html.erb setlocal filetype=eruby.html
  au BufNewFile,BufRead *.html.slim setlocal filetype=haml.html
augroup END

" Markdown
augroup ft_markdown
  au!
  au BufNewFile,BufRead *.md setlocal filetype=markdown
  au BufNewFile,BufRead *.md setlocal textwidth=80
  au BufNewFile,BufRead *.md setlocal smartindent " Indent lists correctly

  " au BufNewFile,BufRead *.md setlocal wrap
  " au BufNewFile,BufRead *.md setlocal linebreak
augroup END

" C
augroup ft_c
  au!
  au Filetype c setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
  " Kernel Settings
  " au FileType c setlocal tabstop=8 shiftwidth=8 textwidth=80 noexpandtab
  " au FileType c setlocal cindent formatoptions=tcqlron cinoptions=:0,l1,t0,g0
augroup END

" Python
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

" Go
augroup ft_golang
  au!
  au BufEnter,BufNewFile,BufRead *.go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4 nolist
  au BufEnter,BufNewFile,BufRead *.go setlocal completeopt-=preview
  " Enable automatic continuation of comment inserting
  au BufEnter,BufNewFile,BufRead *.go setlocal formatoptions+=ro
  au BufEnter,BufNewFile,BufRead *.tmpl setlocal filetype=html

  au Filetype go nmap <c-]> <Plug>(go-def)
  au Filetype go nmap <leader>goi <Plug>(go-info)
  au Filetype go nmap <leader>god <Plug>(go-def)
  au Filetype go nmap <leader>gou <Plug>(go-run)
  au Filetype go nmap <leader>gor <Plug>(go-rename)
  au Filetype go nmap <leader>got :GoTest!<CR>
  au Filetype go nmap <leader>rt :GoTestFunc!<CR>
  au Filetype go nmap <leader>gom :GoImports<CR>

  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
augroup END

" GNU Assembler
" Insert comments automatically on return in insert and when using O/o in
" normal mode
autocmd FileType asm setlocal formatoptions+=ro

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
colorscheme default
" Give the active window a blue background and white foreground
hi StatusLine ctermfg=15 ctermbg=32 cterm=bold
hi SignColumn ctermfg=255 ctermbg=15
if $TERM_PROGRAM =~ "iTerm.app"
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
endif

" Only allow secure commands from this point on. Necessary because further up
" project-specific vimrc files were allowed with `set exrc`
set secure
