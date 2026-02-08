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

vim.o.clipboard = "unnamedplus"

vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

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

-- Conform formatting command
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

-- leader key combos
vim.api.nvim_set_keymap("n", "<C-h>", ":NvimTreeToggle<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>h", ":NvimTreeToggle<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>f", ":Telescope find_files<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>m", ":Mason<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>l", ":Lazy<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>=", "gg=G", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>p", ":Format<cr>", { silent = true, noremap = true })

--vim.keymap.set("n", "<Leader>p", function()
--   vim.lsp.buf.format { async = true }
--end, { desc = "Format buffer" })


-- transparent background
-- vim.cmd [[ hi! Normal ctermbg=NONE guibg=NONE ]]

require("config.lazy")
