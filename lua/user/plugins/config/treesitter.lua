return {
   parsers = {
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
   },
   opts = {
      ensure_installed = {
         "c",
         "cpp",
         "css",
         "haskell",
         "html",
         "javascript",
         "lua",
         "markdown",
         "markdown_inline",
         "php",
         "vim",
         "vue",
      },
      highlight = {
         enable = true,
         disable = { "tex", "latex", "html", "php" }, -- conflicts with vimtex's concela
      },
      incremental_selection = { enable = true },
      indent = { enable = true },
      playground = { enable = true },
      textobjects = {
         select = {
            enable = true,
            disable = { "tex", "latex" },
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
      context_commentstring = {
         enable = true,
      },
      autotag = {
         enable = true,
         filetypes = { "html", "xml", "vue", "php" },
      },
   },
}
