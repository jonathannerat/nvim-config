local lspconfig = require "lspconfig"
local navic = require "nvim-navic"

local Mapper = require "user.utils.mapper"
local utils = require "user.utils"
local option = require "user.options"
local vimcmd, luacmd = utils.vimcmd, utils.luacmd

local M = {}

local default_mappings = {
   ["<C-k>"] = luacmd "vim.lsp.buf.signature_help()",
   ["gA"] = luacmd "vim.lsp.buf.code_action()",
   ["gR"] = luacmd "vim.lsp.buf.rename()",
   ["K"] = luacmd "vim.lsp.buf.hover()",
   ["gw"] = luacmd "vim.diagnostic.open_float()",
   ["gW"] = luacmd "vim.diagnostic.open_float { scope = 'buffer' }",
   ["[d"] = luacmd "vim.diagnostic.goto_prev()",
   ["]d"] = luacmd "vim.diagnostic.goto_next()",
   ["gd"] = luacmd "vim.lsp.buf.definition()",
}

local function default_on_attach(client, bufnr)
   Mapper:new():buffer(bufnr, function(m)
      m:with_options({ silent = true, noremap = true }, function(m)
         m:bind(default_mappings)

         if client.server_capabilities.documentFormatting then
            m:bind("<leader>sf", "<cmd>lua vim.lsp.buf.formatting()<cr>")
         end

         if client.server_capabilities.documentRangeFormatting then
            m:mode("visual", "<leader>sf", "<cmd>lua vim.lsp.buf.range_formatting()<cr>")
         end
      end)
   end)

   if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
   end
end

local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

function M.extend_with_defaults(opts)
   opts = opts or {}

   if not opts.on_attach then
      opts.on_attach = default_on_attach
   end

   if not opts.capabilities then
      opts.capabilities = default_capabilities
   end

   return opts
end

M.ensure_installed = { "bashls", "jsonls", "lua_ls" }

M.lsp_servers = option "lsp_servers"

M.handlers = {
   function(server_name)
      local opts = M.lsp_servers[server_name]

      lspconfig[server_name].setup(M.extend_with_defaults(opts))
   end,

   lua_ls = function()
      require("neodev").setup {
         override = function(root_dir, library)
            local config_dir = vim.fs.normalize "~/projects/nvim-config"
            if root_dir:find(config_dir, 1, true) == 1 then
               library.enabled = true
               library.plugins = true
            end
         end,
      }
      lspconfig.lua_ls.setup(M.extend_with_defaults(M.lsp_servers.lua_ls))
   end,

   jsonls = function()
      lspconfig.jsonls.setup(M.extend_with_defaults {
         settings = {
            json = {
               schemas = require("schemastore").json.schemas(),
               validate = { enable = true },
            },
         },
      })
   end,
}

return M
