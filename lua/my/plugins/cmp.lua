local M = {}

local cmp = require "cmp"
local luasnip = require "luasnip"
local lspkind = require "lspkind"

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

M.config = {
	sources = cmp.config.sources {
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lsp", max_item_count = 10 },
		{ name = "luasnip", max_item_count = 10 },
		{ name = "buffer", max_item_count = 10 },
		{ name = "path", max_item_count = 10 },
		{ name = "neorg", max_item_count = 10 },
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-e>"] = cmp.mapping {
			i = function(fallback)
				if cmp.visible() then
					cmp.abort()
				elseif luasnip.choice_active() then
					luasnip.change_choice(1)
				else
					fallback()
				end
			end,
			c = cmp.mapping.close(),
		},
		["<C-y>"] = cmp.config.disable,
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<CR>"] = cmp.mapping.confirm { select = false },
	},
	format = lspkind.cmp_format {
		mode = 'symbol',
		maxwidth = 40,
	}
}

M.setup = function()
	cmp.setup(M.config)

	local cmp_autopairs = require "nvim-autopairs.completion.cmp"
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
end

return M
