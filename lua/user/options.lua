local function set(opt, value)
   if string.sub(opt, 1, 2) == "no" then
      opt = string.sub(opt, 3)
      value = false
   end

   value = value == nil and true or value
   vim.o[opt] = value
end

local tabwidth = 4

-- Options
set("background", "dark")
set("completeopt", "menuone,noselect")
set("conceallevel", 2)
set("inccommand", "split")
set("laststatus", 3)
set("listchars", "tab:│ ,trail:·,extends:…,precedes:…,nbsp:☠")
set("mouse", "nv")
set("scrolloff", 5)
set("shiftwidth", tabwidth)
set("shortmess", vim.o.shortmess .. "ac")
set("spelllang", "es,en")
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

vim.opt.sessionoptions:append { "options", "resize", "winpos", "terminal" }
vim.opt.fillchars:append {
   eob = "~",
   horiz = '━',
   horizup = '┻',
   horizdown = '┳',
   vert = '┃',
   vertleft = '┨',
   vertright = '┣',
   verthoriz = '╋',
}

-- Globals
vim.g.mapleader = " "
