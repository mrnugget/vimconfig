call pathogen#infect()
call pathogen#helptags()

syntax enable
filetype on
filetype plugin on
filetype indent on

set noerrorbells
set visualbell

set clipboard=unnamed
set showmode
set history=100
set nocompatible
set hidden
set wildmenu
set scrolloff=2
set number
set cursorline
set colorcolumn=80
set textwidth=80
set nowrap

" Time out on key codes, not mappings.
set notimeout
set ttimeout
set ttimeoutlen=10

" Backup
set undofile
set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//
set backup
set noswapfile

" Folding
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo

au VimResized * :wincmd =

set showmatch
set backspace=2
set ignorecase
set smartcase

" Searching
set incsearch
set hlsearch

" Indenting
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
" set autoindent
" set smartindent

set stl=%{fugitive#statusline()\ }%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n
set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set ruler
set laststatus=2

" ctags tags file
set tags=./tags;

"""""""""""""""""""
" Mappings
"
" <leader> is ,
let mapleader = ","

" Big mode
nmap <silent> <leader>bm :set columns=180<CR>
" Small mode
nmap <silent> <leader>sm :set columns=90<CR>

" Toggle paste mode
nmap <silent> <leader>p :set invpaste<CR>:set paste?<CR>

" Toggle hlsearch
nmap <silent> <leader>h :set invhlsearch<CR>

" Center next search result
nnoremap n nzzzv
nnoremap N Nzzzv

" Open and source vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
" Wipe out ALL the buffers
nmap <silent> <leader>bw :0,200bwipeout<CR>
" Delete current buffer
nmap <silent> <leader>bd :bd<CR>
" Close current window
nmap <silent> <leader>q <C-w>q
" Delete all trailing whitespaces
nmap <silent> <leader>tw :%s/\s\+$//<CR>

" Ruby
nmap <leader>ru :!ruby %<CR>
" Converting symbols from ruby 1.8 syntax to 1.9
nmap <silent> <leader>19 f:xepld3l
" Converting ruby symbols to strings
nmap <silent> <leader>tst f:xviwS"

" node.js
nmap <leader>no :!node %<CR>

" Typing 'jj' == Esc
ino jj <esc>
cno jj <c-c>

" Rspec
"
" ,rt runs rspec on current spec ('run this')
" ,rf runs rspec on current spec file ('run file')
" ,ra runs rspec on all spec in current specs directory ('run all')
nmap <silent> <leader>rt :exec ":!bundle exec rspec --no-color % -l ".line('.')<CR>
nmap <silent> <leader>rf :exec ":!bundle exec rspec --no-color %"<CR>
nmap <silent> <leader>ra :exec ":!bundle exec rspec --no-color %:p:h"<CR>

" CTRL-P Plugin
" Don't mess with my working directory!
let g:ctrlp_working_path_mode = 0
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/vendor/bundle/*
" Clear cache with ,cc
nmap <leader>cc :CtrlPClearAllCaches<CR>

" Powerline
let g:Powerline_symbols = 'fancy'

" Tabular
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>ah :Tabularize /=>\?<CR>
vmap <leader>ah :Tabularize /=>\?<CR>
nmap <leader>a: :Tabularize /:\zs<CR>
vmap <leader>a: :Tabularize /:\zs<CR>

"""""""""""""""""""
" Filetypes
"

" Ruby
augroup ft_ruby
  au!
  au Filetype ruby setlocal foldmethod=syntax
  au Filetype ruby setlocal foldlevel=9
augroup END

" Rspec Files
autocmd BufRead *_spec.rb syn keyword rubyRspec describe context it specify it_should_behave_like before after setup subject its shared_examples_for shared_context let
highlight def link rubyRspec Function

" eruby, html
augroup ft_html
  au!
  au BufNewFile,BufRead *.html.erb setlocal filetype=eruby.html
augroup END

augroup ft_markdown
  au!
  au BufNewFile,BufRead *.md setlocal filetype=markdown
augroup END

" C
autocmd FileType c setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

"""""""""""""""""""
" GPG
" Transparent editing of gpg encrypted files.
" By Wouter Hanegraaff <wouter@blub.net>
augroup encrypted
  au!

  " First make sure nothing is written to ~/.viminfo while editing
  " an encrypted file.
  autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
  " We don't want a swap file, as it writes unencrypted data to disk
  autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
  autocmd BufReadPre,FileReadPre      *.gpg set noundofile
  autocmd BufReadPre,FileReadPre      *.gpg set nobackup
  " Switch to binary mode to read the encrypted file
  autocmd BufReadPre,FileReadPre      *.gpg set bin
  autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
  autocmd BufReadPre,FileReadPre      *.gpg let shsave=&sh
  autocmd BufReadPre,FileReadPre      *.gpg let &sh='sh'
  autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt --default-recipient-self 2> /dev/null
  autocmd BufReadPost,FileReadPost    *.gpg let &sh=shsave

  " Switch to normal mode for editing
  autocmd BufReadPost,FileReadPost    *.gpg set nobin
  autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

  " Convert all text to encrypted text before writing
  autocmd BufWritePre,FileWritePre    *.gpg set bin
  autocmd BufWritePre,FileWritePre    *.gpg let shsave=&sh
  autocmd BufWritePre,FileWritePre    *.gpg let &sh='sh'
  autocmd BufWritePre,FileWritePre    *.gpg '[,']!gpg --encrypt --default-recipient-self 2>/dev/null
  autocmd BufWritePre,FileWritePre    *.gpg let &sh=shsave

  " Undo the encryption so we are back in the normal text, directly
  " after the file has been written.
  autocmd BufWritePost,FileWritePost  *.gpg   silent u
  autocmd BufWritePost,FileWritePost  *.gpg set nobin
augroup END

set background=dark

" GVim
if has("gui_running")
  colorscheme molokai
  set guioptions=gc
  set lines=60 columns=90
else
  colorscheme desert
endif

" Fonts
if has("mac")
  set guifont=Monaco:h12
else
  set guifont=Monospace\ 9
endif
