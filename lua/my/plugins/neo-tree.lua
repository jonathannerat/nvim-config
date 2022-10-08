local neotree = require "neo-tree"

local M = {
   config = {
      enable_git_status = false,
      enable_diagnostics = false,
      window = {
         mappings = {
            ["<c-x>"] = "split_with_window_picker",
            ["<c-v>"] = "vsplit_with_window_picker",
            ["<c-t>"] = "open_tabnew",
            o = {
               "toggle_node",
               nowait = false,
            },
         },
      },
      event_handlers = {
         {
            event = "file_opened",
            handler = function()
               neotree.close "filesystem"
            end,
         },
      },
   },
}

M.setup = function()
   neotree.setup(M.config)
end

return M
