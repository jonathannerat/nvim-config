local utils = require "user.utils"
local vimcmd = utils.vimcmd
local luacmd = utils.luacmd

return {
   { "rebelot/kanagawa.nvim", priority = 1000 },

   {
      "nvim-tree/nvim-web-devicons",
      lazy = true,
   },

   {
      "goolord/alpha-nvim",
      event = "VimEnter",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
         local config = require("alpha.themes.startify").config

         require("alpha").setup(config)
      end,
   },

   {
      "nvim-tree/nvim-tree.lua",
      config = true,
      keys = {
         { "<C-n>", vimcmd "NvimTreeToggle" },
         { "<M-e>", vimcmd "NvimTreeFindFileToggle" },
      }
   },

   {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      tag = "0.1.1",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-telescope/telescope-live-grep-args.nvim",
         { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
      config = function()
         local telescope = require "telescope"
         local config = require "user.plugins.config.telescope"

         telescope.setup(config)

         for extension, _ in pairs(config.extensions) do
            telescope.load_extension(extension)
         end
      end,
      keys = {
         { "<leader>fb", vimcmd "Telescope buffers", silent = true },
         { "<leader>ff", vimcmd "Telescope find_files find_command=fd,-t,f,-t,l previewer=false layout={width=0.6}" },
         { "<leader>fh", vimcmd "Telescope help_tags" },
         { "<leader>fm", vimcmd "Telescope man_pages" },
         { "<leader>fo", vimcmd "Telescope oldfiles" },
         { "<leader>fr", vimcmd "Telescope resume" },
         { "<leader>ft", vimcmd "Telescope treesitter" },
         {
            "<leader>fF",
            vimcmd "Telescope find_files find_command=fd,-t,f,-t,l,-H,--no-ignore-vcs previewer=false layout={width=0.6}",
         },
         {
            "<leader>fl",
            function()
               require("telescope").extensions.live_grep_args.live_grep_args {
                  layout_strategy = "vertical",
                  layout_config = { prompt_position = "top", mirror = true },
               }
            end,
         },
      },
   },
}
