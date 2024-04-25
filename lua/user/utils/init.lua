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

function M.silent(keybinds)
   local is_single_keybind = true

   for _, keybind in pairs(keybinds) do
      if type(keybind) == "table" then
         keybind.silent = true
         is_single_keybind = false
      end
   end

   if is_single_keybind then
      keybinds.silent = true
   end

   return keybinds
end

function table.find(list, search)
   for i, v in ipairs(list) do
      if v == search then
         return i
      end
   end
end

return M
