local dashboard = require "alpha.themes.dashboard"

local M = {}

-- Set header
dashboard.section.header.val = {
   "                  ▄",
   "                 ▟█▙",
   "                ▟███▙",
   "               ▟█████▙",
   "              ▟███████▙",
   "             ▂▔▀▜██████▙",
   "            ▟██▅▂▝▜█████▙",
   "           ▟█████████████▙",
   "          ▟███████████████▙",
   "         ▟█████████████████▙",
   "        ▟███████████████████▙",
   "       ▟█████████▛▀▀▜████████▙",
   "      ▟████████▛      ▜███████▙",
   "     ▟█████████        ████████▙",
   "    ▟██████████        █████▆▅▄▃▂",
   "   ▟██████████▛        ▜█████████▙",
   "  ▟██████▀▀▀              ▀▀██████▙",
   " ▟███▀▘                       ▝▀███▙",
   "▟▛▀                               ▀▜▙",
}

-- Set menu
dashboard.section.buttons.val = {
   dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
   dashboard.button(
      "f",
      "  > Find file here",
      ":cd . | :Telescope find_files find_command=fd,-t,f,-t,l previewer=false layout={width=0.6}<CR>"
   ),
   dashboard.button("p", "  > Find projects", ":lua require'my.plugins.telescope'.pickers.projects()<CR>"),
   dashboard.button("g", "  > Git", "<cmd>Lazygit<cr>"),
   dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
   dashboard.button("s", "  > Settings", ":exec 'edit ' . resolve($MYVIMRC) | Neotree show <CR>"),
   dashboard.button("l", "鈴 > Lazy", ":Lazy<cr>"),
   dashboard.button("n", "  > News", ":vert help news | exec '80wincmd|' <CR>"),
   dashboard.button("q", "  > Quit NVIM", ":q<CR>"),
}

M.setup = function()
   -- Send config to alpha
   require("alpha").setup(dashboard.opts)
   -- Disable folding on alpha buffer
   vim.cmd [[
autocmd FileType alpha setlocal nofoldenable
	]]
end

return M
