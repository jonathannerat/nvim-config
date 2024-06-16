local mason_lspconfig = require "mason-lspconfig"
local lspconfig = require "lspconfig"

local keymap = require "user.utils.keymap"
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

local navic = require "nvim-navic"

vim.api.nvim_create_autocmd("LspAttach", {
   callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      if not client then
         return
      end

      ---@type KeymapGroup
      local keymaps = {
         group = { name = "LSP", silent = true, buffer = bufnr },
         {
            "<C-w>D",
            lua = "vim.diagnostic.open_float {scope = 'buffer'}",
            desc = "View buffer diagnostics",
         },
      }

      if client.server_capabilities.documentFormattingProvider then
         keymaps[#keymaps + 1] = {
            "<leader>sf",
            lua = "vim.lsp.buf.format { async = true }",
            desc = "Format file (async)",
         }
      end

      if client.server_capabilities.documentRangeFormattingProvider then
         keymaps[#keymaps + 1] = {
            "<leader>sf",
            lua = "vim.lsp.buf.format { async = true }",
            mode = "visual",
            desc = "Format lines (async)",
         }
      end

      keymap(keymaps)

      navic.attach(client, bufnr)
   end,
})

return {
   ensure_installed = options "lsp.ensure_installed",
   handlers = {
      function(server_name)
         local opts = options("lsp.servers." .. server_name)

         lspconfig[server_name].setup(extend(opts))
      end,

      lua_ls = function()
         require("neodev").setup {
            override = function(root_dir, library)
               local config_dir = vim.fs.normalize(options "dirs.nvim_config")
               if root_dir:find(config_dir, 1, true) == 1 then
                  library.enabled = true
                  library.plugins = true
               end
            end,
         }
         lspconfig.lua_ls.setup(extend(options "lsp.servers.lua_ls"))
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
