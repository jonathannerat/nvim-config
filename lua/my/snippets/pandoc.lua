
local snippets = {}

-- cpp inherits snippets from c
snippets = vim.tbl_extend("force", require "my.snippets.tex", snippets)

return snippets
