local option = require "user.option"
local conditions = require "heirline.conditions"
local utils = require "heirline.utils"

local kanagawa = require("kanagawa.colors").setup { theme = option "variant" }
local palette_colors = kanagawa.palette
local theme_colors = kanagawa.theme

local colors = {
   bg = palette_colors.sumiInk0,
   bg_dark = palette_colors.sumiInk1,
   bg_darker = palette_colors.sumiInk0,
   bg_light = palette_colors.sumiInk2,
   bg_lighter = palette_colors.sumiInk4,
   fg = palette_colors.fujiWhite,
   fg_dark = palette_colors.oldWhite,
   fg_darker = palette_colors.oldWhite,
   red = palette_colors.peachRed,
   green = palette_colors.springGreen,
   blue = palette_colors.crystalBlue,
   cyan = palette_colors.waveAqua2,
   yellow = palette_colors.carpYellow,
   magenta = palette_colors.sakuraPink,
   orange = palette_colors.surimiOrange,
   violet = palette_colors.oniViolet,
   primary_blue = palette_colors.crystalBlue,
   darkblue = palette_colors.waveBlue2,

   git_add = theme_colors.vcs.added,
   git_del = theme_colors.vcs.removed,
   git_change = theme_colors.vcs.changed,

   diag_error = theme_colors.diag.error,
   diag_warn = theme_colors.diag.warning,
   diag_info = theme_colors.diag.info,
   diag_hint = theme_colors.diag.hint,
}

require("heirline").load_colors(colors)

vim.fn.sign_define {
   { name = "DiagnosticSignError", text = " ", texthl = "DiagnosticSignError" },
   { name = "DiagnosticSignWarn", text = " ", texthl = "DiagnosticSignWarn" },
   { name = "DiagnosticSignInfo", text = " ", texthl = "DiagnosticSignInfo" },
   { name = "DiagnosticSignHint", text = "󰌵 ", texthl = "DiagnosticSignHint" },
}

local ViMode = {
   init = function(self)
      self.mode = vim.fn.mode(1)
   end,

   static = {
      mode_names = {
         n = "N",
         no = "N?",
         nov = "N?",
         noV = "N?",
         ["no\22"] = "N?",
         niI = "Ni",
         niR = "Nr",
         niV = "Nv",
         nt = "Nt",
         v = "V",
         vs = "Vs",
         V = "V_",
         Vs = "Vs",
         ["\22"] = "^V",
         ["\22s"] = "^V",
         s = "S",
         S = "S_",
         ["\19"] = "^S",
         i = "I",
         ic = "Ic",
         ix = "Ix",
         R = "R",
         Rc = "Rc",
         Rx = "Rx",
         Rv = "Rv",
         Rvc = "Rv",
         Rvx = "Rv",
         c = "C",
         cv = "Ex",
         r = "…",
         rm = "M",
         ["r?"] = "?",
         ["!"] = "!",
         t = "T",
      },
      mode_colors = {
         n = "primary_blue",
         i = "yellow",
         v = "magenta",
         V = "magenta",
         ["\22"] = "magenta",
         c = "blue",
         s = "orange",
         S = "orange",
         ["\19"] = "orange",
         R = "red",
         r = "red",
         ["!"] = "green",
         t = "green",
      },
   },

   provider = function(self)
      return "  %2(" .. self.mode_names[self.mode] .. "%) "
   end,

   hl = function(self)
      local mode = self.mode:sub(1, 1)
      return { fg = self.mode_colors[mode], bg = "bg_light", bold = true }
   end,

   update = {
      "ModeChanged",
      pattern = "*:*",
      callback = vim.schedule_wrap(function()
         vim.cmd "redrawstatus"
      end),
   },
}

local FileNameBlock = {
   init = function(self)
      self.filename = vim.api.nvim_buf_get_name(0)
   end,
}

local FileIcon = {
   init = function(self)
      local filename = self.filename
      local extension = vim.fn.fnamemodify(filename, ":e")
      self.icon, self.icon_color =
         require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
   end,

   provider = function(self)
      return self.icon and (self.icon .. " ")
   end,

   hl = function(self)
      return { fg = self.icon_color }
   end,
}

local FileName = {
   init = function(self)
      self.lfilename = vim.fn.fnamemodify(self.filename, ":~:.")
      if self.lfilename == "" then
         self.lfilename = "[No Name]"
      end
   end,

   flexible = 2,

   {
      provider = function(self)
         return self.lfilename
      end,
   },
   {
      provider = function(self)
         return vim.fn.pathshorten(self.lfilename)
      end,
   },
}

