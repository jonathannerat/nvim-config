local telescope = require "telescope"
local previewers = require "telescope.previewers"
local action_state = require "telescope.actions.state"
local path_tail = require("telescope.utils").path_tail

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

local extensions = {
   fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
   },
   live_grep_args = function()
      local lga_actions = require "telescope-live-grep-args.actions"

      return {
         mappings = { -- extend mappings
            i = {
               ["<C-k>"] = lga_actions.quote_prompt(),
               ["<C-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
            },
         },
      }
   end,
}

local available_extensions = {}

for name, config in pairs(extensions) do
   local ok = pcall(require, "telescope._extension." .. name)

   if ok then
      available_extensions[name] = type(config) == "function" and config() or config
   end
end

telescope.setup {
   defaults = {
      file_previewer = previewers.vim_buffer_cat.new,
      grep_previewer = previewers.vim_buffer_vimgrep.new,
      path_display = function(_, path)
         return string.format("%s (%s)", path_tail(path), path)
      end,
      mappings = {
         i = {
            ["<C-o>"] = actions_system_open,
            ["<C-Down>"] = "cycle_history_next",
            ["<C-Up>"] = "cycle_history_prev",
            ["<C-r>"] = "delete_buffer",
            ["<C-j>"] = "select_drop",
            ["<C-k>"] = "select_tab_drop",
         },
      },
   },
   extensions = available_extensions,
}

for ext, _ in pairs(available_extensions) do
   telescope.load_extension(ext)
end

local kmap = vim.keymap.set

kmap("n", "<LEADER>fb", ":Telescope buffers<CR>")
kmap("n", "<LEADER>fh", ":Telescope help_tags<CR>")
kmap("n", "<LEADER>fm", ":Telescope man_pages<CR>")
kmap("n", "<LEADER>fo", ":Telescope oldfiles<CR>")
kmap("n", "<LEADER>fr", ":Telescope resume<CR>")
kmap("n", "<LEADER>ft", ":Telescope treesitter<CR>")
kmap("n", "<LEADER>ff", function()
   require("telescope.builtin").find_files {
      find_command = "fd",
      layout_config = {
         preview_cutoff = 120,
      },
   }
end)
kmap("n", "<LEADER>ff", function()
   require("telescope.builtin").find_files {
      find_command = { "fd", "-t", "f", "-t", "l", "-H", "--no-ignore-vcs" },
      layout_config = {
         preview_cutoff = 120,
      },
   }
end)
kmap("n", "<LEADER>fl", function()
   require("telescope").extensions.live_grep_args.live_grep_args {
      layout_strategy = "vertical",
      layout_config = { prompt_position = "top", mirror = true },
   }
end)
