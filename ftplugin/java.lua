local Mapper = require "user.utils.mapper"
local luacmd = require("user.utils").luacmd

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
   ["gO"] = luacmd "require('jdtls').organize_imports()",
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
      require("nvim-navic").attach(client, bufnr)
   end
end

require("jdtls").start_or_attach {
   cmd = { "/usr/bin/jdtls" },
   root_dit = vim.fs.dirname(vim.fs.find({ "gradlew", ".git" }, { upward = true })[1]),
   on_attach = default_on_attach,
   capabilities = require("cmp_nvim_lsp").default_capabilities(),
}
