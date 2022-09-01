local Mapper = require "my.util.mapper"
local luacmd = require("my.utils").luacmd

local map = Mapper:new()

local default_mappings = {
   ["<C-k>"] = luacmd "vim.lsp.buf.signature_help()",
   ["gA"] = luacmd 'require("lspsaga.codeaction"):code_action()',
   ["gR"] = luacmd 'require("lspsaga.rename"):lsp_rename()',
   ["gh"] = luacmd 'require("lspsaga.finder"):lsp_finder()',
   ["K"] = luacmd "vim.lsp.buf.hover()",
   ["[D"] = luacmd 'require("lspsaga.diagnostic").show_line_diagnostics()',
   ["[d"] = luacmd 'require("lspsaga.diagnostic").goto_prev()',
   ["]d"] = luacmd 'require("lspsaga.diagnostic").goto_next()',
   ["gD"] = luacmd "vim.lsp.buf.declaration()",
   ["gd"] = luacmd "vim.lsp.buf.definition()",
   ["gi"] = luacmd "vim.lsp.buf.implementation()",
   ["gr"] = luacmd "vim.lsp.buf.references()",
}

local function on_attach(client, bufnr)
   map:buffer(bufnr, function(m)
      m:with_options({ silent = true, noremap = true }, function(m)
         m:bind(default_mappings)

         if client.server_capabilities.documentFormatting then
            m:bind("<leader>sf", luacmd "vim.lsp.buf.formatting()")
         end

         if client.server_capabilities.documentRangeFormatting then
            m:mode("visual", "<leader>sf", luacmd "vim.lsp.buf.range_formatting()")
         end
      end)
   end)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

vim.tbl_extend("force", capabilities.textDocument.completion.completionItem, {
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

local lsp_servers = {
   ccls = {},
   pylsp = {},
   pyright = {},
   tsserver = {},
   volar = {},
   sumneko_lua = require("lua-dev").setup(),
   intelephense = {
      init_options = {
         globalStoragePath = os.getenv "HOME" .. "/.local/share/intelephense",
         licenceKey = "EducationalCode",
      },
   },
}

return {
   setup = function()
      require("nvim-lsp-installer").setup {}

      local lspconfig = require "lspconfig"

      for name, opts in pairs(lsp_servers) do
         if not opts.on_attach then
            opts.on_attach = on_attach
         end
         if not opts.capabilities then
            opts.capabilities = capabilities
         end

         lspconfig[name].setup(opts)
      end
   end,
}
