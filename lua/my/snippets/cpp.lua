local u = require "my.util.snippets"
local ls = require "luasnip"
local S = ls.snippet
local d = ls.dynamic_node
local f = ls.function_node
local i = ls.insert_node
local t = ls.text_node

local snippets = {}

-- cpp inherits snippets from c
snippets = vim.tbl_extend("force", require "my.snippets.c", snippets)

return snippets
