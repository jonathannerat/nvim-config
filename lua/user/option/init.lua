local default_opts = require "user.option.default"
local custom_opts_available, custom_opts = pcall(require, "user.option.custom")

--- Get custom option, fallback to default
---@param key string
local function custom_option(key)
   local keys = vim.split(key, ".", { plain = true })

   return vim.tbl_get(custom_opts, unpack(keys))
      or vim.tbl_get(default_opts, unpack(keys))
end

--- Get default option
---@param key string
local function default_option(key)
   local keys = vim.split(key, ".", { plain = true })

   return vim.tbl_get(default_opts, unpack(keys))
end

return custom_opts_available and custom_option or default_option
