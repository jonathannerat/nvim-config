local function command(name, rhs)
   vim.api.nvim_create_user_command(name, rhs, {})
end

local function lua_command(name, lua_expr)
   command(name, ":lua " .. lua_expr)
end

lua_command("LuasnipEdit", [[require("luasnip.loaders.from_lua").edit_snippet_files()]])

local function lua_playground()
   local output = io.popen("mktemp /tmp/lua_playground.XXXXXX.lua", "r")
   local filename = output ~= nil and output:read("*a") or nil

   if filename then
      vim.cmd("tabnew " .. filename)
   else
      print("Error creating file with mktemp")
   end
end

command("LuaPlayground", lua_playground)

vim.api.nvim_create_autocmd("FileType", {
   pattern = {'html', 'css', 'blade', 'vue'},
   command = "EmmetInstall",
   group = vim.api.nvim_create_augroup("emmet_on_filetypes", {})
})

vim.api.nvim_create_autocmd("BufWritePost", {
   pattern = {'/tmp/lua_playground.*.lua'},
   command = "luafile %",
   group = vim.api.nvim_create_augroup("lua_playground", {})
})
