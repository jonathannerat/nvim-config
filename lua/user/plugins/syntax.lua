-- Syntax highlighting for additional languages

return {
   { "tridactyl/vim-tridactyl", ft = "tridactyl" },

   { "jwalton512/vim-blade", ft = "blade" },

   { "aklt/plantuml-syntax", ft = "plantuml" },

   {
      "jpalardy/vim-slime",
      ft = "lisp",
      init = function ()
         if os.getenv("TMUX") then
            vim.g.slime_target = "tmux"
            vim.g.slime_paste_file = vim.fn.tempname()
            vim.g.slime_default_config = {
               socket_name = "default",
               target_pane = "{last}"
            }
         else
            vim.g.slime_target = "neovim"
         end
      end
   },

   { "HiPhish/info.vim", cmd = "Info" }, -- Info files
}
