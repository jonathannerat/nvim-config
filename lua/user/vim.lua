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
set("inccommand", "split")
set("laststatus", 3)
set("mouse", "nv")
set("scrolloff", 3)
set("shiftwidth", tabwidth)
set("tabstop", tabwidth)
set("timeoutlen", 300)

set "copyindent"
set "cursorline"
set "expandtab"
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
set "undofile"

set "noshowmode"
set "noswapfile"

-- append("shortmess", "ac")
append("spelllang", { "es", "en" })
append("listchars", {
    tab = "│ ",
    trail = "·",
    extends = "…",
    precedes = "…",
    nbsp = "󰚌",
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
