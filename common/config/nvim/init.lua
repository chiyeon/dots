-- local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
-- vim.cmd.source(vimrc)

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

-- disable virtual_text in favor of lsp_lines
vim.diagnostic.config({
   virtual_text = false,
})

vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

vim.api.nvim_set_keymap("n", "<C-h>", ":NvimTreeToggle<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>h", ":NvimTreeToggle<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>f", ":Telescope find_files<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>m", ":Mason<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>l", ":Lazy<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>p", ":%!prettier --stdin-filepath %<CR> --print-width vim.bo.textwidth", { silent = true, noremap = true })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.opt.fillchars = {eob = " "}
plugins = {
   {
      'goolord/alpha-nvim',
      config = function ()
         local dashboard = require("alpha.themes.dashboard")

         dashboard.section.header.val = {
            "",
            "",
            "",
            "       (o_",
            "(o_    //\\",
            "(/)_   V_/_ "
         }

         local new_button = function(shortcut, text, command)
            local button = dashboard.button(shortcut, text, command)
            button.opts.width = 30
            return button
         end

         dashboard.section.buttons.val = {
            new_button("e", "  New file" , ":ene <BAR> startinsert<cr>"),
            new_button("f", "  Find file", ":cd $HOME/Projects/yes | Telescope find_files<cr>"),
            new_button("r", "  Recent files", ":Telescope oldfiles<cr>"),
            new_button("q", "󰗼  Quit", ":qa<cr>")
         }

         dashboard.section.buttons.opts.width = 30;

         dashboard.section.footer.val = "...where fantasy and fun come to life."

         dashboard.opts.opts.noautocmd = true

         require'alpha'.setup(dashboard.opts)
      end,
   },

   {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
         "nvim-tree/nvim-web-devicons",
      },
      config = function()
         require("nvim-tree").setup {}
      end,
   },

   {
      "nvim-lualine/lualine.nvim",
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
         require("lualine").setup()
      end
      
   },

   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function ()
         local configs = require("nvim-treesitter.configs")

         configs.setup({
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "vue", "typescript", "css" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
         })
      end
   },

   { "shaunsingh/seoul256.nvim" },
   { "rebelot/kanagawa.nvim" },
   {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      config = function()
         new_background = "#1E1E24"
         require("catppuccin").setup({
            flavour = "mocha",
            no_italic = true,
            color_overrides = {
               mocha = {
                  base = new_background,
                  mantle = new_background,
                  crust = new_background,
               }
            }
         })
         vim.cmd.colorscheme "catppuccin"
      end
   },

   {
      "folke/which-key.nvim",
      event = "VeryLazy",
      init = function()
         vim.o.timeout = true
         vim.o.timeoutlen = 300
      end,
      opts = {

      }
   },

   {
      "folke/noice.nvim",
      event = "VeryLazy",
      opts = { },
      dependencies = {
         "MunifTanjim/nui.nvim"
      }
   },

   {
      "nvim-telescope/telescope.nvim",
      dependencies = {
         "nvim-lua/plenary.nvim"
      },
   },

   {
      'romgrk/barbar.nvim',
      dependencies = {
         'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
         'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
      },
      init = function() vim.g.barbar_auto_setup = false end,
      opts = {
         auto_hide = 1
         -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
         -- animation = true,
         -- insert_at_start = true,
         -- …etc.
      },
      version = '^1.0.0', -- optional: only update when a new 1.x version is released
   },
  
   {
      "williamboman/mason.nvim",
      cmd = "Mason",
      build = ":MasonUpdate",
      config = function()
         require("mason").setup()
      end
   },

   { 
      "williamboman/mason-lspconfig.nvim",
      config = function()
         require("mason-lspconfig").setup()

         require("mason-lspconfig").setup_handlers {
            function (server_name)
               local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
               require("lspconfig")[server_name].setup({
                  capabilities = lsp_capabilities
               })

            end
         }
      end
   },

   {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
         require("lsp_lines").setup()
         vim.keymap.set("", "<Leader>e", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
      end
   },

   {
      "hrsh7th/nvim-cmp",
      dependencies = {
         "hrsh7th/cmp-nvim-lsp",
         "hrsh7th/cmp-nvim-lua",
         "hrsh7th/cmp-buffer",
         "hrsh7th/cmp-path",
         "hrsh7th/cmp-cmdline",
         "L3MON4D3/LuaSnip",
         "neovim/nvim-lspconfig",
      },
      event = "VeryLazy",
      config = function()
         local cmp = require("cmp")
         local luasnip = require("luasnip")
         vim.opt.completeopt = { "menu", "menuone", "noselect" }

         cmp.setup({
            snippet = {
               expand = function(args)
                  require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
               end,
            },
            window = {
               completion = cmp.config.window.bordered(),
               documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
               ["<C-b>"] = cmp.mapping.scroll_docs(-4),
               ["<C-f>"] = cmp.mapping.scroll_docs(4),
               ["<C-Space>"] = cmp.mapping.complete(),
               ["<C-e>"] = cmp.mapping.abort(),
               ["<Down>"] = cmp.mapping({
                  i = function(fallback)
                     if cmp.visible() then
                        cmp.close()
                     end
                     fallback()
                  end
               }),
               ['<Up>'] = cmp.mapping({
                 i = function(fallback)
                   if cmp.visible() then
                     cmp.close()
                   end
                   fallback()
                 end
               }),
               ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
               ["<Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.select_next_item()
                  elseif luasnip.expand_or_jumpable() then
                     luasnip.expand_or_jump()
                  else
                     fallback()
                  end
               end, {"i", "s"}),

               ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.select_prev_item()
                  elseif luasnip.jumpable(-1) then
                     luasnip.jump(-1)
                  else
                     fallback()
                  end
               end, {"i", "s"}),
            }),
            sources = cmp.config.sources({
               { name = "nvim_lsp" },
               { name = "nvim_lua" },
               { name = "luasnips" }, -- For luasnip users.
               -- { name = "orgmode" },
            }, {
               { name = "buffer" },
               { name = "path" },
            }),
         })

         cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
               { name = "path" },
            }, {
               { name = "cmdline" },
            }),
         }) 
      end
   }
}
require("lazy").setup(plugins)
--vim.cmd[[colorscheme catppuccin-mocha]]
--vim.cmd[[highlight Normal guibg=none guifg=none]]
