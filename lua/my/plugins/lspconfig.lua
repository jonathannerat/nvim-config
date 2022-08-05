local m = require "my.util.mapper"
local cmd, bind = m.cmd, m.bind

local default_mappings = {
	["n|ns|<C-k>"] = cmd "lua vim.lsp.buf.signature_help()",
	["n|ns|gA"] = cmd "Lspsaga code_action",
	["n|ns|gR"] = cmd "Lspsaga rename",
	["n|ns|gh"] = cmd "Lspsaga lsp_finder",
	["n|ns|K"] = cmd "lua vim.lsp.buf.hover()",
	["n|ns|[D"] = cmd "Lspsaga show_line_diagnostics",
	["n|ns|[d"] = cmd "Lspsaga diagnostic_jump_prev",
	["n|ns|]d"] = cmd "Lspsaga diagnostic_jump_next",
	["n|ns|gD"] = cmd "lua vim.lsp.buf.declaration()",
	["n|ns|gd"] = cmd "lua vim.lsp.buf.definition()",
	["n|ns|gi"] = cmd "lua vim.lsp.buf.implementation()",
	["n|ns|gr"] = cmd "lua vim.lsp.buf.references()",
}

local M = {}

M.on_attach = function(client, bufnr)
	-- share this instance for all buffers
	local mappings = default_mappings

	if client.server_capabilities.documentFormatting then
		-- create a copy for a specific buffer if it has more capabilities
		mappings = vim.fn.copy(default_mappings)
		mappings["n|ns|<leader>sf"] = cmd "lua vim.lsp.buf.formatting()"
	end

	if client.server_capabilities.documentRangeFormatting then
		-- only create one copy
		mappings = mappings == default_mappings and vim.fn.copy(default_mappings) or mappings
		mappings["v|ns|<leader>sf"] = cmd "lua vim.lsp.buf.range_formatting()"
	end

	bind(mappings, bufnr)

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

M.lsp_servers = {
	clangd = {},
	intelephense = {
		init_options = {
			globalStoragePath = os.getenv('HOME') .. '/.local/share/intelephense',
			licenceKey = "EducationalCode",
		},
	},
	pylsp = {},
	pyright = {},
	sumneko_lua = require("lua-dev").setup(),
	tsserver = {},
	volar = {},
}

M.setup = function()
	require("nvim-lsp-installer").setup {}

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
