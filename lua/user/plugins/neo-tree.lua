local function system_open(state)
   local opener = "xdg-open"

   if vim.fn.has "macunix" == 1 then
      opener = "open"
   elseif vim.fn.has "win32" == 1 then
      opener = "start"
   end

   local node = state.tree:get_node()
   os.execute(("%s '%s'"):format(opener, node.path))
end

require("neo-tree").setup {
   window = {
      mappings = {
         ["<c-v>"] = "vsplit_with_window_picker",
         ["<c-x>"] = "split_with_window_picker",
         ["<space>"] = "noop",
         S = "noop",
         o = "toggle_node",
         s = { system_open, desc = "open with system" },
         v = "open_vsplit",
         x = "open_split",
      },
   },
}

local kmap = vim.keymap.set
kmap("n", "<M-e>", ":Neotree filesystem toggle<CR>")
kmap("n", "<M-f>", ":Neotree filesystem reveal<CR>")
