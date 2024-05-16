-- vi: fdm=marker
local xdgpath = require("user.utils").xdgpath

local autocmd = vim.api.nvim_create_autocmd
local function command(name, cmd)
   return vim.api.nvim_create_user_command(name, cmd, {})
end

-- LuaPlaygroud {{{
-- Command to open lua temp file that's automatically executed on every change
command("LuaPlayground", function()
   local output = io.popen("mktemp /tmp/lua_playground.XXXXXX.lua", "r")
   local filename = output ~= nil and output:read "*a" or nil

   if filename then
      vim.cmd("tabnew " .. filename)
   else
      vim.notify("Error creating file with mktemp", vim.log.levels.ERROR)
   end
end)

autocmd("BufWritePost", {
   pattern = { "/tmp/lua_playground.*.lua" },
   command = "luafile %",
})
-- }}}

-- Reload sxhkd daemon
autocmd("BufWritePost", {
   pattern = { xdgpath "config" .. "/sxhkd/sxhkdrc" },
   callback = function()
      io.popen "pkill -USR1 sxhkd"
      vim.notify "sxhkd daemon reloaded!"
   end,
})

-- Set options for documents
autocmd("FileType", {
   pattern = { "markdown", "norg", "tex" },
   command = "setlocal tw=80 spell",
})

-- Autostart insert mode in terminal
autocmd("TermOpen", {
   pattern = "*",
   command = "startinsert",
})
