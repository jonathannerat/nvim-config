require "user.utils.keymap" {
   {
      group = { mode = "normal" },
      {
         "<ESC>",
         vim = "nohlsearch",
         desc = "Clear search results",
      },
      {
         "<LEADER>Qa",
         vim = "quitall!",
         desc = "Force quit all",
      },
      {
         "<LEADER>Q",
         vim = "quit!",
         desc = "Force quit",
      },
      {
         "<LEADER>r",
         vim = "e %",
         desc = "Reload current buffer",
      },
      {
         "<C-w>m",
         "<C-w>_<C-w>|",
         desc = "Maximize current window",
      },
      {
         "<M-j>",
         ":m .+1<CR>==",
         desc = "Move current line down",
      },
      {
         "<M-k>",
         ":m .-2<CR>==",
         desc = "Move current line up",
      },
      {
         "g<",
         vim = "tabmove-",
         desc = "Move current tab left",
      },
      {
         "g>",
         vim = "tabmove+",
         desc = "Move current tab right",
      },
      {
         "<LEADER>qa",
         vim = "quitall",
         desc = "Quit all",
      },
      {
         "<LEADER>q",
         vim = "quit",
         desc = "Quit",
      },
      {
         "<LEADER>w",
         vim = "write",
         desc = "Save",
      },
      {
         "<SPACE>",
         disable = true,
         desc = "Disable default <SPACE> mapping",
      },
   },
   {
      group = { mode = "insert" },
      {
         "<M-j>",
         "<ESC>:m .+1<CR>==gi",
         desc = "Move current line down",
      },
      {
         "<M-k>",
         "<ESC>:m .-2<CR>==gi",
         desc = "Move current line up",
      },
      { "jk", "<ESC>" },
   },
   {
      group = { mode = "visual" },
      {
         "/",
         [[<ESC>/\%V]],
         desc = "Forward search inside selected region",
      },
      {
         "?",
         [[<ESC>?\%V]],
         desc = "Backward search inside selected region",
      },
      {
         "<M-j>",
         ":m '>+1<CR>gv=gv",
         desc = "Move selected lines down",
      },
      {
         "<M-k>",
         ":m '<-2<CR>gv=gv",
         desc = "Move selected lines up",
      },
   },
   {
      group = { mode = "command" },
      { "<C-j>", "<DOWN>" },
      { "<C-k>", "<UP>" },
   },
}

local FTerm = require "FTerm"

local lazygit = FTerm:new {
   cmd = "lazygit"
}

vim.keymap.set({"n", "t"}, "<M-g>", function ()
   lazygit:toggle()
end)

vim.keymap.set({"n", "t"}, "<M-t>", FTerm.toggle)
