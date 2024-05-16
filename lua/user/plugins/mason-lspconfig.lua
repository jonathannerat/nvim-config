local option = require "user.option"

-- (1) setup mason.nvim first
require("mason").setup()

local mason_lspconfig = require "mason-lspconfig"

-- (2) setup mason-lspconfig afterwards
mason_lspconfig.setup {
   ensure_installed = option "lsp.ensure_installed",
}

local cmp_lsp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")

local default_lsp_opts = {
   capabilities = cmp_lsp_ok and cmp_lsp.default_capabilities() or nil,
}

default_lsp_opts.__index = default_lsp_opts

local function extend(opts)
   return opts and setmetatable(opts, default_lsp_opts) or default_lsp_opts
end

-- (3) finally, setup lspconfig for each server
local lspconfig = require "lspconfig"
local ss_ok, schemastore = pcall(require, "schemastore")

-- Setup handlers for lsp servers installed through mason
mason_lspconfig.setup_handlers {
   function(server_name)
      local opts = option("lsp.server." .. server_name)

      lspconfig[server_name].setup(extend(opts))
   end,

   lua_ls = function()
      require("neodev").setup()
      local opts = extend(option "lsp.server.lua_ls")

      lspconfig.lua_ls.setup(opts)
   end,

   jsonls = function()
      lspconfig.jsonls.setup(extend {
         settings = {
            json = {
               schemas = ss_ok and schemastore.json.schemas() or nil,
               validate = { enable = true },
            },
         },
      })
   end,
}

local mason_servers = mason_lspconfig.get_installed_servers()
local function is_installed_through_mason(name)
   for _, v in ipairs(mason_servers) do
      if name == v then
         return true
      end
   end

   return false
end

-- Setup handlers for every other lsp that can't be installed through mason
local lsp_servers = option "lsp.server" or {}
for name, server_config in pairs(lsp_servers) do
   if not is_installed_through_mason(name) then
      lspconfig[name].setup(extend(server_config))
   end
end

local navic_ok, navic = pcall(require, "nvim-navic")
local keymap = require "user.utils.keymap"
vim.api.nvim_create_autocmd("LspAttach", {
   callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      if not client then
         return
      end

      ---@type KeymapGroup
      local keymaps = {
         group = { name = "LSP", silent = true, buffer = bufnr },
         {
            "<C-w>D",
            lua = "vim.diagnostic.open_float {scope = 'buffer'}",
            desc = "View buffer diagnostics",
         },
      }

      if client.server_capabilities.documentFormattingProvider then
         keymaps[#keymaps + 1] = {
            "<leader>sf",
            lua = "vim.lsp.buf.format { async = true }",
            desc = "Format file (async)",
         }
      end

      if client.server_capabilities.documentRangeFormattingProvider then
         keymaps[#keymaps + 1] = {
            "<leader>sf",
            lua = "vim.lsp.buf.format { async = true }",
            mode = "visual",
            desc = "Format lines (async)",
         }
      end

      keymap(keymaps)

      if navic_ok and client.server_capabilities.documentSymbolProvider then
         navic.attach(client, bufnr)
      end
   end,
})
