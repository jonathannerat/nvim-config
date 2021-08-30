local m = require "my.util.mapper"
local cmd, bind = m.cmd, m.bind
local util = require "lspconfig.util"

local lualsp_path = os.getenv "HOME" .. "/.local/src/lua-language-server/"

local luadev = require("lua-dev").setup {
	lspconfig = {
		cmd = {
			lualsp_path .. "bin/Linux/lua-language-server",
			"-E",
			lualsp_path .. "main.lua",
		},
	},
}

local default_mappings = {
	["n|ns|<C-k>"] = cmd "lua vim.lsp.buf.signature_help()",
	["n|ns|<leader>A"] = cmd "lua vim.lsp.buf.code_action()",
	["n|ns|<leader>R"] = cmd "lua vim.lsp.buf.rename()",
	["n|ns|K"] = cmd "lua vim.lsp.buf.hover()",
	["n|ns|[d"] = cmd "lua vim.lsp.diagnostic.goto_prev()",
	["n|ns|]d"] = cmd "lua vim.lsp.diagnostic.goto_next()",
	["n|ns|gD"] = cmd "lua vim.lsp.buf.declaration()",
	["n|ns|gd"] = cmd "lua vim.lsp.buf.definition()",
	["n|ns|gi"] = cmd "lua vim.lsp.buf.implementation()",
	["n|ns|gr"] = cmd "lua vim.lsp.buf.references()",
}

local M = {}

M.lsp_servers = {
	"bashls",
	"ccls",
	"cssls",
	"pyright",
	"rust_analyzer",
	"solargraph",
	"texlab",
	"tsserver",
	"vimls",
	"gopls",
	"zk",
	jsonls = {
		cmd = { "json-languageserver", "--stdio" },
	},
	sumneko_lua = luadev,
}

M.lsp_signature_config = {
	bind = true,
	doc_lines = 2,
	hint_enable = false,
	handler_opts = {
		border = "single",
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

	require("lsp_signature").on_attach(M.lsp_signature_config)
	require("lspkind").init()
end

M.extra_configs = {
	zk = {
		default_config = {
			cmd = { 'zk', 'lsp' },
			filetypes = { 'markdown' },
			root_dir = util.root_pattern(".zk"),
			settings = {},
		},
	},
}

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

M.config = function()
	local lspconfig = require "lspconfig"
	local configs = require "lspconfig/configs"

	for name, config in pairs(M.extra_configs) do
		configs[name] = config
	end

	for k, v in pairs(M.lsp_servers) do
		local lsp = type(k) == "number" and v or k
		local config = type(k) == "number" and {} or v

	for k, v in pairs(M.lsp_servers) do
		local lsp = type(k) == "number" and v or k
		local config = type(k) == "number" and {} or v

		if not config.on_attach then
			config.on_attach = M.on_attach
		end
		if not config.capabilities then
			config.capabilities = M.capabilities
		end

		lspconfig[lsp].setup(config)
	end
end

return M
