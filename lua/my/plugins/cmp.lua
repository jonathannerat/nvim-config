local M = {}

local cmp = require("cmp")

local function t(str)
	vim.fn.feedkeys(vim.api.nvim_replace_termcodes(str, true, true, true), '')
end

M.setup_config = {
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
	completion = {
		documentation = {
			border = "single",
			maxheight = 10,
		}
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end
	},
	mapping = {
		['<Tab>'] = function(fallback)
			if vim.fn.pumvisible() == 1 then
				t "<C-n>"
			else
				fallback()
			end
		end,
		['<S-Tab>'] = function(fallback)
			if vim.fn.pumvisible() == 1 then
				t "<C-p>"
			else
				fallback()
			end
		end,
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
