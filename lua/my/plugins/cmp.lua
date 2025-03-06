local cmp = require "cmp"
local snippy = require "snippy"

local function has_words_before()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

cmp.setup {
   sources = cmp.config.sources {
      { name = "nvim_lsp" },
      { name = "snippy" },
      { name = "emmet_vim" },
      { name = "buffer" },
      { name = "path" },
   },
   mapping = cmp.mapping.preset.insert {
      ["<CR>"] = cmp.mapping.confirm {
         behavior = cmp.ConfirmBehavior.Replace,
         select = true,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.select_next_item()
         elseif snippy.can_expand_or_advance() then
            snippy.expand_or_advance()
         elseif has_words_before() then
            cmp.complete()
         else
            fallback()
         end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.select_prev_item()
         elseif snippy.can_jump(-1) then
            snippy.previous()
         else
            fallback()
         end
      end, { "i", "s" }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
   },
   snippet = {
      expand = function(args)
         snippy.expand_snippet(args.body)
      end,
   },
   formatting = {
      fields = { "abbr", "kind", "menu" },
      format = require("lspkind").cmp_format {
         mode = "symbol_text",
         maxwidth = 50,
         ellipsis_char = "…",
      },
      expandable_indicator = true,
   },
}

local cmp_autopairs = require "nvim-autopairs.completion.cmp"
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
