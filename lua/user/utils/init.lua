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

--- Split string with separator/pattern
---@param s string string to split
---@param d string separator/pattern used as delimiter
---@param pattern boolean? wether to search `d` as a pattern or not
---@return string[]
function M.split(s, d, pattern)
   local res = {}
   local substart = 1
   local pstart, pend = s:find(d, 1, not pattern)

   while pstart do
      res[#res + 1] = s:sub(substart, pstart - 1)
      substart = pend + 1
      pstart, pend = s:find(d, substart, not pattern)
   end

   res[#res + 1] = s:sub(substart)

   return res
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
