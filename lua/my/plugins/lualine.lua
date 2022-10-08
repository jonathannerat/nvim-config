local M = {}
local custom = require("my.utils").custom

M.config = {
   sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff" },
      lualine_c = {
         "filename",
         "lsp_progress",
      },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
   },
   tabline = {
      lualine_a = {
         {
            "tabs",
            mode = 2,
         },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
   },
   winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
   },
   inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
   },
   options = {
      theme = custom "lualine_theme",
      globalstatus = true,
   },
   extensions = { "nvim-tree", "fugitive", "toggleterm" },
}

M.setup = function()
   require("lualine").setup(M.config)
end

return M
