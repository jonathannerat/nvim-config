local neotree = require "neo-tree"
local manager = require "neo-tree.sources.manager"

local M = {
   config = {
      close_if_last_window = true,
      sources = {
         "filesystem",
         "buffers",
         "git_status",
      },
      source_selector = {
         winbar = true,
         statusline = false, -- toggle to show selector on statusline
         content_layout = "center",
         tabs_layout = "equal",
         tab_labels = {
            filesystem = "" .. " Files",
            buffers = "" .. " Bufs",
            git_status = "" .. " Git",
            diagnostics = "裂" .. " Diags",
         },
      },
      default_component_configs = {
         indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side

            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
         },
         modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
         },
         name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
         },
      },
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
               manager.close_all()
            end,
         },
      },
   },
}

M.setup = function()
   neotree.setup(M.config)
end

return M
