-- vi:fdm=marker
return {
   setup = function()
      local feline = require "feline"
      local palette = require("kanagawa.colors").setup()

      local theme = { -- {{{
         bg = palette.sumiInk0,
         bg_dark = palette.sumiInk1,
         bg_darker = palette.sumiInk0,
         bg_light = palette.sumiInk2,
         fg = palette.fujiWhite,
         fg_dark = palette.oldWhite,
         fg_darker = palette.oldWhite,
         yellow = palette.carpYellow,
         cyan = palette.waveAqua2,
         darkblue = palette.waveBlue2,
         green = palette.springGreen,
         orange = palette.surimiOrange,
         violet = palette.oniViolet,
         magenta = palette.sakuraPink,
         blue = palette.crystalBlue,
         red = palette.peachRed,
         primary_blue = palette.crystalBlue,
      } -- }}}

      local vi_mode_colors = { -- {{{
         NORMAL = theme.primary_blue,
         OP = theme.primary_blue,
         INSERT = theme.yellow,
         VISUAL = theme.magenta,
         LINES = theme.magenta,
         BLOCK = theme.magenta,
         REPLACE = theme.red,
         ["V-REPLACE"] = theme.red,
         ENTER = theme.cyan,
         MORE = theme.cyan,
         SELECT = theme.orange,
         COMMAND = theme.blue,
         SHELL = theme.green,
         TERM = theme.green,
         NONE = theme.green,
      } -- }}}

      local vi_mode = require "feline.providers.vi_mode"
      local file = require "feline.providers.file"

      local components = { -- {{{
         active = {
            { -- Left,
               {
                  provider = function()
                     return " " .. vi_mode.get_vim_mode() .. " "
                  end,
                  hl = function()
                     return {
                        fg = "bg",
                        bg = vi_mode.get_mode_color(),
                        style = "bold",
                     }
                  end,
               },
               {
                  provider = function(component)
                     local str, icon = file.file_info(component, {})
                     return str .. " ", icon
                  end,
                  hl = {
                     fg = "primary_blue",
                     bg = "bg_light",
                  },
                  left_sep = {
                     str = " ",
                     hl = {
                        fg = "primary_blue",
                        bg = "bg_light",
                     },
                  },
               },
               {
                  provider = "git_branch",
                  left_sep = " ",
                  hl = {
                     fg = "yellow",
                     style = "bold",
                  },
               },
               {
                  provider = "git_diff_added",
                  left_sep = " ",
                  icon = " ",
                  hl = {
                     fg = palette.auntumnGreen,
                  },
               },
               {
                  provider = "git_diff_removed",
                  left_sep = " ",
                  icon = " ",
                  hl = {
                     fg = palette.auntumnRed,
                  },
               },
               {
                  provider = "git_diff_changed",
                  left_sep = " ",
                  icon = " ",
                  hl = {
                     fg = palette.auntumnYellow,
                  },
               },
            },
            { -- Right
               {
                  provider = "file_encoding",
                  icon = " ",
                  enabled = function()
                     return vim.bo.fenc ~= "" and vim.bo.fenc ~= "utf-8"
                  end,
                  hl = {
                     style = "bold",
                  },
                  right_sep = " ",
               },
               {
                  provider = "file_format",
                  enabled = function()
                     return vim.bo.fileformat ~= "" and vim.bo.fileformat ~= "unix"
                  end,
                  icon = function()
                     return ({
                        dos = "",
                        mac = "",
                        unix = "",
                     })[vim.bo.fileformat] .. " "
                  end,
                  right_sep = " ",
               },
               {
                  provider = {
                     name = "position",
                     opts = {
                        format = "{line} {col}"
                     },
                  },
                  hl = {
                     fg = "red",
                  },
                  right_sep = " ",
               },
               {
                  provider = "line_percentage",
                  hl = {
                     fg = "magenta",
                     style = "bold"
                  },
                  right_sep = " ",
               },
               {
                  provider = 'scroll_bar',
                  hl = {
                     fg = 'skyblue',
                     style = 'bold',
                  },
               },
            },
         },
      } -- }}}

      feline.setup {
         theme = theme,
         vi_mode_colors = vi_mode_colors,
         components = components,
         force_inactive = {
            filetypes = {
               "neo-tree",
               "packer",
               "fugitive",
               "fugitiveblame",
            },
         },
      }

      feline.winbar.setup {
         components = {
            active = {
               { -- Left
                  {
                     provider = {
                        name =  "file_info",
                        opts = { type = "relative" },
                     },
                  },
               },
            },
            inactive = {
               { -- Left
                  {
                     provider = {
                        name =  "file_info",
                        opts = { type = "relative" },
                     },
                     hl = {
                        fg = "fg_darker"
                     }
                  },
               },
            },
         },
      }
   end,
}
