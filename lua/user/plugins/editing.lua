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
         "hrsh7th/cmp-buffer",
         "hrsh7th/cmp-path",
         "onsails/lspkind-nvim", -- LSP Completion symbols
         "windwp/nvim-autopairs",
         {
            "dcampos/cmp-snippy",
            dependencies = "dcampos/nvim-snippy",
         },
         {
            "dcampos/cmp-emmet-vim",
            dependencies = { -- Emmet support
               "mattn/emmet-vim",
               init = function()
                  vim.g.user_emmet_mode = "in"
                  vim.g.user_emmet_install_global = 0
               end,
            },
         },
      },
      config = function()
         local cmp = require "cmp"
         local snippy = require "snippy"

         local function has_words_before()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
         end

         cmp.setup {
            sources = cmp.config.sources {
               { name = "nvim_lsp" },
               { name = "snippy" },
               { name = "emmet_vim" },
               { name = "buffer" },
               { name = "path" },
            },
            mapping = cmp.mapping.preset.insert {
               ["<CR>"] = cmp.mapping.confirm {
                  behavior = cmp.ConfirmBehavior.Replace,
                  select = true,
               },
               ["<Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.select_next_item()
                  elseif snippy.can_expand_or_advance() then
                     snippy.expand_or_advance()
                  elseif has_words_before() then
                     cmp.complete()
                  else
                     fallback()
                  end
               end, { "i", "s" }),
               ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.select_prev_item()
                  elseif snippy.can_jump(-1) then
                     snippy.previous()
                  else
                     fallback()
                  end
               end, { "i", "s" }),
               ["<C-b>"] = cmp.mapping.scroll_docs(-4),
               ["<C-f>"] = cmp.mapping.scroll_docs(4),
            },
            snippet = {
               expand = function(args)
                  snippy.expand_snippet(args.body)
               end,
            },
            formatting = {
               fields = { "abbr", "kind", "menu" },
               format = require("lspkind").cmp_format {
                  mode = "symbol_text",
                  maxwidth = 50,
                  ellipsis_char = "…",
               },
               expandable_indicator = true,
            },
         }

         local cmp_autopairs = require "nvim-autopairs.completion.cmp"
         cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
   },

   {
      "windwp/nvim-autopairs",
      config = function()
         local autopairs = require "nvim-autopairs"
         local Rule = require "nvim-autopairs.rule"

         autopairs.setup {
            disable_filetype = { "TelescopePrompt" },
         }

         autopairs.add_rule(Rule("/*", "*/", { "vue", "javascript", "typescript" }))
      end,
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
   },

   { -- Annotation generation
      "danymat/neogen",
      version = "*",
      dependencies = "nvim-treesitter/nvim-treesitter",
      cmd = "Neogen",
      config = true,
   },

   { -- Split / Join blocks of code
      "Wansmer/treesj",
      dependencies = "nvim-treesitter/nvim-treesitter",
      cmd = "TSJToggle",
      opts = {
         use_default_keymaps = false,
      },
   },
}
