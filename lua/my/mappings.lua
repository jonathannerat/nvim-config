local Mapper = require "my.util.mapper"
local utils = require "my.utils"

local vimcmd, luacmd = utils.vimcmd, utils.luacmd
local map = Mapper:new()

map:mode("normal", function(m)
   m:with_options({ silent = true, noremap = true }, {
      ["g<"] = vimcmd "tabmove-",
      ["g>"] = vimcmd "tabmove+",
      ["<c-n>"] = vimcmd "Neotree toggle",
      ["<M-e>"] = vimcmd "Neotree reveal",
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
      ["<leader>cp"] = vimcmd "exe 'e ' .. stdpath('config') .. '/lua/my/plugins.lua'",
      ["<leader>f"] = vimcmd "Format",
      ["<leader>fF"] = vimcmd "Telescope find_files find_command=fd,-t,f,-t,l,-H,--no-ignore-vcs previewer=false layout={width=0.6}",
      ["<leader>fb"] = vimcmd "Telescope buffers",
      ["<leader>fd"] = vimcmd "Telescope find_files git_status",
      ["<leader>ff"] = vimcmd "Telescope find_files find_command=fd,-t,f,-t,l previewer=false layout={width=0.6}",
      ["<leader>fg"] = vimcmd "Telescope git_files show_untracked=false previewer=false layout={width=0.6}",
      ["<leader>fh"] = vimcmd "Telescope help_tags",
      ["<leader>fl"] = luacmd "require('telescope').extensions.live_grep_args.live_grep_args { layout_strategy='vertical', layout_config = {prompt_position='top', mirror=true} }",
      ["<leader>fm"] = vimcmd "Telescope man_pages",
      ["<leader>fo"] = vimcmd "Telescope oldfiles",
      ["<leader>fr"] = vimcmd "Telescope resume",
      ["<leader>ft"] = vimcmd "Telescope treesitter",
      ["<leader>g"] = vimcmd "Lazygit",
      ["<leader>hh"] = vimcmd "noh",
      ["<leader>ht"] = [[/\s\+$<cr>]],
      ["<leader>mp"] = vimcmd "MarkdownPreviewToggle",
      ["<leader>q"] = vimcmd "q",
      ["<leader>qa"] = vimcmd "qa",
      ["<leader>r"] = vimcmd "e %",
      ["<leader>tt"] = luacmd "require('neotest').run.run()",
      ["<leader>tf"] = luacmd "require('neotest').run.run(vim.fn.expand('%'))",
      ["<leader>to"] = luacmd "require('neotest').output.open({ enter = true, last_run = true})",
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
      jk = "<esc>",
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
