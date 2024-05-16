local utils = {}

--- Add directories to package path/cpath
---@param dirs string | string[] directories to add
---@param target? "path" | "cpath"
function utils.add_to_path(dirs, target)
   target = target or "path"
   dirs = type(dirs) == "string" and { dirs } or dirs

   ---@cast dirs string[]
   package[target] = package[target] .. ";" .. table.concat(dirs, ";")
end

local DEFAULT_XDG_DIRS = {
   data = os.getenv "HOME" .. "/.local/share",
   config = os.getenv "HOME" .. "/.config",
   cache = os.getenv "HOME" .. "/.cache",
}

--- Return XDG_***_HOME directory
---@param name "data"|"config"|"cache"
function utils.xdgpath(name)
   local xdgenv = os.getenv("XDG_" .. name:upper() .. "_HOME")

   if xdgenv then
      return xdgenv
   end

   return DEFAULT_XDG_DIRS[name]
end

return utils
