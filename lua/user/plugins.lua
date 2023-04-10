return {
   { -- Organization tool (note taking / todo lists / etc.)
      "nvim-neorg/neorg",
      dependencies = "nvim-lua/plenary.nvim",
      build = ":Neorg sync-parsers",
      ft = "norg",
      cmd = "Neorg",
      opts = {
         load = {
            ["core.defaults"] = {},
            ["core.norg.concealer"] = {},
            ["core.keybinds"] = {
               config = {
                  default_keybinds = true,
               },
            },
            ["core.norg.dirman"] = {
               config = {
                  workspaces = {
                     notes = "~/notebook/",
                  },
                  autochdir = true,
               },
            },
            ["core.norg.completion"] = {
               config = { engine = "nvim-cmp" },
            },
         },
      },
   },

   { -- Preview color #aaaaaa
      "NvChad/nvim-colorizer.lua",
      cmd = "ColorizerToggle",
      config = true,
   },

   {
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
      init = function()
         vim.g.startuptime_tries = 10
      end,
   },
}
