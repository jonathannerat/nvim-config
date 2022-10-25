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

local function default_on_attach(client, bufnr)
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

local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

local lsp_servers = {
   intelephense = {
      init_options = {
         globalStoragePath = os.getenv "HOME" .. "/.local/share/intelephense",
         licenceKey = "EducationalCode",
      },
   },
   ccls = {},
}

local function extend_with_defaults(opts)
   opts = opts or {}

   if not opts.on_attach then
      opts.on_attach = default_on_attach
   end

   if not opts.capabilities then
      opts.capabilities = default_capabilities
   end

   return opts
end

return {
   setup = function()
      local lspconfig = require "lspconfig"
      local mason_lspconfig = require "mason-lspconfig"

      mason_lspconfig.setup {
         ensure_installed = { "sumneko_lua" },
      }

      mason_lspconfig.setup_handlers {
         function(server_name)
            local opts = extend_with_defaults(lsp_servers[server_name])

            lspconfig[server_name].setup(opts)
         end,

         sumneko_lua = function()
            require("neodev").setup {
               override = function(root_dir, library)
                  if require("neodev.util").has_file(root_dir, "~/projects/nvim-config") then
                     library.enabled = true
                     library.plugins = true
                  end
               end,
            }
            lspconfig.sumneko_lua.setup(extend_with_defaults())
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

      for name, config in pairs(lsp_servers) do
         if not is_installed_through_mason(name) then
             lspconfig[name].setup(extend_with_defaults(config))
         end
      end
   end,
}
