local option = require "user.options"

local ensure_installed = vim.fn.extend({
   "c",
   "lua",
   "vim",
   "vimdoc",
   "query",
}, option("treesitter.also_install", {}))

return {
   parsers = option("treesitter.parsers", {}),
   opts = {
      ensure_installed = ensure_installed,
      highlight = {
         enable = true,
         disable = { "latex" }, -- conflicts with vimtex's concela
      },
      incremental_selection = { enable = true },
      indent = { enable = true },
      textobjects = {
         select = {
            enable = true,
            disable = { "latex" },
            lookahead = true,
            keymaps = {
               -- You can use the capture groups defined in textobjects.scm
               ["af"] = "@function.outer",
               ["if"] = "@function.inner",
               ["ac"] = "@class.outer",
               ["ic"] = "@class.inner",
            },
         },
         move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
               ["]m"] = "@function.outer",
               ["]i"] = "@conditional.outer",
            },
            goto_previous_start = {
               ["[m"] = "@function.outer",
               ["[i"] = "@conditional.outer",
            },
         },
         swap = {
            enable = true,
            swap_next = {
               ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
               ["<leader>A"] = "@parameter.inner",
            },
         },
         lsp_interop = {
            enable = true,
            border = "none",
            floating_preview_opts = {},
            peek_definition_code = {
               ["<leader>k"] = "@function.outer",
               ["<leader>K"] = "@class.outer",
            },
         },
      },
   },
}
