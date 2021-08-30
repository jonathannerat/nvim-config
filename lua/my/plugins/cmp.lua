local M = {}

local cmp = require("cmp")

local function t(str)
	vim.fn.feedkeys(vim.api.nvim_replace_termcodes(str, true, true, true), '')
end

local function keyremap(sequence)
	return function(fallback)
		if vim.fn.pumvisible() == 1 then
			t(sequence)
		else
			fallback()
		end
	end
end

M.setup_config = {
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
	documentation = {
		border = "rounded",
		maxheight = 10,
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end
	},
	mapping = {
		['<Tab>'] = cmp.mapping(keyremap "<C-n>", { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(keyremap "<C-n>", { 'i', 's' }),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		})
	},
}

M.config = function()
	cmp.setup(M.setup_config)
end

return M
