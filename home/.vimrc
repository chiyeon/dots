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
" Native markdown rendering using conceal + syntax + signs
" Requires: +conceal, +syntax, +signs (all present in this vim build)

" Sign for full-line code block background (no text = no sign column)
sign define markdownCodeLine linehl=markdownCodeBlockLine

augroup MarkdownRendering
  autocmd!

  " Enable conceal for markdown files
  " conceallevel=2: hide conceal markers entirely, show cchar replacement
  " concealcursor= (empty): only conceal when cursor is NOT on the line
  autocmd FileType markdown setlocal conceallevel=2
  autocmd FileType markdown setlocal concealcursor=
  autocmd FileType markdown setlocal synmaxcol=500

  " Markdown-specific tab size
  autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2

  " Load our custom markdown syntax overrides
  autocmd FileType markdown call s:MarkdownSetup()

  " Update code block signs + virtual text padding on changes
  autocmd FileType markdown call s:UpdateCodeBlockSigns()
  autocmd BufWritePost,TextChanged,InsertLeave *.md call s:UpdateCodeBlockSigns()

  " Auto bullet/number continuation on Enter
  autocmd FileType markdown inoremap <buffer> <CR> <C-o>:call <SID>MarkdownNewline()<CR>
augroup END

function! s:MarkdownSetup()
  " Clear default markdown syntax to avoid conflicts
  syntax clear

  " Conceal highlight: transparent bg so replacement chars blend in
  highlight Conceal ctermbg=NONE ctermfg=248

  " ===== HEADERS =====
  " H1: white text on colored background
  syntax match markdownH1 /^#\s.\+$/  contains=markdownH1Marker
  syntax match markdownH1Marker /^#\s/ contained conceal
  highlight markdownH1 cterm=bold ctermfg=235 ctermbg=4

  " H2-H6: decreasing intensity, markers concealed
  syntax match markdownH2 /^##\s.\+$/ contains=markdownH2Marker
  syntax match markdownH2Marker /^##\s/ contained conceal
  highlight markdownH2 cterm=bold ctermfg=75

  syntax match markdownH3 /^###\s.\+$/ contains=markdownH3Marker
  syntax match markdownH3Marker /^###\s/ contained conceal
  highlight markdownH3 cterm=bold ctermfg=110

  syntax match markdownH4 /^####\s.\+$/ contains=markdownH4Marker
  syntax match markdownH4Marker /^####\s/ contained conceal
  highlight markdownH4 cterm=bold ctermfg=146

  syntax match markdownH5 /^#####\s.\+$/ contains=markdownH5Marker
  syntax match markdownH5Marker /^#####\s/ contained conceal
  highlight markdownH5 ctermfg=146

  syntax match markdownH6 /^######\s.\+$/ contains=markdownH6Marker
  syntax match markdownH6Marker /^######\s/ contained conceal
  highlight markdownH6 ctermfg=103

  " ===== INLINE FORMATTING =====
  " Bold: **text** or __text__
  syntax region markdownBold matchgroup=markdownBoldMarker start=/\*\*/ end=/\*\*/ concealends oneline
  syntax region markdownBold matchgroup=markdownBoldMarker start=/__/ end=/__/ concealends oneline
  highlight markdownBold cterm=bold ctermfg=white

  " Italic: *text* or _text_ (single)
  syntax region markdownItalic matchgroup=markdownItalicMarker start=/\*\ze[^*]/ end=/\*/ concealends oneline
  syntax region markdownItalic matchgroup=markdownItalicMarker start=/\<_\ze[^_]/ end=/_\>/ concealends oneline
  highlight markdownItalic cterm=italic ctermfg=249

  " Bold+Italic: ***text***
  syntax region markdownBoldItalic matchgroup=markdownBIMarker start=/\*\*\*/ end=/\*\*\*/ concealends oneline
  highlight markdownBoldItalic cterm=bold,italic ctermfg=white

  " Strikethrough: ~~text~~
  syntax region markdownStrike matchgroup=markdownStrikeMarker start=/\~\~/ end=/\~\~/ concealends oneline
  highlight markdownStrike cterm=strikethrough ctermfg=245

  " Underline: <u>text</u> (HTML in markdown)
  syntax region markdownUnderline matchgroup=markdownUnderlineMarker start=/<u>/ end=/<\/u>/ concealends oneline
  highlight markdownUnderline cterm=underline

  " ===== BULLET POINTS =====
  " - items → • (bullet)
  syntax match markdownBullet /^\s*-\s\ze[^\[]/ contains=markdownBulletMarker
  syntax match markdownBulletMarker /^\s*\zs-\ze\s/ contained conceal cchar=•

  " Nested bullets: different symbols per depth
  syntax match markdownBullet2 /^\s\{2,3}-\s/ contains=markdownBulletMarker2
  syntax match markdownBulletMarker2 /^\s\{2,3}\zs-\ze\s/ contained conceal cchar=◦

  syntax match markdownBullet3 /^\s\{4,}-\s/ contains=markdownBulletMarker3
  syntax match markdownBulletMarker3 /^\s\{4,}\zs-\ze\s/ contained conceal cchar=▪

  " * bullets also
  syntax match markdownStarBullet /^\s*\*\s/ contains=markdownStarBulletMarker
  syntax match markdownStarBulletMarker /^\s*\zs\*\ze\s/ contained conceal cchar=•

  " ===== CHECKBOXES =====
  " - [ ] → ☐  (empty checkbox)
  syntax match markdownCheckboxEmpty /^\s*-\s\[.\]\s/ contains=markdownCBEmptyMarker
  syntax match markdownCBEmptyMarker /^\s*\zs-\s\[ \]/ contained conceal cchar=☐

  " - [x] → ☑  (checked checkbox)
  syntax match markdownCheckboxDone /^\s*-\s\[x\]\s/ contains=markdownCBDoneMarker
  syntax match markdownCBDoneMarker /^\s*\zs-\s\[x\]/ contained conceal cchar=☑

  " ===== BLOCKQUOTES =====
  " > text → │ text
  syntax match markdownQuote /^>\s.*$/ contains=markdownQuoteMarker
  syntax match markdownQuoteMarker /^>\ze\s/ contained conceal cchar=│
  highlight markdownQuote ctermfg=245

  " Nested quotes >>
  syntax match markdownQuote2 /^>>\s.*$/ contains=markdownQuoteMarker2
  syntax match markdownQuoteMarker2 /^>>\ze\s/ contained conceal cchar=║
  highlight markdownQuote2 ctermfg=240

  " ===== INLINE CODE =====
  " `code` - backticks become invisible padding (fg matches bg)
  syntax region markdownCode matchgroup=markdownCodeMarker start=/`\ze[^`]/ end=/`/ oneline
  highlight markdownCode ctermfg=green ctermbg=236
  highlight markdownCodeMarker ctermfg=236 ctermbg=236

  " ===== FENCED CODE BLOCKS =====
  " ```lang ... ``` with background (full-line bg via signs, see below)
  syntax region markdownCodeBlock matchgroup=markdownCodeFence start=/^\s*```.*$/ end=/^\s*```\s*$/
  highlight markdownCodeBlock ctermfg=green ctermbg=235
  highlight markdownCodeBlockLine ctermbg=235
  highlight markdownCodeFence ctermfg=235 ctermbg=235

  " ===== HORIZONTAL RULES =====
  " --- or *** or ___ → full line
  syntax match markdownHRule /^\s*\(---\|\*\*\*\|___\)\s*$/ conceal cchar=─

  " ===== LINKS =====
  " [text](url) - show text colored, conceal url part
  syntax region markdownLink matchgroup=markdownLinkDelim start=/\[/ end=/\](.\{-})/ concealends oneline contains=markdownLinkURL
  syntax match markdownLinkURL /(.\{-})/ contained conceal
  highlight markdownLink cterm=underline ctermfg=75
  highlight markdownLinkDelim ctermfg=75

  " ![alt](url) - image links
  syntax match markdownImage /!\[.\{-}\](.\{-})/ contains=markdownImageURL
  syntax match markdownImageURL /\](.\{-})/ contained conceal
  highlight markdownImage ctermfg=214

  " ===== NUMBERED LISTS =====
  syntax match markdownNumbered /^\s*\d\+\.\s/
  highlight markdownNumbered ctermfg=cyan

  " ===== TABLES =====
  " disabling for now - this breaks other rendering
  " Separator row: |---|---| (must be defined first, more specific pattern)
  " syntax match markdownTableSep /^|[\-: |]\+|$/
  " highlight markdownTableSep ctermfg=240

  " All table rows (pipes get colored, content is default)
  " syntax match markdownTableRow /^|.\+|$/ contains=markdownTablePipe,markdownTableSep
  " syntax match markdownTablePipe /|/ contained
  " highlight markdownTablePipe ctermfg=240

  " ===== MISC =====
  " Highlight bare URLs
  syntax match markdownURL /https\?:\/\/[^ \t)\]]*/
  highlight markdownURL cterm=underline ctermfg=75

  " Setup virtual text property types for code block padding
  if !prop_type_get('mdCodePadL', {'bufnr': bufnr('%')})->empty()
    call prop_type_delete('mdCodePadL', {'bufnr': bufnr('%')})
  endif
  if !prop_type_get('mdCodePadR', {'bufnr': bufnr('%')})->empty()
    call prop_type_delete('mdCodePadR', {'bufnr': bufnr('%')})
  endif
  call prop_type_add('mdCodePadL', {'bufnr': bufnr('%'), 'highlight': 'markdownCodeBlockLine'})
  call prop_type_add('mdCodePadR', {'bufnr': bufnr('%'), 'highlight': 'markdownCodeBlockLine'})

endfunction

" Place signs on every line inside fenced code blocks for full-line background
" Also add virtual text padding (1 char left/right) for code block lines
function! s:UpdateCodeBlockSigns()
  sign unplace * group=mdcode

  " Clear old virtual text props
  if prop_type_get('mdCodePadL', {'bufnr': bufnr('%')})->empty()
    return
  endif
  call prop_remove({'type': 'mdCodePadL', 'all': v:true})
  call prop_remove({'type': 'mdCodePadR', 'all': v:true})

  let l:in_block = 0
  let l:id = 1
  for l:lnum in range(1, line('$'))
    let l:line = getline(l:lnum)
    if l:line =~# '^\s*```'
      execute 'sign place ' . l:id . ' line=' . l:lnum . ' name=markdownCodeLine group=mdcode'
      let l:id += 1
      " Left padding on fence lines too
      call prop_add(l:lnum, 1, {'type': 'mdCodePadL', 'text': ' '})
      let l:in_block = !l:in_block
    elseif l:in_block
      execute 'sign place ' . l:id . ' line=' . l:lnum . ' name=markdownCodeLine group=mdcode'
      let l:id += 1
      " Left and right padding
      call prop_add(l:lnum, 1, {'type': 'mdCodePadL', 'text': ' '})
      call prop_add(l:lnum, 0, {'type': 'mdCodePadR', 'text': ' ', 'text_align': 'after'})
    endif
  endfor
