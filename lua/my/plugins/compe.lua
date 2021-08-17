local M = {}

M.setup_config = {
	enabled = true,
	autocomplete = true,
	documentation = true,
	min_length = 1,
	preselect = "enable",
	throttle_time = 80,
	source_timeout = 200,
	incomplete_delay = 400,
	max_abbr_width = 100,
	max_kind_width = 100,
	max_menu_width = 100,
	source = {
		luasnip = {
			enable = true,
			priority = 20,
		},
		nvim_lsp = {
			enable = true,
			priority = 10,
		},
		buffer = {
			enable = true,
			priority = 1,
		},
		spell = {
			enable = true,
			filetypes = { "text", "tex", "mail", "gitcommit" },
		},
		path = true,
		neorg = true,
	},
}

M.completion_item_kind = {
	"   (Text) ",
	"   (Method)",
	"   (Function)",
	"   (Constructor)",
	" ﴲ  (Field)",
	"[] (Variable)",
	"   (Class)",
	" ﰮ  (Interface)",
	"   (Module)",
	" 襁 (Property)",
	"   (Unit)",
	"   (Value)",
	" 練 (Enum)",
	"   (Keyword)",
	"   (Snippet)",
	"   (Color)",
	"   (File)",
	"   (Reference)",
	"   (Folder)",
	"   (EnumMember)",
	" ﲀ  (Constant)",
	" ﳤ  (Struct)",
	"   (Event)",
	"   (Operator)",
	"   (TypeParameter)",
}

M.config = function()
	vim.lsp.protocol.CompletionItemKind = M.completion_item_kind

	require("compe").setup(M.setup_config)
end

return M
