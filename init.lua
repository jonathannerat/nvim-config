local function add_to_path(path)
   if not string.match(";" .. package.path .. ";", ";" .. path .. ";") then
      package.path = path .. ";" .. package.path
   end
end

local custom = require "my.utils".custom

add_to_path "./lua/?.lua"
add_to_path "./lua/?/init.lua"

require "my.options"
require "my.plugins"
require "my.commands"
require "my.mappings"

vim.cmd("colorscheme " .. custom "theme")
