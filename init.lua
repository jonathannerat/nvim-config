require "user.vim"
require "user.filetypes"
require "user.commands"
require "user.mappings"

require("user.rocks").setup(function()
   vim.cmd.colorscheme(require "user.option" "theme")
end)
