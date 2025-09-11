call plug#begin()

Plug 'rust-lang/rust.vim'
Plug 'junegunn/seoul256.vim'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mhinz/vim-startify'

call plug#end()

nnoremap <C-h> :NERDTreeToggle<CR>

let g:ale_completion_enabled = 1
inoremap <silent><expr> <c-@> coc#refresh()
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
"inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" custom vimrc
colorscheme seoul256
set nocompatible
filetype plugin on
set number
set wrap
set mouse=a
set showmatch
set ruler
set visualbell

set nobackup
set nowritebackup

set updatetime=300
set signcolumn=yes

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
