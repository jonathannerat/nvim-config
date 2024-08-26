local utils = require "user.utils"
local option = require "user.options"
local keymap = require "user.utils.keymap"
local autocmd = vim.api.nvim_create_autocmd
local function command(name, cmd)
   return vim.api.nvim_create_user_command(name, cmd, {})
end

command("LuaPlayground", function()
   local output = io.popen("mktemp /tmp/lua_playground.XXXXXX.lua", "r")
   local filename = output ~= nil and output:read "*a" or nil

   if filename then
      vim.cmd("tabnew " .. filename)
   else
      vim.notify("Error creating file with mktemp", vim.log.levels.ERROR)
   end
end)

command("PeekOpen", function () require("peek").open() end)
command("PeekOpen", function () require("peek").open() end)

autocmd("BufWritePost", {
   pattern = { "/tmp/lua_playground.*.lua" },
   command = "luafile %",
})

autocmd("FileType", {
   pattern = { "blade" },
   command = "EmmetInstall",
   group = vim.api.nvim_create_augroup("emmet_on_filetypes", {}),
})

-- Reload sxhkd daemon
autocmd("BufWritePost", {
   pattern = { utils.xdgdir("config", "sxhkd", "sxhkdrc") },
   callback = function()
      io.popen "pkill -USR1 sxhkd"
      vim.notify "sxhkd daemon reloaded!"
   end,
})

-- Set options for documents
local tw = option "vim.textwidth"
local cmd = "setlocal spell"
if type(tw) == "number" then
   cmd = cmd .. " tw=" .. tostring(tw)
end

autocmd("FileType", {
   pattern = { "markdown", "norg", "tex" },
   command = cmd,
})

autocmd({ "FileType" }, {
   pattern = { "nasm" },
   command = "set fdm=marker",
})

-- Autostart insert mode in terminal
autocmd("TermOpen", {
   pattern = "*",
   command = "startinsert",
})

local navic = require "nvim-navic"

autocmd("LspAttach", {
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
         {
            "<C-k>",
            lua = "vim.lsp.buf.signature_help()",
            desc = "View signature help for hovered function",
         },
         {
            "<C-h>",
            function ()
               vim.lsp.buf.clear_references()
               vim.lsp.buf.document_highlight()
            end,
            desc = "Highlight hovered symbol",
         },
      }

      if client.server_capabilities.documentFormattingProvider then
         keymaps[#keymaps + 1] = {
            "<leader>lf",
            lua = "vim.lsp.buf.format { async = true }",
            desc = "Format file (async)",
         }
      end

      if client.server_capabilities.documentRangeFormattingProvider then
         keymaps[#keymaps + 1] = {
            "<leader>lf",
            lua = "vim.lsp.buf.format { async = true }",
            mode = "visual",
            desc = "Format lines (async)",
         }
      end

      keymap(keymaps)

      navic.attach(client, bufnr)
   end,
})

autocmd("LspProgress", {
   callback = require "user.utils.lsp_progress",
})
