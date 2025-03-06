local config = require("my.utils").config
local custom_parsers config "treesitter.parsers"

if custom_parsers then
   local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

   for parser_name, parser_config in pairs(custom_parsers) do
      parser_configs[parser_name] = parser_config
   end
end

require("nvim-treesitter.configs").setup {
   ensure_installed = config "treesitter.ensure_installed",
   highlight = { enable = true },
   incremental_selection = { enable = true },
   indent = { enable = true },

   textobjects = {
      select = {
         enable = true,
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
}
