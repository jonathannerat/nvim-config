local option = require "user.options"

return {
   { "rebelot/kanagawa.nvim" },

   {
      "loctvl842/monokai-pro.nvim",
      opts = {
         filter = option "variant"
      },
   },

   {
      "goolord/alpha-nvim",
      event = "VimEnter",
      dependencies = "nvim-tree/nvim-web-devicons",
      opts = function()
         return require("alpha.themes.theta").config
      end,
   },

   {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-tree/nvim-web-devicons",
         "MunifTanjim/nui.nvim",
         "s1n7ax/nvim-window-picker",
      },
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
      cmd = "ZenMode",
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

   {
      "rcarriga/nvim-notify",
      opts = {
         stages = "static",
         time_formats = {
            notification = "%H:%M"
         },
      },
      init = function()
         vim.notify = require "notify"
      end,
   },
}
