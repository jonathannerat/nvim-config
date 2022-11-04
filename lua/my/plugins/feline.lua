-- vi:fdm=marker
return {
   setup = function()
      local feline = require "feline"

      local tokyonight_colors = require("tokyonight.colors").setup { style = "night" }

      local theme = { -- {{{
         bg = tokyonight_colors.bg_statusline,
         bg_dark = tokyonight_colors.bg,
         bg_darker = tokyonight_colors.bg_dark,
         bg_light = tokyonight_colors.bg_highlight,
         fg = tokyonight_colors.fg,
         fg_dark = tokyonight_colors.fg_dark,
         fg_darker = tokyonight_colors.fg_gutter,
         yellow = tokyonight_colors.yellow,
         cyan = tokyonight_colors.cyan,
         darkblue = tokyonight_colors.blue0,
         green = tokyonight_colors.green,
         orange = tokyonight_colors.orange,
         violet = tokyonight_colors.purple,
         magenta = tokyonight_colors.magenta,
         blue = tokyonight_colors.blue,
         red = tokyonight_colors.red,
         primary_blue = tokyonight_colors.blue5,
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
                  hl = {
                     fg = "green",
                  },
               },
               {
                  provider = "git_diff_removed",
                  hl = {
                     fg = "red",
                  },
               },
               {
                  provider = "git_diff_changed",
                  hl = {
                     fg = "blue",
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
                  provider = "line_percentage",
                  hl = {
                     fg = "magenta",
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
