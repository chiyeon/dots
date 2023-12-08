local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_set_keymap("n", "<C-h>", ":NvimTreeToggle<cr>", {silent = true, noremap = true})

vim.g.UltiSnipsExpandTrigger='<tab>'

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

plugins = {
   {
      'goolord/alpha-nvim',
      config = function ()
         require'alpha'.setup(require'alpha.themes.dashboard'.config)
      end
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
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function () 
         local configs = require("nvim-treesitter.configs")

         configs.setup({
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },  
         })
      end
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
      "neovim/nvim-lspconfig", 
   },

   --[[
   {
      "ms-jpq/coq_nvim",
      dependencies = {
         "neovim/nvim-lspconfig",
         "ms-jpq/coq.artifacts",
      },
      config = function()
         local lspconfig = require("lspconfig")

         local lsps = {
            "pyright",
            "clangd",
            "tsserver"
         }

         for _,lsp in ipairs(lsps)
         do
            lspconfig[lsp].setup(coq.lsp_ensure_capabilities({}))
         end
      end
   }
   ]]--

   {
      "simrat39/rust-tools.nvim",
      config = function()
         local rt = require("rust-tools")

         rt.setup({
            server = {
               on_attach = function(_, bufnr)
                  -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
               end
            }
         })
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
         "SirVer/ultisnips",
         "neovim/nvim-lspconfig",
         "quangnguyen30192/cmp-nvim-ultisnips"
      },

      config = function()
         local cmp = require("cmp")
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
               ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
               { name = "nvim_lsp" },
               { name = "nvim_lua" },
               { name = "ultisnips" }, -- For luasnip users.
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

         local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
         local lspconfig = require("lspconfig")

         local lsps = {
            "pyright",
            "clangd",
            "tsserver",
         }

         for _,lsp in ipairs(lsps)
         do
            lspconfig[lsp].setup({
               capabilities = lsp_capabilities
            })
         end
      end
   }
}

require("lazy").setup(plugins)
--vim.cmd([[COQnow -s]])
