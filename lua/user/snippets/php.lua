local ls = require "luasnip"
local c, d, f, i, s, sn, t = ls.c, ls.d, ls.f, ls.i, ls.s, ls.sn, ls.t

function table.map(tbl, fn)
   local res = {}

   for key, value in pairs(tbl) do
      res[key] = fn(value, key)
   end

   return res
end

function string.title(str)
   local chr = string.sub(str, 1, 1)
   return chr:upper() .. str:sub(2)
end

local function get_namespace()
   local pathsep = "/"
   local components = vim.fn.split(vim.fn.expand "%:.:h", pathsep)

   return sn(nil, t { "namespace " .. table.concat(table.map(components, string.title), "\\") .. ";" })
end

local function get_classdef()
   local name = vim.fn.expand "%:t:r"

   return sn(nil, {
      c(1, {
         t "class ",
         t "interface ",
         t "trait ",
      }),
      i(2, name),
      c(3, {
         t "",
         sn(nil, { t " extends ", i(1, "BaseClass") }),
      }),
      t { " {", "\t" },
      i(4, "// code"),
      t { "", "}" },
   })
end

local rec_array_items
---recursively add `'key' => 'value'` pairs to a php array
---@param indent boolean wether to indent the next item or not
rec_array_items = function(_, _, _, indent)
   indent = indent == nil and true or indent

   return sn(nil, {
      c(1, {
         t "",
         sn(nil, {
            t(indent and { ",", "\t" } or ""),
            t "'", i(1, "key"), t "' => ",
            i(2, "'value'"),
            d(3, rec_array_items, {}),
         }),
      }),
   })
end

local php_snippets = {}

local snippets = {
   s("php", {
      t { "<?php", "", "" },
      d(1, get_namespace, {}),
      t { "", "", "" },
      d(2, get_classdef, {}),
   }),
   s("arr", {
      t "$",
      i(1, "arrayName"),
      t " = ",
      c(2, {
         sn(nil, {
            t "[",
            i(1),
            t "];",
         }),
         sn(nil, {
            t { "[", "\t" },
            d(1, rec_array_items, {}, {user_args = {false}}),
            t { "", "];" },
         }),
      }),
   }),
   s("testfun", {
      t { "/** @test */",
          "public function " }, i(1, "test_name"), t { "()",
          "{",
          "\t" }, i(0), t { "",
          "}" }
   })
}

for trigger, snippet_def in pairs(php_snippets) do
   snippets[#snippets + 1] = ls.parser.parse_snippet(trigger, snippet_def, {})
end

return snippets
