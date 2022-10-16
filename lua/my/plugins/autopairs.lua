local Rule = require "nvim-autopairs.rule"
local cond = require "nvim-autopairs.conds"
local utils = require "nvim-autopairs.utils"

local M = {}

M.setup = function()
   local autopairs = require "nvim-autopairs"
   autopairs.setup {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt" },
      check_ts = true,
   }

   autopairs.add_rules {
      Rule("$", "$", { "tex", "latex", "pandoc" }):with_cr(cond.none()):with_move(function(opts)
         if opts.next_char == opts.char then
            if opts.col == string.len(opts.line) then
               return
            end

            if utils.is_in_quotes(opts.line, opts.col - 1, opts.char) then
               return
            end
         end

         return false
      end),
   }
end

return M
