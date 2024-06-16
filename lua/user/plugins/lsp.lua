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
      opts = function()
         return require "user.plugins.config.mason-lspconfig"
      end,
   },

   "mfussenegger/nvim-jdtls",
}
