return {
   { -- LaTeX integration
      "lervag/vimtex",
      ft = { "tex", "latex" },
      init = function()
         vim.g.tex_conceal = "adbmg"
         vim.g.tex_flavor = "latex"
         vim.g.vimtex_view_method = "zathura"
         vim.g.vimtex_compiler_latexmk = {
            out_dir = ".",
            aux_dir = "build",
         }
      end,
   },

   -- Git integration for buffers
   {
      "lewis6991/gitsigns.nvim",
      config = true,
   },

   {
      "nvim-neotest/neotest",
      dependencies = {
         "nvim-neotest/nvim-nio",
         "nvim-lua/plenary.nvim",
         "antoinemadec/FixCursorHold.nvim",
         "nvim-treesitter/nvim-treesitter",
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
   },

   "numToStr/FTerm.nvim",
}
