local options = require "user.options"

return {
   load = {
      ["core.defaults"] = {},
      ["core.completion"] = {
         config = { engine = "nvim-cmp" },
      },
      ["core.concealer"] = {},
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
}
