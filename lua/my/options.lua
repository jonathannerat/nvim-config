local function set(opt, value)
   if string.sub(opt, 1, 2) == "no" then
      opt = string.sub(opt, 3)
      value = false
   end

   value = value == nil and true or value
   vim.o[opt] = value
end

local function setg(opt, value)
   vim.g[opt] = value
end

-- Options {{{
local tabwidth = 4
local textwidth = 80

set("background", "dark")
set("completeopt", "menuone,noselect")
set("conceallevel", 2)
set("fillchars", "eob:~")
set("inccommand", "split")
set("listchars", "tab:│ ,trail:·,extends:…,precedes:…,nbsp:☠")
set("scrolloff", 5)
set("shiftwidth", tabwidth)
set("shortmess", vim.o.shortmess .. "ac")
set("spelllang", "es,en")
set("tabstop", tabwidth)
set("timeoutlen", 300)

set "copyindent"
set "cursorline"
set "expandtab"
set "hidden"
set "ignorecase"
set "lazyredraw"
set "linebreak"
set "list"
set "number"
set "preserveindent"
set "relativenumber"
set "showmatch"
set "smartcase"
set "splitbelow"
set "splitright"
set "termguicolors"
set "undofile"
set "wrap"

set "noautoindent"
set "nobackup"
set "noshowmode"
set "noswapfile"
set "nowritebackup"

vim.opt.sessionoptions:append { "options", "resize", "winpos", "terminal" }
-- }}}

-- Globals {{{
setg("pandoc#formatting#mode", "h")
setg("pandoc#formatting#textwidth", textwidth)
setg("tokyonight_style", "night")
setg("mapleader", " ")
setg("mkdp_echo_preview_url", 1)
setg("mkdp_open_to_the_world", 1)
setg("mkdp_port", 8007)
setg("onedark_config", { style = "warmer" })
setg("tex_conceal", "adbmg")
setg("tex_flavor", "latex")
setg("firenvim_config", {
   localSettings = {
      [".*"] = { cmdline = "neovim", takeover = "never" },
   },
})
setg("vimtex_compiler_latexmk", {
   build_dir = "build",
   callback = 1,
   continuous = 1,
   executable = "latexmk",
   options = { "-verbose", "-file-line-error", "-synctex=1", "-interaction=nonstopmode" },
})
setg("user_emmet_mode", "in")
setg("user_emmet_install_global", 0)
-- }}}
