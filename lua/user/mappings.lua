local Mapper = require "user.utils.mapper"
local vimcmd = require("user.utils").vimcmd

local map = Mapper:new()

map:mode("normal", function(m)
   m:with_options({ silent = true, noremap = true }, {
      ["g<"] = vimcmd "tabmove-",
      ["g>"] = vimcmd "tabmove+",
      ["<c-t>"] = vimcmd "tabnew",
      ["<leader>Q"] = vimcmd "q!",
      ["<leader>Qa"] = vimcmd "qa!",
      ["<leader>cd"] = vimcmd "lcd %:h",
      ["<leader>hh"] = vimcmd "noh",
      ["<leader>q"] = vimcmd "q",
      ["<leader>qa"] = vimcmd "qa",
      ["<leader>r"] = vimcmd "e %",
      ["<leader>u"] = vimcmd "UltiSnipsEdit",
      ["<leader>w"] = vimcmd "w",
      ["<m-j>"] = ":m .+1<CR>==",
      ["<m-k>"] = ":m .-2<CR>==",
   })

   m:with_silent {
      ["<C-w><C-f>"] = ":vsplit<CR>gf",
   }

   m:with_noremap {
      ["<space>"] = "",
      ["Q"] = "",
   }
end)

map:mode("insert", function(m)
   m:with_options({ silent = true, noremap = true }, {
      ["<m-j>"] = "<esc>:m .+1<CR>==gi",
      ["<m-k>"] = "<esc>:m .-2<CR>==gi",
   })

   m:with_noremap {
      jk = "<esc>",
   }
end)

map:mode("visual", function(m)
   m:with_options({ noremap = true }, {
      ["/"] = "<esc>/\\%V",
      ["?"] = "<esc>?\\%V",
   })
end)

map:with_options({ silent = true, noremap = true }, function(m)
   m:mode("command", {
      ["<c-j>"] = "<down>",
      ["<c-k>"] = "<up>",
   })

   m:mode("terminal", {
      ["<c-m-q>"] = [[<c-\><c-n>]],
   })

   m:mode("visual", {
      ["<m-j>"] = ":m '>+1<cr>gv=gv",
      ["<m-k>"] = ":m '<-2<cr>gv=gv",
   })
end)
