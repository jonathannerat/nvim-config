local M = {}

local has_custom, custom = pcall(function()
	return require "my.custom"
end)

if has_custom then
	custom.mt = {
		__index = require "my.defaults"
	}
	setmetatable(custom, custom.mt)
else
	custom = require "my.defaults"
end

function M.custom(key)
	return custom[key]
end

function M.find_projects(folder)
	local pickers = require "telescope.pickers"
	local finders = require "telescope.finders"
	local conf = require("telescope.config").values
	local actions = require "telescope.actions"
	local action_state = require "telescope.actions.state"
	local make_entry = require "telescope.make_entry"

	local opts = {}
	local projects_folder = folder or "~/projects/"

	pickers.new(opts, {
		prompt_title = "Projects",
		finder = finders.new_oneshot_job({ "fd", "-d", "1", "-t", "d" }, {
			cwd = projects_folder,
			entry_maker = make_entry.gen_from_file { path_display = { "tail" } },
		}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				vim.fn.chdir(projects_folder .. selection[1])
				vim.api.nvim_command "NvimTreeOpen"
			end)
			return true
		end,
	}):find()
end

return M
