local utils = require "user.utils"
local vimcmd = utils.vimcmd
local luacmd = utils.luacmd

return {
   { -- LaTeX integration
      "lervag/vimtex",
      ft = "latex",
      init = function()
         vim.g.vimtex_view_method = "zathura"
         vim.g.vimtex_compiler_latexmk = {
            build_dir = "build",
            callback = 1,
            continuous = 1,
            executable = "latexmk",
            options = { "-verbose", "-file-line-error", "-synctex=1", "-interaction=nonstopmode" },
         }
         vim.g.tex_conceal = "adbmg"
         vim.g.tex_flavor = "latex"
      end,
   },

   { -- Git IDE
      "tpope/vim-fugitive",
      cmd = { "Git", "G" },
      keys = {
         { "<leader>g", vimcmd "G" }
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
      keys = {
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
      keys = {
         { "<leader>mp", vimcmd "MarkdownPreviewToggle" },
      },
   },
}
