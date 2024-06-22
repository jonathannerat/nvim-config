local shell_format = require("formatter.filetypes.sh").shfmt
local prettier_format = require "formatter.defaults.prettier"

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

local function stdin_fmt(exe, args)
   return function()
      return {
         exe = exe,
         stdin = true,
         args = args,
      }
   end
end

return {
   filetype = {
      blade = { prettier_format },
      c = { clike_format },
      cpp = { clike_format },
      go = { require("formatter.filetypes.go").gofmt },
      html = { prettier_format },
      javascript = { prettier_format },
      json = { require("formatter.filetypes.json").jq },
      jsonc = { require("formatter.filetypes.json").jq },
      lua = { require("formatter.filetypes.lua").stylua },
      python = { require("formatter.filetypes.python").black },
      ruby = { require("formatter.filetypes.ruby").rubocop },
      rust = { require("formatter.filetypes.rust").rustfmt },
      sh = { shell_format },
      vue = { prettier_format },
      zsh = { shell_format },
      fennel = { stdin_fmt("fnlfmt", { "-" }) },
      haskell = { stdin_fmt "ormolu" },
      java = {
         stdin_fmt("clang-format", {
            "--style=Google",
            "--assume-filename=" .. get_filename(),
         }),
      },
      php = { stdin_fmt "pint-stdin" },
      tex = { stdin_fmt("latexindent", { [[-y="defaultIndent:'  '"]] }) },
      ["*"] = {
         require("formatter.filetypes.any").substitute_trailing_whitespace,
      },
   },
}
