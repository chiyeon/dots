-- basic vim stuff
vim.o.number = true
vim.o.wrap = true
vim.o.mouse = 'a'
vim.o.showmatch = true
vim.o.ruler = true
vim.o.visualbell = false
vim.o.spell = true 
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
--vim.o.synmaxcol = 30

vim.o.syntax = 'enable'

vim.o.tabstop = 3
vim.o.expandtab = true
vim.o.shiftwidth = 3
vim.o.softtabstop = 3

vim.o.autoindent = true
vim.o.smartindent = true
vim.o.smarttab = true

vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true

vim.o.linebreak = true
vim.o.encoding = 'utf-8'
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.laststatus = 2
vim.o.wildmenu = true
vim.o.title = true

vim.o.dir = '~/.cache/vim'
vim.o.backspace = 'indent,eol,start'
vim.o.history = 1000
--vim.o.confirm = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.fillchars = {eob = " "}

-- disable virtual_text in favor of lsp_lines
vim.diagnostic.config({
   virtual_text = false,
})

-- setting leader key to space
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

-- leader key combos
vim.api.nvim_set_keymap("n", "<C-h>", ":NvimTreeToggle<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>h", ":NvimTreeToggle<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>f", ":Telescope find_files<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>m", ":Mason<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>l", ":Lazy<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>p", "=gg", { silent = true, noremap = true })


-- transparent background
-- vim.cmd [[ hi! Normal ctermbg=NONE guibg=NONE ]]

require("config.lazy")
