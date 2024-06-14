local default_opts = require "user.options.defaults"
local has_custom, custom_opts = pcall(require, "user.options.custom")

return function(key, default)
   local keys = vim.split(key, ".", { plain = true })
   local value = vim.tbl_get(default_opts, unpack(keys))
   local option = value ~= nil and value or default

   if has_custom then
      value = vim.tbl_get(custom_opts, unpack(keys))
      option = value ~= nil and value or option
   end

   return option
end

