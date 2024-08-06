local home_dir = os.getenv "HOME"

return {
   theme = "default",
   lsp = {
      ensure_installed = { "bashls", "jsonls", "lua_ls" },
      servers = {},
   },
   cmd = {
      find_files = { "find" },
      find_all_files = { "find" },
   },
   dirs = {
      nvim_config = vim.fn.stdpath "config",
      nvim_plugins = home_dir,
      notebook = vim.fs.joinpath(home_dir, "Notebook")
   },
}

