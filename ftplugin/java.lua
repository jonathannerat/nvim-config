local Mapper = require "user.utils.mapper"
local utils = require "user.utils"
local vimcmd, luacmd = utils.vimcmd, utils.luacmd

local default_mappings = {
   ["<C-k>"] = luacmd "vim.lsp.buf.signature_help()",
   ["K"] = vimcmd "Lspsaga hover_doc",
   ["[d"] = vimcmd "Lspsaga diagnostic_jump_prev",
   ["]d"] = vimcmd "Lspsaga diagnostic_jump_next",
   ["gA"] = vimcmd "Lspsaga code_action",
   ["gD"] = vimcmd "Lspsaga lsp_finder",
   ["gO"] = luacmd "require('jdtls').organize_imports()",
   ["gR"] = vimcmd "Lspsaga rename",
   ["gW"] = vimcmd "Lspsaga show_buf_diagnostics",
   ["gd"] = vimcmd "Lspsaga goto_definition",
   ["gi"] = vimcmd "Lspsaga peek_definition",
   ["gw"] = vimcmd "Lspsaga show_line_diagnostics",
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
