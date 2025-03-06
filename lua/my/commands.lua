local has_navic, navic = pcall(require, "nvim-navic")
local map = require("my.utils").map

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		if not client then
			return
		end

		map({
			group = { silent = true, buffer = ev.buf },
			{
				"<C-k>",
				lua = "vim.lsp.buf.signature_help()",
				desc = "Show the current function signture",
			},
			{
				"grr",
				lua = "vim.lsp.buf.rename()",
				desc = "Rename the current symbol",
			},
			{
				"grf",
				lua = "vim.lsp.buf.references()",
				desc = "Rename the current symbol",
			},
			{
				"<C-w>D",
				lua = "vim.diagnostic.open_float {scope = 'buffer'}",
				desc = "View diagnostics for current file",
			},
		})

		if has_navic and client.server_capabilities.documentSymbolProvider then
			navic.attach(client, ev.buf)
		end
	end,
})
