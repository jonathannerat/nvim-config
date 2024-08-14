local M = {}

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

--- Get XDG Standard directories
---@param name "config" | "data" | "cache"
---@param ... string
function M.xdgdir(name, ...)
   local home = os.getenv "HOME"
   local dir

   if name == "config" then
      dir = os.getenv "XDG_CONFIG_HOME" or vim.fs.joinpath(home, '.config')
   elseif name == "data" then
      dir = os.getenv "XDG_DATA_HOME" or vim.fs.joinpath(home, '.local', 'share')
   elseif name == "cache" then
      dir = os.getenv "XDG_CACHE_HOME" or vim.fs.joinpath(home, '.cache')
   end

   if #({...}) > 0 then
      dir = vim.fs.joinpath(dir, ...)
   end

   return dir
end

return M
