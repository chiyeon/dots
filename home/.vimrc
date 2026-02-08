" super simple vimrc
"
" no plugins or dependencies (i hope)
set nocompatible

set timeoutlen=300

" --- SYNTAX & FORMATTING ---

" help with filetypes
filetype off " supposed to help with loading filetypes
syntax on
filetype plugin indent on

set encoding=utf-8
set wrap
set linebreak
set textwidth=0
set wrapmargin=0
set splitbelow splitright

" leader on space
let mapleader = " "

" basic visuals 
set modelines=0
set number 
set ruler
set noerrorbells
set laststatus=2
set title
set background=dark

set showmode
set wildmenu
set showcmd

set hidden

set scrolloff=4
set sidescrolloff=8

" cursors for insert/visual
let &t_SI = "\<Esc>[6 q"
let &t_EI = "\<Esc>[2 q"

" vim start message
set shortmess+=I

" usability
set mouse=a

set ttyfast

set clipboard=unnamedplus

set noswapfile

" indent
set smartindent
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround
set autoindent
set copyindent

set backspace=indent,eol,start
set matchpairs+=<:>

" --- SEARCH SETTINGS ---
" nnoremap / /\v
" vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
" trying sp-sp or cr for now

" --- INPUT ---
" movement remaps
nnoremap j gj
nnoremap k gk
nnoremap B ^
nnoremap E $

" autocomplete brackets and quotes
"inoremap ( ()<ESC>hli
"inoremap { {}<ESC>hli
"inoremap [ []<ESC>hli
"inoremap ' ''<ESC>hli
"inoremap " ""<ESC>hli
"inoremap ` ``<ESC>hli

" don't exit visual mode after indent
vnoremap > >gv
vnoremap < <gv

" clear search
map <leader><space> :let @/=''<CR>
nnoremap <CR> :nohlsearch<CR><CR>

" formatting
map <leader>p gqip " formatting paragraph
map <leader>= gg=G " format tabs

" visualize tab + newline
set listchars=tab:▸\ ,eol:¬
map <leader>l :set list!<CR> " Toggle tabs and EOL

" " --- NETRW/FILESYSTEM ---
" 
" " config
" let g:netrw_keepdir = 0
" let g:netrw_winsize = 30
" let g:netrw_banner = 0
" let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
" let g:netrw_localcopydircmd = 'cp -r'
" let g:netrw_liststyle=3
" 
" hi! link netrwMarkFile Search
" 
" " file system
" " function to toggle
" let g:NetrwIsOpen=0
" function! ToggleNetrw()
"     if g:NetrwIsOpen
"         let i = bufnr("$")
"         while (i >= 1)
"             if (getbufvar(i, "&filetype") == "netrw")
"                 silent exe "bwipeout " . i
"             endif
"             let i = -1
"         endwhile
" 
"         let g:NetrwIsOpen=0
"     else
"         let g:NetrwIsOpen=1
"         silent Lexplore
"     endif
" endfunction
" map <leader>h :call ToggleNetrw()<CR>

" --- MARKDOWN SETTINGS ---
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
" autocmd FileType markdown setlocal spell spelllang=en_us
autocmd FileType markdown set conceallevel=2
autocmd FileType markdown set expandtab tabstop=2 shiftwidth=2
" allow auto insert comment leader in edit
autocmd FileType markdown setlocal formatoptions+=r
autocmd FileType markdown setlocal comments-=fb:- comments+=:-

" " --- INTELLIGENT AUTOFILL ---
" " Auto-complete as you type with language-specific support
" set completeopt=menu,menuone,noinsert
" set shortmess+=c
" 
" " Enable omni-completion for various languages
" set omnifunc=syntaxcomplete#Complete
" 
" " Language-specific completion settings
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
" autocmd FileType c setlocal omnifunc=ccomplete#Complete
" autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
" 
" " Trigger completion after typing 2 characters
" let g:auto_complete_min_chars = 2
" 
" " Timer for auto-completion
" let g:auto_complete_timer = -1
" 
" function! AutoComplete()
"     " Don't trigger if completion menu is already visible
"     if pumvisible()
"         return
"     endif
" 
"     " Get the text before cursor
"     let l:line = getline('.')
"     let l:col = col('.') - 1
"     let l:text_before = l:line[:l:col-1]
" 
"     " Only trigger if we have enough characters
"     let l:word = matchstr(l:text_before, '\k\+$')
"     if len(l:word) >= g:auto_complete_min_chars
"         " Try omni-completion first if available, otherwise use keyword completion
"         if !empty(&omnifunc)
"             " Check if we're in a context where omni-completion makes sense
"             " (e.g., after a dot for methods/properties)
"             if l:text_before =~ '\.\k*$' || l:text_before =~ '->\k*$' || l:text_before =~ '::\k*$'
"                 call feedkeys("\<C-X>\<C-O>", 'n')
"             else
"                 call feedkeys("\<C-N>", 'n')
"             endif
"         else
"             call feedkeys("\<C-N>", 'n')
"         endif
"     endif
" endfunction
" 
" function! AutoCompleteCallback(timer)
"     call AutoComplete()
" endfunction
" 
" " Auto-trigger completion on text change in insert mode
" autocmd TextChangedI * call timer_stop(g:auto_complete_timer) |
"             \ let g:auto_complete_timer = timer_start(100, 'AutoCompleteCallback')
" 
" " Accept completion with Tab or Enter
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" " inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" --- NETRW CONFIGURATION ---

" 1. Basic Visuals
let g:netrw_banner = 0           " Hide the annoying banner
let g:netrw_liststyle = 3        " Tree view (standard file explorer look)
let g:netrw_winsize = 25         " Set width (percentage)

" 2. Behavior (The 'Normal Explorer' feel)
let g:netrw_browse_split = 4     " IMPORTANT: Open files in the previous window, not the sidebar
let g:netrw_altv = 1             " Split to the right (so explorer is on the left)
let g:netrw_chk_dir = 0          " Prevent netrw from checking if directory is remote (speeds up load)

" 3. Keep the Root (Project Drawer behavior)
" This prevents netrw from changing your project root when you navigate directories
let g:netrw_keepdir = 0
" Use the command that actually behaves like a toggle sidebar
noremap <silent> <leader>h :Lexplore<CR>
