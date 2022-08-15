local function command(name, rhs)
   vim.api.nvim_create_user_command(name, rhs, {})
end

local function lua_command(name, lua_expr)
   command(name, ":lua " .. lua_expr)
end

lua_command("LuasnipEdit", [[require("luasnip.loaders.from_lua").edit_snippet_files()]])
