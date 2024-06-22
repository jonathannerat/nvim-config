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

return M
