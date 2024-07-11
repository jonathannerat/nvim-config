local mason_lspconfig = require "mason-lspconfig"
local lspconfig = require "lspconfig"

local options = require "user.options"

local default_lsp_opts = {
   capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

default_lsp_opts.__index = default_lsp_opts

local function extend(opts)
   return opts and setmetatable(opts, default_lsp_opts) or default_lsp_opts
end

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
for name, server_config in pairs(options "lsp.servers") do
   if not is_installed_through_mason(name) then
      lspconfig[name].setup(server_config)
   end
end

return {
   ensure_installed = options "lsp.ensure_installed",
   handlers = {
      function(server_name)
         local opts = options("lsp.servers." .. server_name)

         lspconfig[server_name].setup(extend(opts))
      end,

      jsonls = function()
         lspconfig.jsonls.setup(extend {
            settings = {
               json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
               },
            },
         })
      end,
   }
}
