return {
   "hrsh7th/nvim-cmp",
   dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "l3mon4d3/luasnip",
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
               require("luasnip").lsp_expand(args.body) -- for `luasnip` users.
            end,
         },
         window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
         },
         mapping = cmp.mapping.preset.insert({
            ["<c-b>"] = cmp.mapping.scroll_docs(-4),
            ["<c-f>"] = cmp.mapping.scroll_docs(4),
            ["<c-space>"] = cmp.mapping.complete(),
            ["<c-e>"] = cmp.mapping.abort(),
            ["<down>"] = cmp.mapping({
               i = function(fallback)
                  if cmp.visible() then
                     cmp.close()
                  end
                  fallback()
               end
            }),
            ['<up>'] = cmp.mapping({
               i = function(fallback)
                  if cmp.visible() then
                     cmp.close()
                  end
                  fallback()
               end
            }),
            ["<cr>"] = cmp.mapping.confirm({ select = false }), -- accept currently selected item. set `select` to `false` to only confirm explicitly selected items.
            ["<tab>"] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_next_item()
               elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
               else
                  fallback()
               end
            end, {"i", "s"}),

            ["<s-tab>"] = cmp.mapping(function(fallback)
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
            { name = "luasnips" }, -- for luasnip users.
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

