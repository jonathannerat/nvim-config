local options = require "user.options"

return {
   {
      "nvim-neorg/neorg",
      lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
      version = "*", -- Pin Neorg to the latest stable release
      opts = {
         load = {
            ["core.defaults"] = {},
            ["core.concealer"] = {},
            ["core.completion"] = {
               config = { engine = "nvim-cmp" },
            },
            ["core.dirman"] = {
               config = {
                  default_workspace = "notes",
                  workspaces = {
                     notes = options "dirs.notebook",
                  },
               },
            },
            ["core.export"] = {},
         },
      },
   },

   { -- Preview color #aaaaaa
      "norcalli/nvim-colorizer.lua",
      opts = {
         filetypes = { "css", "sass" },
      },
   },
}
