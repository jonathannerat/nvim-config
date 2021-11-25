local function add_to_path(path)
	if not string.match(";" .. package.path .. ";", ";" .. path .. ";") then
		package.path = path .. ";" .. package.path
	end
end

add_to_path "./lua/?.lua"
add_to_path "./lua/?/init.lua"

local custom = require "my.custom"

if custom.pre then
	custom.pre()
end

require("my.options").setup()
require "my.plugins"
require("my.mappings").setup()

if custom.post then
	custom.post()
end
