local xdgpath = require("user.utils").xdgpath
local chezmoi_tmpl_pat = xdgpath "data" .. "/chezmoi/.*%.tmpl"

vim.filetype.add {
   extension = {
      gotmpl = "gotmpl",
      nasm = "nasm",
   },
   pattern = {
      [chezmoi_tmpl_pat] = "gotmpl",
   },
}
