local Mapper = require "user.utils.mapper"
local vimcmd = require("user.utils").vimcmd

local api = vim.api
local map = Mapper:new()

map:mode("normal", function(m)
   m:with_options({ silent = true, noremap = true }, {
      ["g<"] = vimcmd "tabmove-",
      ["g>"] = vimcmd "tabmove+",
      ["<c-w>m"] = "<c-w>_<c-w>|",
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

-- Toggle bottom term
local termbuf, termwin
vim.keymap.set({ "n", "t" }, "<M-t>", function()
   local tabpage = api.nvim_get_current_tabpage()
   local win_in_tab = table.find(api.nvim_tabpage_list_wins(tabpage), termwin)

   if termwin then -- term is open in some window
      api.nvim_win_close(termwin, false)

      if win_in_tab then
         termwin = nil
      end
   end

   if not win_in_tab then
      vim.cmd "botright split"
      vim.cmd "resize 10"
      termwin = api.nvim_get_current_win()

      if not termbuf then
         vim.cmd "terminal"
         termbuf = api.nvim_get_current_buf()
      end

      api.nvim_win_set_buf(termwin, termbuf)
   end
end)
