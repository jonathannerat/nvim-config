vim.keymap.set("n", "<M-g>", function()
   local cols = vim.opt.columns:get()
   local rows = vim.opt.lines:get()
   local square_threshold = 2.6

   if cols / rows < square_threshold then
      -- more rows than cols ==> tall window ==> normal Git window
      vim.api.nvim_command "Git"
   else
      -- more cols than rows ==> wide window ==> vertical Git window
      vim.api.nvim_command "vert Git | vert res 50"
   end
end)
