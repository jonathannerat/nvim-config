if os.getenv "TMUX" then
   vim.tbl_extend("force", vim.g, {
      slime_target = "tmux",
      slime_paste_file = vim.fn.tempname(),
      slime_default_config = {
         socket_name = "default",
         target_pane = "{last}",
      },
   })
else
   vim.g.slime_target = "neovim"
end
