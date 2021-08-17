local t = require "telescope"
local tp = require "telescope.previewers"

local M = {}

M.extensions = { "fzf", "projects" }

--- opens the selected file on your system's default file opener
local function action_open(prompt_bufnr)
	local action_state = require "telescope.actions.state"
	local Path = require "plenary.path"
	local entry = action_state.get_selected_entry()

	if not entry then
		print "[telescope] Nothing currently selected"
		return
	end

	local filename = Path.new(entry.path or entry.filename)

	if not filename then
		print "[telescope] No filename in selected entry"
	end

	filename:normalize(vim.loop.cwd())

	local opener = "xdg-open"

	if vim.fn.has "macunix" == 1 then
		opener = "open"
	elseif vim.fn.has "win32" == 1 then
		opener = "start"
	end

	require("telescope.actions").close(prompt_bufnr)

	os.execute(string.format("%s %s", opener, filename))
end

function M.config()
	t.setup {
		defaults = {
			file_previewer = tp.vim_buffer_cat.new,
			grep_previewer = tp.vim_buffer_vimgrep.new,
			mappings = {
				i = {
					["<c-o>"] = action_open,
				},
			},
		},
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = false,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		},
	}

	for _, e in ipairs(M.extensions) do
		t.load_extension(e)
	end
end

return M
