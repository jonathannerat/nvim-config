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
      },
      -- (2) Then setup mason-lspconfig
      config = function()
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

   "mfussenegger/nvim-jdtls",
}
