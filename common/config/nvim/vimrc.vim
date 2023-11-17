call plug#begin()

Plug 'nvim-tree/nvim-web-devicons' " optional
Plug 'nvim-tree/nvim-tree.lua'
Plug 'vimwiki/vimwiki'
Plug 'lervag/vimtex'
" Plug 'sirver/ultisnips'
Plug 'lewis6991/gitsigns.nvim' " OPTIONAL: for git status
Plug 'nvim-tree/nvim-web-devicons' " OPTIONAL: for file icons
Plug 'romgrk/barbar.nvim'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

call plug#end()

" barbar


" this is for SCHOOL NOTES
let g:vimwiki_list = [{'path':'~/uci-notes/'}, {'path_html':'~/uci-notes/export/html/'}]
let g:wiki_root = "~/uci-notes/"

" snippets
" let g:UltiSnipsExpandTrigger = '<tab>'
" let g:UltiSnipsJumpForwardTrigger = '<tab>'
" let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
" let g:UltiSnipsSnippetDirectories = "~/.config/nvim/"

" vimtex settings
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

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

set incsearch
set hlsearch

set linebreak
set encoding=utf-8
set scrolloff=8
set sidescrolloff=8
set laststatus=2
set wildmenu
set title

set backspace=indent,eol,start
set confirm
set history=1000

nnoremap j gj
nnoremap k gk
nnoremap B ^
nnoremap E $

