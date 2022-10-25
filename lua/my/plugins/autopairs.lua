local Rule = require "nvim-autopairs.rule"
local cond = require "nvim-autopairs.conds"
local utils = require "nvim-autopairs.utils"

local M = {}

M.setup = function()
   local autopairs = require "nvim-autopairs"
   autopairs.setup {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt" },
   }

   autopairs.add_rules {
      Rule("$", "$", { "tex", "latex", "pandoc" })
         :with_cr(cond.none())
         :with_move(function(opts)
            return opts.next_char == opts.char
         end),
   }
end

return M
