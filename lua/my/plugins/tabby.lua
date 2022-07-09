local M = {}

local hl = require "tabby.module.highlight"
local filename = require "tabby.module.filename"
local tab = require "tabby.tab"
local win = require "tabby.win"

local hl_tabline = hl.extract "TabLine"
local hl_tabline_sel = hl.extract "TabLineSel"

local tabno = vim.api.nvim_tabpage_get_number

local tabwins = vim.api.nvim_tabpage_list_wins

local function mod_indicator(winid)
   return vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(winid), "modified") and "[+]" or ""
end

local function tabname(id)
   local ok, result = pcall(vim.api.nvim_tabpage_get_var, id, 'tabby_tab_name')
   if ok then
      return result
   end
   local focus_win = tab.get_current_win(id)
   local name = ""
   if vim.api.nvim_win_get_config(focus_win).relative ~= "" then
      name = "[Floating]"
   else
      name = win.get_bufname(focus_win)
   end
   return name
end

---@type TabbyTablineOpt
M.tabline = {
   hl = "TabLineFill",
   layout = "active_wins_at_tail",
   active_tab = {
      label = function(tabid)
         return {
            string.format(" #%d %s (%d) ", tabno(tabid), tabname(tabid), #tabwins(tabid)),
            hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = "bold" },
         }
      end,
      right_sep = { " ", hl = "TabLineFill" },
   },
   inactive_tab = {
      label = function(tabid)
         return {
            string.format(" #%d %s (%d) ", tabno(tabid), tabname(tabid), #tabwins(tabid)),
            hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = "bold" },
         }
      end,
      right_sep = { " ", hl = "TabLineFill" },
   },
   top_win = {
      label = function(winid)
         return {
            string.format(
               " > %s: %s %s ",
               vim.api.nvim_win_get_buf(winid),
               filename.unique(winid),
               mod_indicator(winid)
            ),
            hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = "bold" },
         }
      end,
      left_sep = { " ", hl = "TabLineFill" },
   },
   win = {
      label = function(winid)
         return {
            string.format(
               " - %s: %s %s",
               vim.api.nvim_win_get_buf(winid),
               filename.unique(winid),
               mod_indicator(winid)
            ),
            hl = { fg = hl_tabline.fg, bg = hl_tabline.bg },
         }
      end,
      left_sep = { " ", hl = "TabLineFill" },
   },
}

M.setup = function()
   require("tabby").setup {
      tabline = M.tabline,
   }
end

return M
