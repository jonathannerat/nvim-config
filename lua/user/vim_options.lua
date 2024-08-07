--- Set vim option
---@param opt string option name
---@param value any option value
local function set(opt, value)
   if opt:sub(1, 2) == "no" then
      opt = opt:sub(3)
      value = false
   end

   value = value == nil and true or value

   vim.opt[opt] = value
end

local function append(name, value)
   vim.opt[name]:append(value)
end

local tabwidth = 4

-- Options
set("background", "dark")
set("conceallevel", 2)
set("inccommand", "split")
set("laststatus", 3)
set("mouse", "nv")
set("scrolloff", 5)
set("shiftwidth", tabwidth)
set("splitkeep", "cursor")
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

append("completeopt", { "menuone", "noselect" })
append("sessionoptions", { "options", "resize", "winpos", "terminal" })
append("shortmess", "ac")
append("spelllang", { "es", "en" })
append("listchars", {
   tab = "│ ",
   trail = "·",
   extends = "…",
   precedes = "…",
   nbsp = "☠",
})
append("fillchars", {
   eob = "~",
   horiz = "━",
   horizup = "┻",
   horizdown = "┳",
   vert = "┃",
   vertleft = "┨",
   vertright = "┣",
   verthoriz = "╋",
})

-- Globals
vim.g.mapleader = " "
