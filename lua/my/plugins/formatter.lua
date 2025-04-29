local shell_format = require("formatter.filetypes.sh").shfmt

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

require("formatter").setup {
   filetype = {
      blade = {
         function()
            return require "formatter.defaults.prettier" "blade"
         end,
      },
      c = { clike_format },
      cpp = { clike_format },
      fennel = { stdin_fmt("fnlfmt", { "-" }) },
      go = { require("formatter.filetypes.go").gofmt },
      haskell = { stdin_fmt "ormolu" },
      html = { require("formatter.filetypes.html").prettier },
      javascript = { require("formatter.filetypes.javascript").prettier },
      json = { require("formatter.filetypes.json").jq },
      jsonc = { require("formatter.filetypes.json").jq },
      lua = { require("formatter.filetypes.lua").stylua },
      php = { require("formatter.filetypes.php").php_cs_fixer, stdin_fmt "pint-stdin" },
      python = { require("formatter.filetypes.python").black },
      ruby = { require("formatter.filetypes.ruby").rubocop },
      rust = { require("formatter.filetypes.rust").rustfmt },
      scss = { require("formatter.filetypes.css").prettier },
      sh = { shell_format },
      tex = { stdin_fmt("latexindent", { [[-y="defaultIndent:'  '"]] }) },
      vue = { require("formatter.filetypes.vue").prettier },
      zsh = { shell_format },
      ["*"] = {
         require("formatter.filetypes.any").substitute_trailing_whitespace,
      },
   },
}
