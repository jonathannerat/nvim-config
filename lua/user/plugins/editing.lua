local utils = require "user.utils"
local vimcmd = utils.vimcmd
local silent = utils.silent

return {
   { -- TreeSitter support
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
         local config = require "user.plugins.config.treesitter"
         local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

         for parser, parser_config in pairs(config.parsers) do
            parser_configs[parser] = parser_config
         end

         require("nvim-treesitter.configs").setup(config.opts)
      end,
   },

   { -- Syntax aware text-objects
      "nvim-treesitter/nvim-treesitter-textobjects",
      dependencies = "nvim-treesitter/nvim-treesitter",
   },

   { -- Context aware comment string (injections)
      "JoosepAlviste/nvim-ts-context-commentstring",
      dependencies = "nvim-treesitter/nvim-treesitter",
   },

   { -- TreeSitter node viewer
      "nvim-treesitter/playground",
      dependencies = "nvim-treesitter/nvim-treesitter",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
      build = ":TSUpdate query",
   },

   { -- Show cursor context block (class / function / if / for / etc.)
      "nvim-treesitter/nvim-treesitter-context",
      dependencies = "nvim-treesitter/nvim-treesitter",
      opts = {
         enabled = true,
         max_lines = 3,
      },
   },

   {
      "L3MON4D3/LuaSnip",
      version = "1.*",
      build = "make install_jsregexp",
      dependencies = {
         "rafamadriz/friendly-snippets", -- Collection of snippets
      },
      config = function()
         local luasnip = require "luasnip"
         require("luasnip.loaders.from_lua").load {
            paths = vim.fn.stdpath "config" .. "/lua/snippets",
         }

         luasnip.filetype_extend("cpp", { "c" })
         luasnip.filetype_extend("pandoc", { "html", "tex" })

         require("luasnip.loaders.from_vscode").lazy_load()
      end,
   },

   {
      "windwp/nvim-autopairs",
      opts = {
         disable_filetype = { "TelescopePrompt" },
      },
   },

   "gpanders/editorconfig.nvim",

   { "numToStr/Comment.nvim", config = true },

   {
      "kylechui/nvim-surround",
      version = "*",
      config = true,
   },

   { -- File formatting
      "mhartington/formatter.nvim",
      cmd = { "Format", "FormatWrite" },
      opts = function()
         return require "user.plugins.config.formatter"
      end,
      keys = silent {
         { "<leader>bf", vimcmd "Format" },
         { "<leader>bF", vimcmd "FormatWrite" },
      },
   },

   { -- Annotation generation
      "danymat/neogen",
      version = "*",
      dependencies = "nvim-treesitter/nvim-treesitter",
      cmd = "Neogen",
      opts = {
         snippet_engine = "luasnip",
      },
   },

   { -- Emmet support
      "mattn/emmet-vim",
      init = function()
         vim.g.user_emmet_mode = "in"
         vim.g.user_emmet_install_global = 0
      end,
   },

   { -- Split / Join blocks of code
      "Wansmer/treesj",
      keys = { "<space>m", "<space>j", "<space>s" },
      dependencies = "nvim-treesitter/nvim-treesitter",
      config = true,
   },
}
