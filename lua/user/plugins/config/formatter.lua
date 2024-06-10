local function get_filename()
   return vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
end

local clike_format = function()
   return {
      exe = "clang-format",
      args = { "--assume-filename", get_filename() },
      stdin = true,
      cwd = vim.fn.expand "%:p:h",
   }
end

local shell_format = function()
   return {
      exe = "shfmt",
      args = { "-i", 2 },
      stdin = true,
   }
end

local prettier_format = require "formatter.defaults.prettier"

return {
   filetype = {
      blade = { prettier_format },
      c = { clike_format },
      cpp = { clike_format },
      lua = { require("formatter.filetypes.lua").stylua },
      python = { require("formatter.filetypes.python").black },
      ruby = {
         require("formatter.filetypes.ruby").rubocop,
      },
      rust = {
         function()
            return {
               exe = "rustfmt",
               args = { "--emit=stdout" },
               stdin = true,
            }
         end,
      },
      sh = { shell_format },
      zsh = { shell_format },
      haskell = {
         function()
            return {
               exe = "ormolu",
               stdin = true,
            }
         end,
      },
      javascript = {
         prettier_format,
      },
      vue = {
         prettier_format,
      },
      php = {
         function ()
            return {
               exe = "pint-stdin",
               stdin = true,
            }
         end
      },
      json = {
         prettier_format,
      },
      tex = {
         function()
            return {
               exe = "latexindent",
               args = {
                  [[-y="defaultIndent:'  '"]],
               },
               stdin = true,
            }
         end,
      },
      go = {
         require("formatter.filetypes.go").gofmt,
      },
      java = {
         function()
            return {
               exe = "clang-format",
               args = { "--style=Google", "--assume-filename=" .. get_filename() },
               stdin = true,
            }
         end,
      },
      fennel = {
         function()
            return {
               exe = "fnlfmt",
               args = { "-" },
               stdin = true,
            }
         end,
      },
      html = { prettier_format },
      ["*"] = {
         require("formatter.filetypes.any").remove_trailing_whitespace,
      },
   },
}