endfunction

" Auto-continue bullets and numbered lists on Enter
function! s:MarkdownNewline()
  let l:line = getline('.')
  let l:col = col('.')

  " Checkbox: - [ ] or - [x]
  if l:line =~# '^\s*- \[.\] '
    let l:indent = matchstr(l:line, '^\s*')
    " If the line is just the checkbox with no content, remove it
    if l:line =~# '^\s*- \[.\]\s*$'
      call setline('.', '')
      call cursor(line('.'), 1)
    else
      call append('.', l:indent . '- [ ] ')
      call cursor(line('.') + 1, len(l:indent) + 7)
    endif
    startinsert!
    return
  endif

  " Bullet: - or *
  let l:bullet = matchstr(l:line, '^\s*[\-\*]\s')
  if !empty(l:bullet)
    " If bullet line is empty (just the marker), remove it
    if l:line =~# '^\s*[\-\*]\s*$'
      call setline('.', '')
      call cursor(line('.'), 1)
    else
      call append('.', l:bullet)
      call cursor(line('.') + 1, len(l:bullet) + 1)
    endif
    startinsert!
    return
  endif

  " Numbered list: 1. 2. etc.
  let l:nummatch = matchlist(l:line, '^\(\s*\)\(\d\+\)\.\s')
  if !empty(l:nummatch)
    " If numbered line is empty (just the number), remove it
    if l:line =~# '^\s*\d\+\.\s*$'
      call setline('.', '')
      call cursor(line('.'), 1)
    else
      let l:next = l:nummatch[1] . (str2nr(l:nummatch[2]) + 1) . '. '
      call append('.', l:next)
      call cursor(line('.') + 1, len(l:next) + 1)
    endif
    startinsert!
    return
  endif

  " Default: normal Enter
  execute "normal! a\<CR>"
  startinsert!
endfunction
