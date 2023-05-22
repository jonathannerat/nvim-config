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
            ["core.concealer"] = {},
            ["core.keybinds"] = {
               config = {
                  default_keybinds = true,
               },
            },
            ["core.dirman"] = {
               config = {
                  default_workspace = "notes",
                  workspaces = {
                     notes = "~/notebook/",
                  },
               },
            },
            ["core.completion"] = {
               config = { engine = "nvim-cmp" },
            },
            ["core.export"] = {}
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
