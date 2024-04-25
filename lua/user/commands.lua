local autocmd = vim.api.nvim_create_autocmd
local function command(name, cmd)
   return vim.api.nvim_create_user_command(name, cmd, {})
end

command("LuaPlayground", function()
   local output = io.popen("mktemp /tmp/lua_playground.XXXXXX.lua", "r")
   local filename = output ~= nil and output:read "*a" or nil

   if filename then
      vim.cmd("tabnew " .. filename)
   else
      vim.notify("Error creating file with mktemp", vim.log.levels.ERROR)
   end
end)

autocmd("FileType", {
   pattern = { "html", "css", "blade", "vue" },
   command = "EmmetInstall",
})

autocmd("BufWritePost", {
   pattern = { "/tmp/lua_playground.*.lua" },
   command = "luafile %",
})

-- Reload sxhkd daemon
autocmd("BufWritePost", {
   pattern = { os.getenv "XDG_CONFIG_HOME" .. "/sxhkd/sxhkdrc" },
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

autocmd({ "FileType" }, {
   pattern = { "nasm" },
   command = "set fdm=marker",
})

-- Autostart insert mode in terminal
autocmd("TermOpen", {
   pattern = "*",
   command = "startinsert",
})
