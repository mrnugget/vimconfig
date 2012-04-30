call pathogen#infect()
call pathogen#helptags()

set showmode
set history=100
set nobackup
set nocompatible
set hidden
set wildmenu
set scrolloff=2
set number
set cursorline
set colorcolumn=80
set textwidth=80
set nowrap

" Folding
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo

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
set autoindent
set smartindent

set stl=%{fugitive#statusline()\ }%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n
set ruler
set laststatus=2

syntax enable
filetype on
filetype plugin on
filetype indent on

set noerrorbells
set visualbell


"""""""""""""""""""
" Mappings
"
" <leader> is ,
let mapleader = "," 

" Toggle paste mode
nmap <silent> <leader>p :set invpaste<CR>:set paste?<CR>

" Toggle hlsearch
nmap <silent> <leader>h :set invhlsearch<CR>

" Open and source vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
" Wipe out ALL the buffers
nmap <silent> <leader>bw :0,200bwipeout<CR>
" Delete current buffer
nmap <silent> <leader>bd :bd<CR>

" Typing 'jj' == Esc
ino jj <esc>
cno jj <c-c>

" Rails.vim
"
" Command+R runs Rake on current spec file
nmap <silent> <D-r> :Rake<CR>

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

" GVim
if has("gui_running")
  colorscheme mrmolokai
  set guioptions=agc
  set lines=60 columns=90
endif

" Fonts
if has("mac")
  set guifont=Monaco:h12
else
  set guifont=Monospace\ 9
endif
