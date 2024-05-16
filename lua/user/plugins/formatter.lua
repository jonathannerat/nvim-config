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

local function fmtprg(exe, ...)
   local args = { ... }

   return function()
      return {
         exe = exe,
         args = args,
         stdin = true,
      }
   end
end

local shell_format = fmtprg("shfmt", "-i", 2)

local prettier_format = require "formatter.defaults.prettier"

require("formatter").setup {
   filetype = {
      blade = { prettier_format },
      c = { clike_format },
      cpp = { clike_format },
      fennel = fmtprg("fnlfmt", "-"),
      go = { require("formatter.filetypes.go").gofmt },
      java = { require("formatter.filetypes.java").clangformat },
      javascript = { prettier_format },
      json = { prettier_format },
      lua = { require("formatter.filetypes.lua").stylua },
      perl = fmtprg("perltidy", "-ce", "-l=100"),
      php = { prettier_format },
      python = { require("formatter.filetypes.python").black },
      ruby = { require("formatter.filetypes.ruby").rubocop },
      rust = { require("formatter.filetypes.rust").rustfmt },
      sh = { shell_format },
      tex = { require("formatter.filetypes.tex").latexindent },
      toml = { require("formatter.filetypes.toml").taplo },
      vue = { prettier_format },
      zsh = { shell_format },
      ["*"] = {
         require("formatter.filetypes.any").remove_trailing_whitespace,
      },
   },
}

local kmap = vim.keymap.set

kmap("n", "<leader>bf", ":Format<CR>")
kmap("n", "<leader>bF", ":FormatWrite<CR>")
