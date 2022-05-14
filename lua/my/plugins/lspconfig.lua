local m = require "my.util.mapper"
local cmd, bind = m.cmd, m.bind

local default_mappings = {
	["n|ns|<C-k>"] = cmd "lua vim.lsp.buf.signature_help()",
	["n|ns|gA"] = cmd "lua vim.lsp.buf.code_action()",
	["n|ns|gR"] = cmd "lua vim.lsp.buf.rename()",
	["n|ns|K"] = cmd "lua vim.lsp.buf.hover()",
	["n|ns|[D"] = cmd "lua vim.diagnostic.show()",
	["n|ns|[d"] = cmd "lua vim.diagnostic.goto_prev()",
	["n|ns|]d"] = cmd "lua vim.diagnostic.goto_next()",
	["n|ns|gD"] = cmd "lua vim.lsp.buf.declaration()",
	["n|ns|gd"] = cmd "lua vim.lsp.buf.definition()",
	["n|ns|gi"] = cmd "lua vim.lsp.buf.implementation()",
	["n|ns|gr"] = cmd "lua vim.lsp.buf.references()",
}

local M = {}

M.lsp_signature_config = {
	bind = true,
	doc_lines = 10,
	floating_window = false,
	hint_enable = true,
	hint_prefix = "  ",
	handler_opts = {
		border = "rounded",
	},
}

M.lsp_servers = {
	clangd = {},
	pylsp = {},
	hls = {
		cmd = { "haskell-language-server", "--lsp" },
	},
}

M.on_attach = function(client, bufnr)
	-- share this instance for all buffers
	local mappings = default_mappings

	if client.resolved_capabilities.document_formatting then
		-- create a copy for a specific buffer if it has more capabilities
		mappings = vim.fn.copy(default_mappings)
		mappings["n|ns|<leader>sf"] = cmd "lua vim.lsp.buf.formatting()"
	end

	if client.resolved_capabilities.document_range_formatting then
		-- only create one copy
		mappings = mappings == default_mappings and vim.fn.copy(default_mappings) or mappings
		mappings["v|ns|<leader>sf"] = cmd "lua vim.lsp.buf.range_formatting()"
	end

	bind(mappings, bufnr)

	-- annoying bug: https://github.com/ray-x/lsp_signature.nvim/issues/76
	require("lsp_signature").on_attach(M.lsp_signature_config)
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

M.setup = function()
	local lspinstaller = require "nvim-lsp-installer"

	lspinstaller.on_server_ready(function(server)
		-- skip local servers
		if M.lsp_servers[server.name] then
			return
		end

		local opts = {}

		if server.name == "sumneko_lua" then
			opts = require("lua-dev").setup()
		end

		if not opts.on_attach then
			opts.on_attach = M.on_attach
		end
		if not opts.capabilities then
			opts.capabilities = M.capabilities
		end

		server:setup(opts)
		vim.cmd [[ do User LspAttachBuffers ]]
	end)

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
