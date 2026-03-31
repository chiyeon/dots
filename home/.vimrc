" super simple vimrc - no plugins

" --- GENERAL ---
set nocompatible
set encoding=utf-8
set timeoutlen=300
set hidden
set noswapfile
set mouse=a
set ttyfast
set clipboard=unnamed
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

" fix for macos
set re=2

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
" nnoremap d "_d
" nnoremap D "_D
" vnoremap d "_d

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

" buffers
nnoremap <leader>b :buffers<CR>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>v <C-w>v
nnoremap <leader>s <C-w>s
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" tabedit
nnoremap <leader>te :tabedit<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tp :tabprev<CR>

" toggle whitespace visualization
set listchars=tab:▸\ ,eol:¬
nnoremap <leader>w :set list!<CR>

" --- MARKDOWN ---
augroup markdown
  autocmd!
  autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType markdown setlocal spell spelllang=en_us
  " autocmd FileType markdown setlocal conceallevel=2
  autocmd FileType markdown let &l:comments = 'b:- [x],b:- [ ],b:-,b:*'
  autocmd FileType markdown setlocal formatoptions+=ro
augroup END

" --- NETRW ---
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_fastbrowse = 1
let g:netrw_keepdir = 0

nnoremap <silent> <leader>e :Lexplore<CR>

" --- PLUGINS ---
if $VIM_ENABLE_PLUGINS == '1'

endif
