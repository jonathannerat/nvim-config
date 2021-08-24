local function add_to_path(path)
	if not string.match(";" .. package.path .. ";", ";" .. path .. ";") then
		package.path = path .. ";" .. package.path
	end
end

add_to_path "./lua/?.lua"
add_to_path "./lua/?/init.lua"

require("my.custom").pre()

require("my.options").setup()
require("my.plugins").setup()
require("my.mappings").setup()

require("my.custom").post()
