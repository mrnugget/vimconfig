call pathogen#infect()
call pathogen#helptags()

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
set clipboard=unnamed
set showmode
set showcmd
set history=500
set nocompatible
set hidden
set wildmenu
set scrolloff=5
set number
set cursorline
set colorcolumn=80
set nowrap
set showmatch
set backspace=2
" Make J not insert whitespace
set nojoinspaces

" Time out on key codes, not mappings.
set notimeout
set ttimeout
set ttimeoutlen=10

" Some tuning for macvim
set ttyfast
set lazyredraw

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

" Indenting
set tabstop=2
set shiftwidth=2
set softtabstop=2
set shiftround
set expandtab

set statusline=%<\ %{mode()}\ \|\ %f%m\ \|\ %{fugitive#head()\ }
set statusline+=%=\ %{&fileformat}\ \|\ %{&fileencoding}\ \|\ %{&filetype}\ \|\ %l/%L\(%c\)\ 

set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set ruler
set laststatus=2

" ctags tags file
set tags=./tags;

set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/vendor/bundle/*,*/node_modules/*

" Use The Silver Searcher with fzz as :grep
if executable('ag')
  set grepprg=fzz\ ag\ --nogroup\ --nocolor\ \{\{\$*}\}
endif

"""""""""""""""""""
" Mappings
"
" <leader> is ,
let mapleader = ","
noremap \ ,

" Move around splits with <C-[hjkl]>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Move sanely through wrapped lines
nnoremap k gk
nnoremap j gj

" Toggle paste mode
nmap <silent> <leader>p :set invpaste<CR>:set paste?<CR>

" Make Y behave like C and D
nmap <silent> Y y$

" Toggle hlsearch
nmap <silent> <leader>h :set invhlsearch<CR>

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

" Greps the current word under the cursor
nmap <leader>gr :gr! <C-r><C-w><CR>

" Ruby
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

" Brittle function to convert instance variables in rspec tests
" to let statements
function! InstanceToLet()
  normal "zdt=w
  normal "xd$
  normal ?doOlet(:"zpF@xEa) doend
  normal O"xp==``dd
endfunction

nmap <leader>itol :call InstanceToLet()<CR>

" node.js
nmap <leader>no :!node %<CR>

" Golang
nmap <leader>gos :e /usr/local/go/src/pkg/<CR>
nmap <leader>goi <Plug>(go-info)
nmap <leader>god <Plug>(go-def)
nmap <leader>gou <Plug>(go-run)
nmap <leader>gor <Plug>(go-rename)
nmap <leader>got :GoTest!<CR>
nmap <leader>gom :GoImports<CR>
let g:go_fmt_command = "goimports"
let g:go_highlight_structs = 1

" Selecta
function! SelectaCommand(choice_command, vim_command)
  try
    silent! exec a:vim_command . " " . system(a:choice_command . " | selecta")
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
  endtry
  redraw!
endfunction

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
map <leader>f :call SelectaCommand("ag -l --nocolor -g ''", ":e")<cr>


" Running tests
" ,rt runs rspec on current (or previously set ) single spec ('run this')
" ,rf runs rspec on current (or previously set) spec file ('run file')
" ,ra runs all specs ('run all')
nmap <silent> <leader>rt :call RunNearestTest()<CR>
nmap <silent> <leader>rf :call RunTestFile()<CR>
nmap <silent> <leader>ra :call RunTests('')<CR>


""""""""""""""""""""""""
"
" Setting test file/single test and running it
"
function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  let in_test_file = match(expand("%"), '_spec.rb$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let in_test_file = match(expand("%"), '_spec.rb$') != -1
  if in_test_file
    let t:grb_test_file_line=line(".")
  elseif !exists("t:grb_test_file_line")
    return
  end
  call RunTestFile(":" . t:grb_test_file_line)
endfunction

function! SetTestFile()
  let t:grb_test_file=@%
endfunction

function! RunTests(filename)
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo

  if glob(".zeus.sock") != ""
    exec ":Dispatch zeus rspec --color " . a:filename
  elseif filereadable("Gemfile")
    exec ":Dispatch bundle exec rspec --color " . a:filename
  else
    exec ":Dispatch rspec --color " . a:filename
  end
endfunction

" Renaming a file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>rn :call RenameFile()<cr>

"""""""""""""""""""
" Plugin Configuration
"

" Enable matchit.vim, which ships with Vim but isn't enabled by default
" somehow
runtime macros/matchit.vim

" netrw
let g:netrw_liststyle = 3

" fugitive.vim
nmap <leader>gb :Gblame<CR>

" CTRL-P
" Don't mess with my working directory!
let g:ctrlp_working_path_mode = 0
let g:ctrl_max_height = 20

if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

" Clear cache with ,cc
nmap <leader>cc :CtrlPClearAllCaches<CR>

" Tabular
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>ah :Tabularize /=>\?<CR>
vmap <leader>ah :Tabularize /=>\?<CR>

" Rails.vim
let g:rails_no_abbreviations = 0

autocmd FileType ruby set omnifunc=rubycomplete#Complete
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

" Markdown
let g:markdown_fenced_languages = ['ruby', 'html', 'javascript', 'bash=sh']

" Surround.vim
let g:surround_45 = "<% \r %>"
let g:surround_61 = "<%= \r %>"

" Nerdtree
nmap <leader>nt :NERDTreeToggle<CR>

" tslime.vim
let g:tslime_ensure_trailing_newlines = 1 " Always send newline
let g:tslime_normal_mapping = '<leader>sl'
let g:tslime_visual_mapping = '<leader>sl'
let g:tslime_vars_mapping = '<leader>csl' " Connect SLime

"""""""""""""""""""
" Filetypes
"
" Rspec Files
augroup ft_rspec
  au!
  au BufNewFile,BufRead *_spec.rb syn keyword rubyRspec describe context it specify it_should_behave_like before after setup subject its shared_examples_for shared_context let
  au BufNewFile,BufRead *_spec.rb highlight def link rubyRspec Function
augroup END

" eruby, html
augroup ft_html
  au!
  au BufNewFile,BufRead *.html.erb setlocal filetype=eruby.html
augroup END

" Markdown
augroup ft_markdown
  au!
  au BufNewFile,BufRead *.md setlocal filetype=markdown
  au BufNewFile,BufRead *.md setlocal textwidth=80
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
  au BufNewFile,BufRead *.go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4 nolist
  au BufNewFile,BufRead *.go setlocal completeopt-=preview

  au BufNewFile,BufRead *.tmpl setlocal filetype=html
augroup END

" GNU Assembler
" Insert comments automatically on return in insert and when using O/o in
" normal mode
autocmd FileType asm setlocal formatoptions+=ro

" GVim
if has("gui_running")
  set guioptions=gc
  set lines=60 columns=90
  set background=light
  colorscheme hemisu
  if has("mac")
    set guifont=Source\ Code\ Pro:h11
  else
    set guifont=Monospace\ 9
  endif
else
  set background=dark
  colorscheme jellybeans
endif
