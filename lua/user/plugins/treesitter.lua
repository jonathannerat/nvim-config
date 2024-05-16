-- vi: fdm=marker
local parsers = {
   x86asm = {
      install_info = {
         url = "https://github.com/bearcove/tree-sitter-x86asm",
         files = { "src/parser.c" },
         branch = "main",
      },
   },
   gotmpl = {
      install_info = {
         url = "https://github.com/ngalaiko/tree-sitter-go-template",
         files = { "src/parser.c" },
      },
      filetypes = { "gotmpl" },
      used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl" },
   },
}

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

for parser, parser_config in pairs(parsers) do
   parser_configs[parser] = parser_config
end

require("nvim-treesitter.configs").setup {
   highlight = {
      enable = true,
      disable = { "tex", "latex" }, -- conflicts with vimtex's conceals
   },
   incremental_selection = { enable = true },
   indent = { enable = true },
   playground = { enable = true },
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
         goto_next_end = {
            ["]M"] = "@function.outer",
            ["]I"] = "@conditional.outer",
         },
         goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[i"] = "@conditional.outer",
         },
         goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[I"] = "@conditional.outer",
         },
      },
   },
   ts_context_commentstring = {
      enable = true,
   },
} -- }}}
