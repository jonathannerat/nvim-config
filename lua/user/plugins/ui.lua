local utils = require "user.utils"
local vimcmd = utils.vimcmd
local silent = utils.silent
local options = require "user.options"

local find_files_cmd = vim.iter(options "cmd.find_files"):join ","
local find_all_files_cmd = vim.iter(options "cmd.find_all_files"):join ","

return {
   { "rebelot/kanagawa.nvim", priority = 1000 },

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
      "nvim-neo-tree/neo-tree.nvim",
      opts = {
         window = {
            mappings = {
               ["<c-v>"] = "vsplit_with_window_picker",
               ["<c-x>"] = "split_with_window_picker",
               ["<space>"] = "noop",
               S = "noop",
               c = {
                  "copy",
                  config = {
                     show_path = "relative",
                  },
               },
               m = {
                  "move",
                  config = {
                     show_path = "relative",
                  },
               },
               o = "toggle_node",
               s = {
                  function(state)
                     local opener = "xdg-open"

                     if vim.fn.has "macunix" == 1 then
                        opener = "open"
                     elseif vim.fn.has "win32" == 1 then
                        opener = "start"
                     end

                     local node = state.tree:get_node()
                     os.execute(("%s '%s'"):format(opener, node.path))
                  end,
                  desc = "open with system",
               },
               v = "open_vsplit",
               x = "open_split",
            },
         },
      },
      branch = "v3.x",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-tree/nvim-web-devicons",
         "MunifTanjim/nui.nvim",
         "s1n7ax/nvim-window-picker",
      },
      keys = silent {
         { "<M-e>", vimcmd "Neotree filesystem toggle" },
         { "<M-f>", vimcmd "Neotree filesystem reveal" },
      },
   },

   {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
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
      keys = silent {
         { "<leader>fb", vimcmd "Telescope buffers" },
         {
            "<leader>ff",
            vimcmd("Telescope find_files layout_config={preview_cutoff=120} find_command=" .. find_files_cmd),
         },
         { "<leader>fh", vimcmd "Telescope help_tags" },
         { "<leader>fm", vimcmd "Telescope man_pages" },
         { "<leader>fo", vimcmd "Telescope oldfiles" },
         { "<leader>fr", vimcmd "Telescope resume" },
         { "<leader>ft", vimcmd "Telescope treesitter" },
         {
            "<leader>fF",
            vimcmd("Telescope find_files layout_config={preview_cutoff=120} find_command=" .. find_all_files_cmd),
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

   {
      "rebelot/heirline.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
      opts = function()
         return require "user.plugins.config.heirline"
      end,
   },

   {
      "folke/zen-mode.nvim",
      opts = {
         options = {
            enabled = true,
            ruler = false, -- disables the ruler text in the cmd line area
            showcmd = false, -- disables the command in the last line of the screen
         },
         plugins = {
            tmux = { enabled = true },
         },
      },
   },

   { "stevearc/dressing.nvim", config = true },
}
