local function add_to_path(path)
	if not string.match(';' .. package.path .. ';', ';' .. path .. ';') then
		package.path = path .. ';' .. package.path
	end
end

add_to_path('./lua/?.lua')
add_to_path('./lua/?/init.lua')