local FileFlags = {
   {
      condition = function()
         return vim.bo.modified
      end,
      provider = "[+]",
      hl = { fg = "green" },
   },

   {
      condition = function()
         return not vim.bo.modifiable or vim.bo.readonly
      end,
      provider = "",
      hl = { fg = "orange" },
   },
}

FileNameBlock = utils.insert(FileNameBlock, FileIcon, FileName, FileFlags, { provider = "%<" })

local FileType = {
   provider = function()
      return string.upper(vim.bo.filetype)
   end,

   hl = { fg = "primary_blue" },
}

local FileEncoding = {
   provider = function()
      local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
      return enc ~= "utf-8" and enc:upper()
   end,
}

local FileFormat = {
   provider = function()
      local fmt = vim.bo.fileformat
      return fmt ~= "unix" and fmt:upper()
   end,
   hl = { fg = "bg_dark", bg = "fg_dark" },
}

local FileStats = utils.insert({}, FileType, FileEncoding, FileFormat)

local Ruler = {
   provider = "%l/%L %c %p",
   hl = {
      fg = "magenta",
   },
}

local ScrollBar = {
   static = {
      sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
   },
   provider = function(self)
      local curr_line = vim.api.nvim_win_get_cursor(0)[1]
      local lines = vim.api.nvim_buf_line_count(0)
      local i
      if lines > 0 then
         i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
      else
         i = #self.sbar
      end
      return string.rep(self.sbar[i], 2)
   end,
   hl = { fg = "blue", bg = "bg_light" },
}

