" this is for SCHOOL NOTES
let g:vimwiki_list = [{'path':'~/uci-notes/'}, {'path_html':'~/uci-notes/export/html/'}]
let g:wiki_root = "~/uci-notes/"

" custom vimrc
set nocompatible
filetype plugin on
set number
set wrap
set mouse=a
set showmatch
set ruler
set visualbell

syntax enable

set tabstop=3
set expandtab
set shiftwidth=3
set softtabstop=3

set autoindent
set smartindent
set smarttab

set incsearch
set hlsearch
set ignorecase

set linebreak
set encoding=utf-8
set scrolloff=8
set sidescrolloff=8
set laststatus=2
set wildmenu
set title

set dir=~/.cache/vim
set backspace=indent,eol,start
set confirm
set history=1000

nnoremap j gj
nnoremap k gk
nnoremap B ^
nnoremap E $

