local Mapper = require "my.util.mapper"
local map = Mapper:new()

local default_mappings = {
   ["<C-k>"] = ":lua vim.lsp.buf.signature_help()<cr>",
   ["gA"] = ":Lspsaga code_action<cr>",
   ["gR"] = ":Lspsaga rename<cr>",
   ["gh"] = ":Lspsaga lsp_finder<cr>",
   ["K"] = ":lua vim.lsp.buf.hover()<cr>",
   ["[D"] = ":Lspsaga show_line_diagnostics<cr>",
   ["[d"] = ":Lspsaga diagnostic_jump_prev<cr>",
   ["]d"] = ":Lspsaga diagnostic_jump_next<cr>",
   ["gD"] = ":lua vim.lsp.buf.declaration()<cr>",
   ["gd"] = ":lua vim.lsp.buf.definition()<cr>",
   ["gi"] = ":lua vim.lsp.buf.implementation()<cr>",
   ["gr"] = ":lua vim.lsp.buf.references()<cr>",
}

local M = {}

M.on_attach = function(client, bufnr)
   map:buffer(bufnr, function(m)
      m:with_options({ silent = true, noremap = true }, function(m)
         m:bind(default_mappings)

         if client.server_capabilities.documentFormatting then
            m:bind("<leader>sf", ":lua vim.lsp.buf.formatting()<cr>")
         end

         if client.server_capabilities.documentRangeFormatting then
            m:mode("visual", "<leader>sf", ":lua vim.lsp.buf.range_formatting()<cr>")
         end
      end)
   end)

   require("lspkind").init()
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
vim.tbl_extend("force", M.capabilities.textDocument.completion.completionItem, {
   snippetSupport = true,
   preselectSupport = true,
   insertReplaceSupport = true,
   labelDetailsSupport = true,
   deprecatedSupport = true,
   commitCharactersSupport = true,
   tagSupport = { valueSet = { 1 } },
   resolveSupport = {
      properties = {
         "documentation",
         "detail",
         "additionalTextEdits",
      },
   },
})

M.lsp_servers = {
   clangd = {},
   intelephense = {
      init_options = {
         globalStoragePath = os.getenv "HOME" .. "/.local/share/intelephense",
         licenceKey = "EducationalCode",
      },
   },
   pylsp = {},
   pyright = {},
   sumneko_lua = require("lua-dev").setup(),
   tsserver = {},
   volar = {},
}

M.setup = function()
   require("nvim-lsp-installer").setup {}

   local lspconfig = require "lspconfig"

   for name, opts in pairs(M.lsp_servers) do
      if not opts.on_attach then
         opts.on_attach = M.on_attach
      end
      if not opts.capabilities then
         opts.capabilities = M.capabilities
      end

      lspconfig[name].setup(opts)
   end
end

return M
