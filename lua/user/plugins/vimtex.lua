vim.tbl_extend("force", vim.g, {
   vimtex_view_method = "zathura",
   vimtex_compiler_latexmk = {
      out_dir = ".",
      aux_dir = "build",
   },
   tex_conceal = "adbmg",
   tex_flavor = "latex",
})
