return {
   { -- LSP Server Installation
      "williamboman/mason-lspconfig.nvim",
      dependencies = {
         { -- (1) Setup mason.nvim first
            "williamboman/mason.nvim",
            build = ":MasonUpdate",
            config = true,
         },
         "neovim/nvim-lspconfig",
         "folke/neodev.nvim", -- sumneko_lua lsp + nvim integration
         "b0o/SchemaStore.nvim",
         "hrsh7th/cmp-nvim-lsp",
         {
            "glepnir/lspsaga.nvim",
            opts = {
               lightbulb = { enable = false },
               outline = { enable = false },
               beacon = { enable = false },
               symbol_in_winbar = { enable = false },
               diagnostic = {
                  show_code_action = false,
                  show_source = true,
                  jump_num_shortcut = true,
               },
            },
         }
      },
      -- (2) Then setup mason-lspconfig
      config = function ()
         local config = require "user.plugins.config.mason-lspconfig"
         local mason_lspconfig = require "mason-lspconfig"

         mason_lspconfig.setup {
            ensure_installed = config.ensure_installed,
         }

         -- Setup handlers for lsp servers installed through mason
         mason_lspconfig.setup_handlers(config.handlers)

         local mason_servers = mason_lspconfig.get_installed_servers()
         local function is_installed_through_mason(name)
            for _, v in ipairs(mason_servers) do
               if name == v then
                  return true
               end
            end

            return false
         end

         -- Setup handlers for every other lsp that can't be installed
         -- through mason
         local lspconfig = require "lspconfig"
         for name, server_config in pairs(config.lsp_servers) do
            if not is_installed_through_mason(name) then
                lspconfig[name].setup(config.extend_with_defaults(server_config))
            end
         end
      end,
   },

   { -- Completion engine for LSPs
      "hrsh7th/nvim-cmp",
      dependencies = {
         "hrsh7th/cmp-nvim-lsp",
         "saadparwaiz1/cmp_luasnip",
         { "L3MON4D3/cmp-luasnip-choice", config = true },
         "hrsh7th/cmp-buffer",
         "hrsh7th/cmp-path",
         "onsails/lspkind-nvim", -- LSP Completion symbols
         "windwp/nvim-autopairs",
      },
      config = function ()
         local cmp = require "cmp"
         local lspkind = require "lspkind"
         local luasnip = require "luasnip"

         local function has_words_before()
           unpack = unpack or table.unpack
           local line, col = unpack(vim.api.nvim_win_get_cursor(0))
           return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
         end


         cmp.setup {
            sources = cmp.config.sources({
               { name = "nvim_lsp" },
            }, {
               { name = "luasnip" },
               { name = "luasnip_choice" },
            }, {
               { name = "buffer" },
               { name = "path" },
            }),
            mapping = cmp.mapping.preset.insert {
               ['<CR>'] = cmp.mapping.confirm({ select = false }),
               ['<Tab>'] = cmp.mapping(function (fallback)
                  if cmp.visible() then
                     cmp.select_next_item()
                  elseif luasnip.expand_or_locally_jumpable() then
                     luasnip.expand_or_jump()
                  elseif has_words_before() then
                     cmp.complete()
                  else
                     fallback()
                  end
               end, { "i", "s" }),
               ['<S-Tab>'] = cmp.mapping(function (fallback)
                  if cmp.visible() then
                     cmp.select_prev_item()
                  elseif luasnip.jumpable(-1) then
                     luasnip.jump(-1)
                  else
                     fallback()
                  end
               end, { "i", "s" })
            },
            snippet = {
               expand = function (args)
                  require("luasnip").lsp_expand(args.body)
               end
            },
            window = {
               documentation = cmp.config.window.bordered(),
            },
            formatting = {
               format = lspkind.cmp_format {
                  mode = "symbol_text",
                  maxwidth = 50,
                  ellipsis_char = "…",
               }
            },
            performance = {
               max_view_entries = 20,
            }
         }

         local cmp_autopairs = require "nvim-autopairs.completion.cmp"
         cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
   },

   {
      "ray-x/lsp_signature.nvim",
      opts = {
         bind = true,
         floating_window = true,
         hint_enable = false,
         hint_prefix = " ",
         handler_opts = {
            border = "rounded",
         },
      },
   },

   "mfussenegger/nvim-jdtls"
}
