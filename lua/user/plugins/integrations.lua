local utils = require "user.utils"
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

   { "numToStr/FTerm.nvim" }
}
