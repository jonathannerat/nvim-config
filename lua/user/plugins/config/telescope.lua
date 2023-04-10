local previewers = require "telescope.previewers"
local action_state = require "telescope.actions.state"
local lga_actions = require "telescope-live-grep-args.actions"

--- opens the selected file on your system's default file opener
local function actions_system_open(prompt_bufnr)
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

return {
   defaults = {
      file_previewer = previewers.vim_buffer_cat.new,
      grep_previewer = previewers.vim_buffer_vimgrep.new,
      path_display = function(_, path)
         local tail = require("telescope.utils").path_tail(path)
         return string.format("%s (%s)", tail, path)
      end,
      mappings = {
         i = {
            ["<C-o>"] = actions_system_open,
            ["<C-Down>"] = "cycle_history_next",
            ["<C-Up>"] = "cycle_history_prev",
            ["<C-r>"] = "delete_buffer",
            ["<C-h>"] = "which_key",
            ["<C-k>"] = "select_drop",
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
      live_grep_args = {
         mappings = { -- extend mappings
            i = {
               ["<C-k>"] = lga_actions.quote_prompt(),
               ["<C-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
            },
         },
      },
   },
}
