return {
   { -- Organization tool (note taking / todo lists / etc.)
      "nvim-neorg/neorg",
      dependencies = {
         "nvim-lua/plenary.nvim",
         {
            "vhyrro/luarocks.nvim",
            priority = 1000, -- We'd like this plugin to load first out of the rest
            config = true, -- This automatically runs `require("luarocks-nvim").setup()`
         },
      },
      ft = "norg",
      cmd = "Neorg",
      opts = function()
         return require "user.plugins.config.neorg"
      end,
   },

   { -- Preview color #aaaaaa
      "NvChad/nvim-colorizer.lua",
      opts = {
         filetypes = { "css", "sass" },
      },
   },

   {
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
      init = function()
         vim.g.startuptime_tries = 10
      end,
   },
}
