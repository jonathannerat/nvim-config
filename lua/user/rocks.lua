local add_to_path = require("user.utils").add_to_path
local join = vim.fs.joinpath
local luarocks_bin = "luarocks"
local rocks_path = join(vim.fn.stdpath "data" --[[@as string]], "rocks")

local function die(msg)
   vim.notify(msg, vim.log.levels.ERROR)
   error(msg)
end

--- Returns installed rocks.nvim version, or nil if it isn't installed
local function get_rocks_version()
   local sc = vim.system({
      luarocks_bin,
      "--lua-version=5.1",
      "--tree=" .. rocks_path,
      "show",
      "--mversion",
      "rocks.nvim",
   }):wait()

   if sc.code == 0 then
      return vim.trim(sc.stdout)
   end
end

--- Tries to setup luarocks/rocks.nvim directories.
--- @return boolean _ wether it's successful or not
local function try_rocks_setup()
   local version = get_rocks_version()

   if not version then
      return false
   end

   vim.g.rocks_nvim = {
      rocks_path = rocks_path,
      luarocks_binary = luarocks_bin,
   }

   add_to_path {
      join(rocks_path, "share", "lua", "5.1", "?.lua"),
      join(rocks_path, "share", "lua", "5.1", "?", "init.lua"),
   }

   add_to_path({
      join(rocks_path, "lib", "lua", "5.1", "?.so"),
      join(rocks_path, "lib64", "lua", "5.1", "?.so"),
   }, "cpath")

   vim.opt.rtp:append(join(rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim", version))

   return true
end

--- Rocks.nvim bootstrapping
---@param callback function to run after ensuring rocks.nvim is correctly setup
local function setup(callback)
   if vim.fn.executable "luarocks" == 0 then
      die "missing luarocks dependency"
   end

   if try_rocks_setup() then
      return callback()
   end

   vim.notify("missing rocks.nvim, installing it", vim.log.levels.WARN)

   -- try to install rocks.nvim
   vim.system({
      luarocks_bin,
      "--lua-version=5.1",
      "--tree=" .. rocks_path,
      "--server='https://nvim-neorocks.github.io/rocks-binaries/'",
      "install",
      "rocks.nvim",
   }):wait()

   if try_rocks_setup() then
      vim.notify "rocks.nvim installed"
      return callback()
   else
      die "failed to install rocks.nvim"
   end
end

return { setup = setup }
