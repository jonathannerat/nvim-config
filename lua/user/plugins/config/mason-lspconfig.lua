local lspconfig = require "lspconfig"
local Mapper = require "user.utils.mapper"
local M = {}

local default_mappings = {
   ["<C-k>"] = "<cmd>lua vim.lsp.buf.signature_help()<cr>",
   ["gA"] = '<cmd>Lspsaga code_action<cr>',
   ["gR"] = '<cmd>Lspsaga rename<cr>',
   ["K"]  = '<cmd>Lspsaga hover_doc<cr>',
   ["gw"] = '<cmd>Lspsaga show_line_diagnostics<cr>',
   ["gW"] = '<cmd>Lspsaga show_buf_diagnostics<cr>',
   ["[d"] = '<cmd>Lspsaga diagnostic_jump_prev<cr>',
   ["]d"] = '<cmd>Lspsaga diagnostic_jump_next<cr>',
   ["gd"] = '<cmd>Lspsaga goto_definition<cr>',
   ["gi"] = '<cmd>Lspsaga peek_definition<cr>',
   ["gD"] = '<cmd>Lspsaga lsp_finder<cr>',
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

M.lsp_servers = {
      intelephense = {
         init_options = {
            globalStoragePath = os.getenv "HOME" .. "/.local/share/intelephense",
            licenceKey = "EducationalCode",
         },
      },
      volar = {
         init_options = {
            typescript = {
               tsdk = "/usr/lib/node_modules/typescript/lib",
            }
         }
      }
   }

M.handlers = {
   function (server_name)
      local opts = M.lsp_servers[server_name]

      lspconfig[server_name].setup(M.extend_with_defaults(opts))
   end,

   lua_ls = function ()
      require("neodev").setup {
         override = function(root_dir, library)
            local configdir = "~/projects/nvim-config"
            if require("neodev.util").has_file(root_dir, configdir) then
               library.enabled = true
               library.plugins = true
            end
         end,
         library = {
            plugins = { "neotest" },
            types = true,
         },
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
