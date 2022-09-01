local Mapper = require "my.util.mapper"
local utils = require "my.utils"

local vimcmd, luacmd = utils.vimcmd, utils.luacmd
local map = Mapper:new()

map:mode("normal", function(m)
   m:with_options({ silent = true, noremap = true }, {
      ["<c-n>"] = vimcmd "Neotree toggle",
      ["<c-e>"] = vimcmd "Neotree reveal",
      ["<c-t>"] = vimcmd "tabnew",
      ["<leader>A"] = vimcmd "Alpha",
      ["<leader>C"] = vimcmd "ColorizerToggle",
      ["<leader>F"] = vimcmd "FormatWrite",
      ["<leader>Q"] = vimcmd "q!",
      ["<leader>Qa"] = vimcmd "qa!",
      ["<leader>cd"] = vimcmd "lcd %:h",
      ["<leader>ci"] = vimcmd "exe 'e ' .. stdpath('config') .. '/init.lua'",
      ["<leader>cm"] = vimcmd "exe 'e ' .. stdpath('config') .. '/lua/my/mappings.lua'",
      ["<leader>co"] = vimcmd "exe 'e ' .. stdpath('config') .. '/lua/my/options.lua'",
      ["<leader>cp"] = vimcmd "exe 'e ' .. stdpath('config') .. '/lua/my/plugins/init.lua'",
      ["<leader>f"] = vimcmd "Format",
      ["<leader>fF"] = vimcmd "Telescope find_files find_command=fd,-t,f,-t,l,-H,--no-ignore-vcs",
      ["<leader>fG"] = vimcmd "Telescope git_files git_dir=~/.local/src/dotrepo show_untracked=false",
      ["<leader>fM"] = vimcmd "Telescope media_files",
      ["<leader>fb"] = vimcmd "Telescope buffers",
      ["<leader>fd"] = vimcmd "Telescope find_files find_command=fd,-t,d,-L cwd=~",
      ["<leader>ff"] = vimcmd "Telescope find_files find_command=fd,-t,f,-t,l,-H previewer=false layout={width=0.6}",
      ["<leader>fg"] = vimcmd "Telescope git_files show_untracked=false previewer=false layout={width=0.6}",
      ["<leader>fh"] = vimcmd "Telescope help_tags",
      ["<leader>fl"] = vimcmd "Telescope live_grep layout_strategy=vertical",
      ["<leader>fm"] = vimcmd "Telescope man_pages",
      ["<leader>ft"] = vimcmd "Telescope treesitter",
      ["<leader>g"] = vimcmd "G",
      ["<leader>gP"] = vimcmd 'TermExec cmd="git push"',
      ["<leader>gT"] = vimcmd "tabmove-",
      ["<leader>gc"] = vimcmd "Git commit",
      ["<leader>gm"] = vimcmd "Git mergetool",
      ["<leader>gp"] = vimcmd 'TermExec cmd="git pull"',
      ["<leader>gt"] = vimcmd "tabmove+",
      ["<leader>hh"] = vimcmd "noh",
      ["<leader>ht"] = [[/\s\+$<cr>]],
      ["<leader>mp"] = vimcmd "MarkdownPreviewToggle",
      ["<leader>pc"] = vimcmd "PackerClean",
      ["<leader>pi"] = vimcmd "PackerInstall",
      ["<leader>pp"] = vimcmd "PackerCompile profile=true",
      ["<leader>ps"] = vimcmd "PackerSync",
      ["<leader>pu"] = vimcmd "PackerUpdate",
      ["<leader>q"] = vimcmd "q",
      ["<leader>qa"] = vimcmd "qa",
      ["<leader>r"] = vimcmd "e %",
      ["<leader>tD"] = vimcmd "Trouble lsp_document_diagnostics",
      ["<leader>tR"] = vimcmd "TroubleRefresh",
      ["<leader>td"] = vimcmd "Trouble lsp_definitions",
      ["<leader>th"] = vimcmd "TSHighlightCapturesUnderCursor",
      ["<leader>tp"] = vimcmd "TSPlaygroundToggle",
      ["<leader>tr"] = vimcmd "Trouble lsp_references",
      ["<leader>tt"] = vimcmd "TroubleToggle",
      ["<leader>w"] = vimcmd "w",
      ["<leader>zi"] = luacmd 'require("my.plugins.zk").index()',
      ["<leader>zn"] = luacmd 'require("my.plugins.zk").new { title = vim.fn.input "Title: ", dir = vim.fn.input "Dir: " }',
      ["<m-j>"] = ":m .+1<CR>==",
      ["<m-k>"] = ":m .-2<CR>==",
   })

   m:with_noremap {
      ["<space>"] = "",
      ["Q"] = "",
   }
end)

map:mode("insert", function(m)
   m:with_options({ silent = true, noremap = true }, {
      ["<m-j>"] = "<esc>:m .+1<CR>==gi",
      ["<m-k>"] = "<esc>:m .-2<CR>==gi",
   })

   m:with_noremap {
      jj = "<esc>",
      kk = "<esc>",
   }
end)

map:mode("select", function(m)
   m:with_options({ silent = true, expr = true }, {
      ["<c-e>"] = "luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<c-e>'",
   })
end)

map:with_options({ silent = true, noremap = true }, function(m)
   m:mode("command", {
      ["<c-j>"] = "<down>",
      ["<c-k>"] = "<up>",
   })

   m:mode("terminal", {
      ["<c-m-q>"] = [[<c-\><c-n>]],
   })

   m:mode("visual", {
      ["<m-j>"] = ":m '>+1<cr>gv=gv",
      ["<m-k>"] = ":m '<-2<cr>gv=gv",
   })
end)
