local utils = require "user.utils"
local vimcmd = utils.vimcmd
local luacmd = utils.luacmd
local silent = utils.silent

return {
   { -- LaTeX integration
      "lervag/vimtex",
      ft = { "tex", "latex" },
      init = function()
         vim.g.vimtex_view_method = "zathura"
         vim.g.vimtex_compiler_latexmk = {
            out_dir = ".",
            aux_dir = "build",
         }
         vim.g.tex_conceal = "adbmg"
         vim.g.tex_flavor = "latex"
      end,
   },

   { -- Git IDE
      "tpope/vim-fugitive",
      cmd = { "G", "Git", "Ggrep", "Glgrep", "Gclog", "Gllog", "Gcd", "Glcd" },
      keys = silent {
         { "<M-g>", function ()
            local cols = vim.opt.columns:get()
            local rows = vim.opt.lines:get()
            local square_threshold = 2.6

            if cols/rows < square_threshold then
               -- more rows than cols ==> tall window ==> normal Git window
               vim.api.nvim_command("Git")
            else
               -- more cols than rows ==> wide window ==> vertical Git window
               vim.api.nvim_command("vert Git | vert res 80")
            end
         end},
         { "<leader>gl", vimcmd "Gclog!" },
      },
   },

   -- Git integration for buffers
   {
      "lewis6991/gitsigns.nvim",
      tag = "release",
      config = true,
   },

   {
      "nvim-neotest/neotest",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-treesitter/nvim-treesitter",
         "antoinemadec/FixCursorHold.nvim",
         "olimorris/neotest-phpunit",
         "haydenmeade/neotest-jest",
      },
      opts = function()
         return {
            adapters = {
               require "neotest-phpunit",
               require "neotest-jest" {
                  jestCommand = "yarn test",
                  cwd = function()
                     return vim.fn.getcwd()
                  end,
               },
            },
         }
      end,
      keys = silent {
         { "<leader>tt", luacmd "require('neotest').run.run()" },
         { "<leader>tf", luacmd "require('neotest').run.run(vim.fn.expand('%'))" },
         { "<leader>to", luacmd "require('neotest').output.open{enter = true, last_run = true}" },
      },
   },

   { -- Markdown Previewer
      "iamcco/markdown-preview.nvim",
      ft = "markdown",
      build = function()
         vim.fn["mkdp#util#install"]()
      end,
      init = function()
         vim.g.mkdp_echo_preview_url = 1
         vim.g.mkdp_open_to_the_world = 1
         vim.g.mkdp_port = 8007
         vim.g.mkdp_refresh_slow = 1
         vim.g.mkdp_theme = "dark"
      end,
      keys = silent {
         { "<leader>mp", vimcmd "MarkdownPreviewToggle" },
      },
   },
}
