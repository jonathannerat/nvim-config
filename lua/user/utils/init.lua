local M = {}

local custom_opts

function M.custom(key)
   if not custom_opts then
      local has_custom
      has_custom, custom_opts = pcall(function()
         return require "user.custom"
      end)

      if not has_custom then
         custom_opts = require "user.defaults"
      end
   end

   return custom_opts[key]
end

function M.vimcmd(str)
   return ":" .. str .. "<cr>"
end

function M.luacmd(str)
   return ":lua " .. str .. "<cr>"
end

return M
