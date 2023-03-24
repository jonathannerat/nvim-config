local Mapper = require "my.util.mapper"
local utils = require("my.utils")
local luacmd, vimcmd = utils.luacmd, utils.vimcmd

local map = Mapper:new()

local default_mappings = {
   ["<C-k>"] = luacmd "vim.lsp.buf.signature_help()",
   ["gA"] = vimcmd 'Lspsaga code_action',
   ["gR"] = vimcmd 'Lspsaga rename',
   ["K"]  = vimcmd 'Lspsaga hover_doc',
   ["gw"] = vimcmd 'Lspsaga show_line_diagnostics',
   ["gW"] = vimcmd 'Lspsaga show_buf_diagnostics',
   ["[d"] = vimcmd 'Lspsaga diagnostic_jump_prev',
   ["]d"] = vimcmd 'Lspsaga diagnostic_jump_next',
   ["gd"] = vimcmd 'Lspsaga goto_definition',
   ["gi"] = vimcmd 'Lspsaga peek_definition',
   ["gD"] = vimcmd 'Lspsaga lsp_finder',
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
   --[[
   clangd = {
      cmd = {
         -- taken from: gh@fitrh/init.nvim
         "clangd",
         "--clang-tidy",
         "--completion-style=bundled",
         "--cross-file-rename",
         "--header-insertion=iwyu",
      },
   },
   --]]
   rust_analyzer = {},
   volar = {
      init_options = {
         typescript = {
            tsdk = "/usr/lib/node_modules/typescript/lib",
         }
      }
   }
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
         ensure_installed = { "lua_ls", "jsonls" },
      }

      mason_lspconfig.setup_handlers {
         function(server_name)
            local opts = extend_with_defaults(lsp_servers[server_name])

            lspconfig[server_name].setup(opts)
         end,

         lua_ls = function()
            require("neodev").setup {
               override = function(root_dir, library)
                  if require("neodev.util").has_file(root_dir, "~/projects/nvim-config") then
                     library.enabled = true
                     library.plugins = true
                  end
               end,
               library = {
                  plugins = { "neotest" },
                  types = true,
               },
            }
            lspconfig.lua_ls.setup(extend_with_defaults())
         end,

         jsonls = function()
            lspconfig.jsonls.setup(extend_with_defaults {
               settings = {
                  json = {
                     schemas = require("schemastore").json.schemas(),
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

      for name, config in pairs(lsp_servers) do
         if not is_installed_through_mason(name) then
             lspconfig[name].setup(extend_with_defaults(config))
         end
      end
   end,
}
