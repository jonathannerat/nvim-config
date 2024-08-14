local utils = require "user.utils"
local chezmoi_tmpl_pat = utils.xdgdir("data", "chezmoi", ".*%.tmpl")

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
