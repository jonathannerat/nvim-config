require("neorg").setup {
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
               notes = "~/documents/neorg/",
            },
         },
      },
      ["core.export"] = {},
   },
}
