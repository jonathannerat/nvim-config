local custom = require "my.utils".custom

require "my.options"
require "my.plugins"
require "my.commands"
require "my.mappings"
require "my.highlights"

vim.cmd("colorscheme " .. custom "theme")
