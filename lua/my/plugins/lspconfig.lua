local M = {}

local m = require'my.util.mapper'

local lualsp_path = os.getenv('HOME') .. '/.local/src/lua-language-server/'

local luadev = require'lua-dev'.setup {
	lspconfig = {
		cmd = {
				lualsp_path .. 'bin/Linux/lua-language-server',
				'-E',
				lualsp_path .. 'main.lua'
		}
	}
}

M.lsp_servers = {
	bashls = {},
	ccls = {},
	cssls = {},
	jsonls = {
		cmd = { 'json-languageserver', '--stdio' }
	},
	pyright = {},
	rust_analyzer = {},
	solargraph = {},
	sumneko_lua = luadev,
	texlab = {},
	tsserver = {},
	vimls = {},
}

M.lsp_signature_config = {
	bind = true,
	doc_lines = 2,
	hint_enable = false,
	handler_opts = {
		border = 'single',
	}
}

M.default_mappings = {
	['n|ns|<C-k>']      = m.cmd('lua vim.lsp.buf.signature_help()'),
	['n|ns|<leader>A']  = m.cmd('lua vim.lsp.buf.code_action()'),
	['n|ns|<leader>R']  = m.cmd('lua vim.lsp.buf.rename()'),
	['n|ns|K']          = m.cmd('lua vim.lsp.buf.hover()'),
	['n|ns|[d']         = m.cmd('lua vim.lsp.diagnostic.goto_prev()'),
	['n|ns|]d' ]        = m.cmd('lua vim.lsp.diagnostic.goto_next()'),
	['n|ns|gD']         = m.cmd('lua vim.lsp.buf.declaration()'),
	['n|ns|gd']         = m.cmd('lua vim.lsp.buf.definition()'),
	['n|ns|gi']         = m.cmd('lua vim.lsp.buf.implementation()'),
	['n|ns|gr']         = m.cmd('lua vim.lsp.buf.references()'),
}

M.on_attach = function(client, bufnr)
	-- share this instance for all buffers
	local mappings = M.default_mappings

	if client.resolved_capabilities.document_formatting then
		-- create a copy for a specific buffer if it has more capabilities
		mappings = vim.fn.copy(M.default_mappings)
		mappings['n|ns|<leader>sf'] = m.cmd('lua vim.lsp.buf.formatting()')
	end

	if client.resolved_capabilities.document_range_formatting then
		-- only create one copy
		mappings = mappings == M.default_mappings and vim.fn.copy(M.default_mappings) or mappings
		mappings['v|ns|<leader>sf'] = m.cmd('lua vim.lsp.buf.range_formatting()')
	end

	m.bind(mappings, bufnr)

	require'lsp_signature'.on_attach(M.lsp_signature_config)
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		'documentation',
		'detail',
		'additionalTextEdits',
	}
}

function M.config()
	local lspconfig = require'lspconfig'

	for lsp, config in pairs(M.lsp_servers) do
		if not config.on_attach    then config.on_attach    = M.on_attach end
		if not config.capabilities then config.capabilities = M.capabilities end

		lspconfig[lsp].setup(config)
	end
end

return M
