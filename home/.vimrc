" super simple vimrc - no plugins

" --- GENERAL ---
set nocompatible
set encoding=utf-8
set timeoutlen=300
set hidden
set noswapfile
set mouse=a
set ttyfast
set clipboard=unnamedplus
set shortmess+=I
set modelines=0

" --- VISUALS ---
set number
set ruler
set title
set background=dark
set laststatus=2
set showmode
set showcmd
set wildmenu
set scrolloff=4
set sidescrolloff=8
set noerrorbells

" beam cursor in insert, block in normal
let &t_SI = "\<Esc>[6 q"
let &t_EI = "\<Esc>[2 q"

" --- SYNTAX & FILETYPES ---
syntax on
filetype plugin indent on

" --- INDENTATION ---
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround
set autoindent
set copyindent
set backspace=indent,eol,start

" --- WRAPPING ---
set wrap
set linebreak
set textwidth=0
set wrapmargin=0

" set colorcolumn=80
" highlight ColorColumn ctermbg=darkgray

" --- SEARCH ---
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

" --- SPLITS ---
set splitbelow splitright

" --- KEYBINDINGS ---
let mapleader = " "

" movement
nnoremap j gj
nnoremap k gk
nnoremap B ^
nnoremap E $

" delete without yanking
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d

" stay in visual mode after indent
vnoremap > >gv
vnoremap < <gv

" show all leader mappings
nnoremap <leader>? :map <leader><CR>

" clear search highlight
nnoremap <leader><space> :let @/=''<CR>
nnoremap <CR> :nohlsearch<CR><CR>

" formatting
nnoremap <leader>p gqip
nnoremap <leader>= gg=G

" toggle whitespace visualization
set listchars=tab:▸\ ,eol:¬
nnoremap <leader>l :set list!<CR>

" --- NETRW ---
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_fastbrowse = 1
let g:netrw_keepdir = 0

nnoremap <silent> <leader>h :Lexplore<CR>

" --- MARKDOWN ---
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
autocmd FileType markdown set conceallevel=2
autocmd FileType markdown set expandtab tabstop=2 shiftwidth=2
autocmd FileType markdown setlocal formatoptions+=r
autocmd FileType markdown setlocal comments-=fb:- comments+=:-
