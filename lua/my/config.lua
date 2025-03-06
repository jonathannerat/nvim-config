local home_dir = os.getenv "HOME"

return {
   ui = {
       theme = "default",
       colorscheme = "default",
       colors = {
         -- based on neovim's habamax theme
         bg = "#202020",
         bg_dark = "#1d1d1d",
         bg_light = "#2c2c2c",
         fg = "#bcbcbc",
         fg_dark = "#9e9e9e",

         red = "#af5f5f",
         green = "#5faf5f",
         yellow =  "#af875f",
         blue = "#5f87af",
         magenta = "#af87af",
         cyan = "#5f8787",
         white = "#9e9e9e",
         orange =  "#af875f",
         violet =  "#af87af",

         diag_error = "#af5f5f",
         diag_warn = "#af875f",
         diag_info = "#5f87af",
         diag_hint = "#5f8787",

         git_add = "#5faf5f",
         git_del = "#af5f5f",
         git_change = "#af875f",
      }
   },
   lsp = {
      ensure_installed = { "bashls", "jsonls", "lua_ls" },
      servers = {},
   },
   cmd = {
      find_files = { "find", "-type", "f", "-not", "-path", "*/.*" },
      find_files_hidden = { "find", "-type", "f" },
      find_files_vcs = { "find", "-type", "f" },
      find_files_all = { "find", "-type", "f" },
      peek_browser = "browser",
   },
   vim = {
       textwidth = 0,
       tabwidth = 8,
       timeoutlen = 1000,
   },
   dirs = {
      nvim_config = vim.fn.stdpath "config",
      nvim_plugins = home_dir,
      notebook = vim.fs.joinpath(home_dir, "Notebook")
   },
}
