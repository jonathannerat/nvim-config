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
      opts = {
         enable_autocmd = false,
      },
      init = function()
         vim.g.skip_ts_context_commentstring_module = true
      end,
   },

   { -- Show cursor context block (class / function / if / for / etc.)
      "nvim-treesitter/nvim-treesitter-context",
      dependencies = "nvim-treesitter/nvim-treesitter",
      opts = {
         enabled = true,
         max_lines = 3,
      },
   },

   { -- Completion engine
      "hrsh7th/nvim-cmp",
      dependencies = {
         "hrsh7th/cmp-nvim-lsp",
         "quangnguyen30192/cmp-nvim-ultisnips",
         "hrsh7th/cmp-buffer",
         "hrsh7th/cmp-path",
         "onsails/lspkind-nvim", -- LSP Completion symbols
         "windwp/nvim-autopairs",
      },
      config = function()
         local cmp = require "cmp"
         local lspkind = require "lspkind"
         local ultisnips_mappings = require "cmp_nvim_ultisnips.mappings"

         cmp.setup {
            sources = cmp.config.sources {
               { name = "nvim_lsp" },
               { name = "ultisnips" },
               { name = "buffer" },
               { name = "path" },
            },
            mapping = cmp.mapping.preset.insert {
               ["<CR>"] = cmp.mapping.confirm {
                  behavior = cmp.ConfirmBehavior.Replace,
                  select = true,
               },
               ["<Tab>"] = cmp.mapping(function(fallback)
                  ultisnips_mappings.compose { "select_next_item", "expand", "jump_forwards" }(fallback)
               end, { "i", "s" }),
               ["<S-Tab>"] = cmp.mapping(function(fallback)
                  ultisnips_mappings.compose { "select_prev_item", "jump_backwards" }(fallback)
               end, { "i", "s" }),
            },
            snippet = {
               expand = function(args)
                  vim.fn["UltiSnips#Anon"](args.body)
               end,
            },
            window = {
               documentation = cmp.config.window.bordered(),
            },
            formatting = {
               format = lspkind.cmp_format {
                  mode = "symbol_text",
                  maxwidth = 50,
                  ellipsis_char = "…",
               },
            },
            performance = {
               max_view_entries = 20,
            },
         }

         local cmp_autopairs = require "nvim-autopairs.completion.cmp"
         cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
   },

   {
      "SirVer/ultisnips",
      init = function()
         vim.g.UltiSnipsEditSplit = "vertical"
      end,
   },

   {
      "windwp/nvim-autopairs",
      opts = {
         disable_filetype = { "TelescopePrompt" },
      },
   },

   "gpanders/editorconfig.nvim",

   {
      "numToStr/Comment.nvim",
      opts = function()
         return {
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
         }
      end,
   },

   {
      "kylechui/nvim-surround",
      version = "*",
      event = "VeryLazy",
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

   {
      url = "https://git.sr.ht/~vigoux/architext.nvim",
      dependencies = {
         -- Not required, only used to refine the language resolution
         "nvim-treesitter/nvim-treesitter",
      },
   },
}
