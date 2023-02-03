local custom = require "my.utils".custom

require "my.options"
require "my.plugins"
require "my.commands"
require "my.mappings"

vim.cmd("colorscheme " .. custom "theme")
