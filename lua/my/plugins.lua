-- vi: fdm=marker
-- Bootstrap lazy.nvim-- {{{
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
   }
end
vim.opt.rtp:prepend(lazypath)
-- }}}

local function syntax_spec(spec, name, filetypes)
   if filetypes == nil then
      filetypes = { name }
   end

   spec = type(spec) == "string" and { spec } or spec
   spec.name = "syntax-" .. name
   spec.filetypes = filetypes

   return spec
end

local function setup_spec(spec, module)
   spec = type(spec) == "string" and { spec } or spec

   spec.config = function()
      require(module).setup()
   end

   return spec
end

require("lazy").setup {
   -- === Colorschemes === {{{
   { "rebelot/kanagawa.nvim", priority = 1000 },
   -- }}}

   -- === Language specific ==={{{
   syntax_spec("tridactyl/vim-tridactyl", "tridactyl"),
   syntax_spec("jwalton512/vim-blade", "blade"),
   syntax_spec("aklt/plantuml-syntax", "plantuml"),
   syntax_spec("jpalardy/vim-slime", "lisp"),
   { "lervag/vimtex", ft = { "tex", "latex" } },
   -- }}}

   --- === UI === {{{
   "alvarosevilla95/luatab.nvim", -- Tabline
   setup_spec("feline-nvim/feline.nvim", "my.plugins.feline"), -- Statusline
   setup_spec("goolord/alpha-nvim", "my.plugins.alpha"), -- Dashboard
   setup_spec({
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "kyazdani42/nvim-web-devicons",
         "MunifTanjim/nui.nvim",
         {
            "s1n7ax/nvim-window-picker",
            version = "v1.*",
            opts = {
               autoselect_one = true,
               include_current = false,
               filter_rules = {
                  bo = {
                     filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },
                     buftype = { "terminal" },
                  },
               },
            },
         },
      },
   }, "my.plugins.neo-tree"), -- File explorer

   {
      "akinsho/toggleterm.nvim", -- Floating terminal
      version = "v2.*",
      opts = {
         open_mapping = [[<c-\>]],
         persist_size = false,
         direction = "float",
         size = function(term)
            if term.direction == "horizontal" then
               return 15
            elseif term.direction == "vertical" then
               return vim.o.columns * 0.4
            end
         end,
      },
   },

   setup_spec("anuvyklack/pretty-fold.nvim", "pretty-fold"),
   --}}}

   -- === Treesitter === {{{
   setup_spec({
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
   }, "my.plugins.treesitter"),

   { -- Syntax aware text-objects
      "nvim-treesitter/nvim-treesitter-textobjects",
      priority = 60,
   },

   { -- Context aware comment string (injections)
      "JoosepAlviste/nvim-ts-context-commentstring",
      priority = 60,
   },

   { -- TreeSitter node viewer
      "nvim-treesitter/playground",
      priority = 60,
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
      build = ":TSUpdate query",
   },

   { -- Show cursor context block (class / function / if / for / etc.)
      "nvim-treesitter/nvim-treesitter-context",
      after = "nvim-treesitter",
      config = {
         enabled = true,
         max_lines = 3,
      },
   },
   -- }}}

   -- === Telescope === {{{
   setup_spec({
      "nvim-telescope/telescope.nvim",
      lazy = true,
      cmd = "Telescope",
      dependencies = {
         "nvim-lua/popup.nvim",
         "nvim-lua/plenary.nvim",
         "nvim-telescope/telescope-live-grep-args.nvim",
         { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
   }, "my.plugins.telescope"),
   -- }}}

   -- === LSP === {{{
   "folke/neodev.nvim", -- sumneko_lua lsp + nvim integration

   setup_spec("williamboman/mason.nvim", "mason"),

   setup_spec(
      { "williamboman/mason-lspconfig.nvim", dependencies = {
         "hrsh7th/cmp-nvim-lsp",
      } },
      "my.plugins.mason-lspconfig"
   ),

   {
      "neovim/nvim-lspconfig",
      dependencies = {
         "onsails/lspkind-nvim", -- LSP Completion symbols
         "ray-x/lsp_signature.nvim", -- function signature as you type
      },
   },

   setup_spec({ -- Completion engine for LSPs
      "hrsh7th/nvim-cmp",
      dependencies = {
         "hrsh7th/cmp-buffer",
         "hrsh7th/cmp-nvim-lsp",
         "saadparwaiz1/cmp_luasnip",
         "hrsh7th/cmp-path",
         "hrsh7th/cmp-cmdline",
      },
   }, "my.plugins.cmp"),

   {
      "ray-x/lsp_signature.nvim",
      opts = {
         bind = true,
         floating_window = false,
         hint_enable = false,
         hint_prefix = " ",
         handler_opts = {
            border = "rounded",
         },
      },
   },

   {
      "glepnir/lspsaga.nvim",
      opts = {
         lightbulb = { enable = false },
         outline = { enable = false },
         beacon = { enable = false },
         symbol_in_winbar = { enable = false },
         diagnostic = {
            show_code_action = false,
            show_source = true,
            jump_num_shortcut = true,
         },
      },
   },
   -- }}}

   -- === Editing === {{{
   "gpanders/editorconfig.nvim",

   setup_spec("windwp/nvim-autopairs", "my.plugins.autopairs"),

   { "numToStr/Comment.nvim", config = true },

   {
      "kylechui/nvim-surround",
      version = "*",
      config = true,
   },

   setup_spec({ -- File formatting
      "mhartington/formatter.nvim",
      cmd = { "Format", "FormatWrite" },
   }, "my.plugins.formatter"),

   { -- Annotation generation
      "danymat/neogen",
      cmd = "Neogen",
      config = true,
   },

   "mattn/emmet-vim",

   "cbochs/portal.nvim",
   -- }}}

   -- === Utilities === {{{
   { "lewis6991/gitsigns.nvim", config = true },
   "rafamadriz/friendly-snippets", -- Collection of snippets
   "HiPhish/info.vim", -- Info files
   setup_spec({
      "L3MON4D3/LuaSnip",
      version = "v1.*",
   }, "my.plugins.luasnip"), -- Snippets engine

   { -- Organization tool (note taking / todo lists / etc.)
      "nvim-neorg/neorg",
      ft = "norg",
      dependencies = { "nvim-lua/plenary.nvim" },
      build = ":Neorg sync-parsers",
      cmd = "Neorg",
      opts = {
         load = {
            ["core.defaults"] = {},
            ["core.norg.concealer"] = {},
            ["core.norg.dirman"] = {
               config = { workspaces = { notes = "~/notebook/home/" }, autochdir = true },
            },
            ["core.norg.completion"] = {
               config = { engine = "nvim-cmp" },
            },
         },
      },
   },

   setup_spec({ -- Preview color #aaaaaa
      "norcalli/nvim-colorizer.lua",
      cmd = "ColorizerToggle",
   }, "colorizer"),

   {
      "nvim-neotest/neotest",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-treesitter/nvim-treesitter",
         "antoinemadec/FixCursorHold.nvim",
         "olimorris/neotest-phpunit",
      },
      opts = {
         adapters = {
            require "neotest-phpunit",
         },
      },
   },
   -- }}}
}