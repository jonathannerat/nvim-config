local function add_to_path(path)
   if not string.match(";" .. package.path .. ";", ";" .. path .. ";") then
      package.path = path .. ";" .. package.path
   end
end

add_to_path "./lua/?.lua"
add_to_path "./lua/?/init.lua"

local custom = require("my.functions").custom
local f = require "my.util.functions"

require "my.options"
require "my.plugins"
require "my.commands"
require("my.mappings").setup()

f.vimexec([[colorscheme ${theme}]], {
   theme = custom "theme",
})
