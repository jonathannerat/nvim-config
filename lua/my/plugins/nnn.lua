return {
   setup = function()
      local builtin = require("nnn").builtin

      require("nnn").setup {
         mappings = {
            { "<C-t>", builtin.open_in_tab }, -- open file(s) in tab
            { "<C-x>", builtin.open_in_split }, -- open file(s) in split
            { "<C-v>", builtin.open_in_vsplit }, -- open file(s) in vertical split
            { "<C-p>", builtin.open_in_preview }, -- open file in preview split keeping nnn focused
         },
      }
   end,
}
