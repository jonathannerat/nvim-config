local lspconfig = require "lspconfig"
local navic = require "nvim-navic"

local Mapper = require "user.utils.mapper"
local utils = require "user.utils"
local vimcmd, luacmd, custom = utils.vimcmd, utils.luacmd, utils.custom

local M = {}

local default_mappings = {
   ["<C-k>"] = luacmd "vim.lsp.buf.signature_help()",
   ["gA"] = vimcmd "Lspsaga code_action",
   ["gR"] = vimcmd "Lspsaga rename",
   ["K"] = vimcmd "Lspsaga hover_doc",
   ["gw"] = vimcmd "Lspsaga show_line_diagnostics",
   ["gW"] = vimcmd "Lspsaga show_buf_diagnostics",
   ["[d"] = vimcmd "Lspsaga diagnostic_jump_prev",
   ["]d"] = vimcmd "Lspsaga diagnostic_jump_next",
   ["gd"] = vimcmd "Lspsaga goto_definition",
   ["gi"] = vimcmd "Lspsaga peek_definition",
   ["gD"] = vimcmd "Lspsaga finder",
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

M.ensure_installed = { "bashls", "jsonls", "lua_ls", "vimls" }

M.lsp_servers = custom "lsp_servers"

M.handlers = {
   function (server_name)
      local opts = M.lsp_servers[server_name]

      lspconfig[server_name].setup(M.extend_with_defaults(opts))
   end,

   lua_ls = function ()
      require("neodev").setup {
         override = function(root_dir, library)
            local config_dir = vim.fs.normalize("~/projects/nvim-config")
            if root_dir:find(config_dir, 1, true) == 1 then
               library.enabled = true
               library.plugins = true
            end
         end
      }
      lspconfig.lua_ls.setup(M.extend_with_defaults())
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
