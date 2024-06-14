local M = {}

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

--- Bootstrap a plugin into rtp
---@param opts {url: string, name: string, branch: string}
function M.bootstrap(opts)
   local url = opts.url
   local branch = opts.branch or "main"
   local name = opts.name or url:match "%w+://.+/.+/(.+)"
   name = name:sub(-4) == ".git" and name:sub(1, -5) or name
   local pluginpath = vim.fn.stdpath "data" .. "/lazy/" .. name

   if not vim.loop.fs_stat(pluginpath) then
      vim.fn.system {
         "git",
         "clone",
         "--filter=blob:none",
         url,
         "--branch=" .. branch,
         pluginpath,
      }
   end

   vim.opt.rtp:prepend(pluginpath)
end

return M
