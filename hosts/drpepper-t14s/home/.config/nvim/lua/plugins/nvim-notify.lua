return {
   "rcarriga/nvim-notify",
   config = function()
      require("notify").setup({
         top_down = false,
         render = "compact",
         background_colour = "#000000"
      })
   end
}
