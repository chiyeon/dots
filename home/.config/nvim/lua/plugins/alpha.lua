return {
   "goolord/alpha-nvim",
   config = function ()
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
         "",
         "",
         " (\\/)     \\/      ()H()    |\\ /|",
         "( .. )  (  . >   ( .. )  ?( X. )",
         "(\")(\")  \\|/\\|/  (\")(\")\\  (')(') ",
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

}
