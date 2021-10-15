local M = {}

local cmp = require("cmp")

M.setup_config = {
	sources = {
		{ name = "nvim_lsp", max_item_count = 10 },
		{ name = "luasnip", max_item_count = 10 },
		{ name = "buffer", max_item_count = 10 },
		{ name = "path", max_item_count = 10 },
		{ name = "neorg", max_item_count = 10 },
	},
	documentation = {
		border = "rounded",
		maxwidth = 80,
		maxheight = 10,
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end
	},
	mapping = {
		['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-e>'] = cmp.mapping.close(),
	},
}

M.config = function()
	cmp.setup(M.setup_config)
end

return M
