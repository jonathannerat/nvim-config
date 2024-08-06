local chezmoi_tmpl_pat = os.getenv "XDG_DATA_HOME" .. "/chezmoi/.*%.tmpl"

vim.filetype.add {
   extension = {
      gotmpl = "gotmpl",
      nasm = "nasm",
   },
   pattern = {
      [chezmoi_tmpl_pat] = "gotmpl",
      [".*%.blade%.php"] = "blade",
   },
}