local LSPActive = {
   condition = conditions.lsp_attached,
   update = { "LspAttach", "LspDetach" },
   hl = { fg = "green", bold = true },

   provider = function()
      local active_clients = vim.lsp.get_active_clients { bufnr = 0 }

      return " " .. (#active_clients == 1 and "" or "[#" .. #active_clients .. "]")
   end,
}

local Navic = {
   condition = function()
      return require("nvim-navic").is_available()
   end,
   provider = function()
      return require("nvim-navic").get_location { highlight = true }
   end,
   update = "CursorMoved",
}

Navic = { flexible = 3, Navic, { provider = "" } }

local function get_icon(name)
   return vim.fn.sign_getdefined("DiagnosticSign" .. name)[1].text
end

local Diagnostics = {
   condition = conditions.has_diagnostics,

   static = {
      error_icon = get_icon "Error",
      warn_icon = get_icon "Warn",
      info_icon = get_icon "Info",
      hint_icon = get_icon "Hint",
   },

   init = function(self)
      self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
   end,

   update = { "DiagnosticChanged", "BufEnter" },

   {
      provider = function(self)
         -- 0 is just another output, we can decide to print it or not!
         return self.errors > 0 and (self.error_icon .. self.errors .. " ")
      end,
      hl = { fg = "diag_error" },
   },
   {
      provider = function(self)
         return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
      end,
      hl = { fg = "diag_warn" },
   },
   {
      provider = function(self)
         return self.info > 0 and (self.info_icon .. self.info .. " ")
      end,
      hl = { fg = "diag_info" },
   },
   {
      provider = function(self)
         return self.hints > 0 and (self.hint_icon .. self.hints)
      end,
      hl = { fg = "diag_hint" },
   },
}

local Git = {
   condition = conditions.is_git_repo,

   init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
      self.has_changes = self.status_dict.added ~= 0
         or self.status_dict.removed ~= 0
         or self.status_dict.changed ~= 0
   end,

   hl = { fg = "orange" },

   { -- git branch name
      provider = function(self)
         return " " .. self.status_dict.head
      end,
      hl = { bold = true },
   },

   -- You could handle delimiters, icons and counts similar to Diagnostics
   {
      condition = function(self)
         return self.has_changes
      end,
      provider = "(",
   },

   {
      provider = function(self)
         local count = self.status_dict.added or 0
         return count > 0 and (" " .. count)
      end,
      hl = { fg = "git_add" },
   },

   {
      provider = function(self)
         local count = self.status_dict.removed or 0
         return count > 0 and (" " .. count)
      end,
      hl = { fg = "git_del" },
   },

   {
      provider = function(self)
         local count = self.status_dict.changed or 0
         return count > 0 and (" " .. count)
      end,
      hl = { fg = "git_change" },
   },

   {
      condition = function(self)
         return self.has_changes
      end,
      provider = ")",
   },
}

local TerminalName = {
   -- we could add a condition to check that buftype == 'terminal'
   -- or we could do that later (see #conditional-statuslines below)
   provider = function()
      local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
      return " " .. tname
   end,
   hl = { fg = "blue", bold = true },
}

local HelpFileName = {
   condition = function()
      return vim.bo.filetype == "help"
   end,
   provider = function()
      local filename = vim.api.nvim_buf_get_name(0)
      return vim.fn.fnamemodify(filename, ":t")
   end,
   hl = { fg = colors.blue },
}

local Spell = {
   condition = function()
      return vim.wo.spell
   end,
   provider = "  ",
   hl = { bold = true, fg = "orange" },
}

local Align = { provider = "%=" }

local Space = { provider = " " }

-- stylua: ignore
local DefaultStatusline = {
   ViMode, Space, FileNameBlock, Space, Git, Space, Diagnostics, Align,
   Navic, Align,
   LSPActive, Space, Spell, FileStats, Space, Ruler, Space, ScrollBar,
}

local InactiveStatusline = {
   condition = conditions.is_not_active,
   FileType,
   Space,
   FileName,
   Align,
}

local SpecialStatusline = {
   condition = function()
      return conditions.buffer_matches {
         buftype = { "nofile", "prompt", "help", "quickfix" },
         filetype = { "^git.*", "fugitive" },
      }
   end,

   Align,
   FileType,
   Space,
   HelpFileName,
   Align,
}

local TerminalStatusline = {
   condition = function()
      return conditions.buffer_matches { buftype = { "terminal" } }
   end,

   hl = { bg = "darkblue" },

   -- Quickly add a condition to the ViMode to only show it when buffer is active!
   { condition = conditions.is_active, ViMode, Space },

   FileType,
   Space,
   TerminalName,
   Align,
}

local StatusLines = {
   hl = function()
      if conditions.is_active() then
         return "StatusLine"
      else
         return "StatusLineNC"
      end
   end,

   -- the first statusline with no condition, or which condition returns true is used.
   -- think of it as a switch case with breaks to stop fallthrough.
   fallthrough = false,

   SpecialStatusline,
   TerminalStatusline,
   InactiveStatusline,
   DefaultStatusline,
}

local TabpageTabnr = {
   provider = function(self)
      return tostring(self.tabnr) .. ". "
   end,
}

-- we redefine the filename component, as we probably only want the tail and not the relative path
local TabpageFilename = {
   provider = function(self)
      -- self.filename will be defined later, just keep looking at the example!
      local filename = self.filename
      filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
      return filename
   end,
   hl = function(self)
      return { bold = self.is_active or self.is_visible, italic = true }
   end,
}

local TabpageFileFlags = {
   {
      condition = function(self)
         return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
      end,
      provider = " [+]",
      hl = { fg = "green" },
   },
   {
      condition = function(self)
         return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
            or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
      end,
      provider = function(self)
         if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
            return "  "
         else
            return ""
         end
      end,
      hl = { fg = "orange" },
   },
}

local TabpageFileNameBlock = {
   init = function(self)
      local curwin = vim.api.nvim_tabpage_get_win(self.tabpage)
      local curbuf = vim.api.nvim_win_get_buf(curwin)
      self.bufnr = curbuf
      self.filename = vim.api.nvim_buf_get_name(self.bufnr)
   end,
   hl = function(self)
      if self.is_active then
         return "TabLineSel"
      -- why not?
      -- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
      --     return { fg = "gray" }
      else
         return "TabLine"
      end
   end,
   on_click = {
      callback = function(_, minwid, _, button)
         if button == "m" then -- close on mouse middle click
            vim.schedule(function()
               vim.api.nvim_buf_delete(minwid, { force = false })
            end)
         else
            vim.api.nvim_win_set_buf(0, minwid)
         end
      end,
      minwid = function(self)
         return self.bufnr
      end,
      name = "heirline_tabline_buffer_callback",
   },
   TabpageTabnr,
   FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
   TabpageFilename,
   TabpageFileFlags,
}

-- a nice "x" button to close the buffer
local TabpageCloseButton = {
   provider = function(self)
      return ("%%%dX  %%X"):format(self.tabnr)
   end,
   hl = { fg = "gray" },
}

-- The final touch!
local TabpageBlock = utils.surround({ "", "" }, function(self)
   if self.is_active then
      return utils.get_highlight("TabLineSel").bg
   else
      return utils.get_highlight("TabLine").bg
   end
end, { TabpageFileNameBlock, TabpageCloseButton })

local TabPages = {
   condition = function()
      return #vim.api.nvim_list_tabpages() >= 2
   end,
   utils.make_tablist(TabpageBlock),
}

require("heirline").setup {
   statusline = StatusLines,
   tabline = TabPages,
   opts = {
      colors = colors,
   },
}
