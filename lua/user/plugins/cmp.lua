local cmp = require "cmp"

local function get_formatting_opts()
   local ok, lspkind = pcall(require, "lspkind")

   if ok then
      return {
         format = lspkind.cmp_format {
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "…",
         },
      }
   end
end

local function get_mappings()
   local mappings = {
      ["<CR>"] = cmp.mapping.confirm { select = true },
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
   }

   local ok, ultisnips = pcall(require, "cmp_nvim_ultisnips.mappings")

   if ok then
      mappings["<Tab>"] = cmp.mapping(function(fallback)
         ultisnips.compose { "select_next_item", "expand", "jump_forwards" }(fallback)
      end, { "i", "s" })
      mappings["<S-Tab>"] = cmp.mapping(function(fallback)
         ultisnips.compose { "select_prev_item", "jump_backwards" }(fallback)
      end, { "i", "s" })
   end

   return cmp.mapping.preset.insert(mappings)
end

cmp.setup {
   sources = cmp.config.sources {
      { name = "nvim_lsp" },
      { name = "ultisnips" },
      { name = "buffer" },
      { name = "path" },
   },
   mapping = get_mappings(),
   snippet = {
      expand = function(args)
         vim.fn["UltiSnips#Anon"](args.body)
      end,
   },
   window = {
      documentation = cmp.config.window.bordered(),
   },
   formatting = get_formatting_opts(),
}

local autopairs_ok, autopairs = pcall(require, "nvim-autopairs.completion.cmp")

if autopairs_ok then
   cmp.event:on("confirm_done", autopairs.on_confirm_done())
end
