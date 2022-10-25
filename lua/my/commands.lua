local function command(name, rhs)
   vim.api.nvim_create_user_command(name, rhs, {})
end

local function lua_command(name, lua_expr)
   command(name, ":lua " .. lua_expr)
end

lua_command("LuasnipEdit", [[require("luasnip.loaders.from_lua").edit_snippet_files()]])

local function lua_playground()
   local output = io.popen("mktemp /tmp/lua_playground.XXXXXX.lua", "r")
   local filename = output ~= nil and output:read "*a" or nil

   if filename then
      vim.cmd("tabnew " .. filename)
   else
      vim.notify("Error creating file with mktemp", vim.log.levels.ERROR)
   end
end

command("LuaPlayground", lua_playground)

vim.api.nvim_create_autocmd("FileType", {
   pattern = { "html", "css", "blade", "vue" },
   command = "EmmetInstall",
})

vim.api.nvim_create_autocmd("BufWritePost", {
   pattern = { "/tmp/lua_playground.*.lua" },
   command = "luafile %",
})

local config_dir = (os.getenv "XDG_CONFIG_HOME") or (os.getenv "HOME" .. "/.config")

-- Reload sxhkd daemon
vim.api.nvim_create_autocmd("BufWritePost", {
   pattern = { config_dir .. "/sxhkd/sxhkdrc" },
   callback = function()
      io.popen('pkill -USR1 sxhkd')
      vim.notify('sxhkd daemon reloaded!')
   end
})

-- Set options for documents
vim.api.nvim_create_autocmd("FileType", {
   pattern = { "markdown", "norg", "tex" },
   command = "set tw=80 spell"
})
