local telescope = require "telescope"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local lga_actions = require "telescope-live-grep-args.actions"

local M = {}

--- opens the selected file on your system's default file opener
local function action_open(prompt_bufnr)
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

local extensions = {
   fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
   },
   live_grep_args = {
      mappings = { -- extend mappings
         i = {
            ["<C-k>"] = lga_actions.quote_prompt(),
            ["<C-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
         },
      },
   },
}

M.pickers = {}

local simple_pickers = {
   {
      name = "projects",
      title = "Projects",
      command = "find ~/projects/ -mindepth 1 -maxdepth 1 -type d -printf '%f\\n'",
      opts = {
         attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
               actions.close(prompt_bufnr)
               local selection = action_state.get_selected_entry()
               vim.fn.chdir("~/projects/" .. selection[1])
               vim.api.nvim_command "Neotree reveal"
            end)
            return true
         end,
      },
   },
}

for _, picker_spec in ipairs(simple_pickers) do
   local opts = picker_spec.opts

   opts.prompt_title = picker_spec.title
   opts.finder = finders.new_oneshot_job({ "sh", "-c", picker_spec.command }, {})
   opts.sorter = conf.generic_sorter()

   M.pickers[picker_spec.name] = function()
      pickers.new({}, opts):find()
   end
end

M.setup = function()
   local extension_configs = {}
   local extension_names = {}

   for extk, extv in pairs(extensions) do
      local name = extk

      if type(extk) == "string" and type(extv) == "table" then
         extension_configs[extk] = extv
      elseif type(extv) == "string" then
         name = extv
      end

      extension_names[#extension_names + 1] = name
   end

   telescope.setup {
      defaults = {
         file_previewer = previewers.vim_buffer_cat.new,
         grep_previewer = previewers.vim_buffer_vimgrep.new,
         path_display = function(_, path)
            local tail = require("telescope.utils").path_tail(path)
            return string.format("%s (%s)", tail, path)
         end,
         mappings = {
            i = {
               ["<C-o>"] = action_open,
               ["<C-Down>"] = "cycle_history_next",
               ["<C-Up>"] = "cycle_history_prev",
               ["<C-r>"] = "delete_buffer",
               ["<C-h>"] = "which_key",
               ["<C-k>"] = "select_drop",
            },
         },
      },
      extensions = extension_configs,
   }

   for _, ext in pairs(extension_names) do
      telescope.load_extension(ext)
   end
end

return M
