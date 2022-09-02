-- ensure packer.nvim is installed
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
   packer_bootstrap = fn.system {
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
   }
end

local packer = require "packer"
local use = packer.use

-- Use plugin only for specified filetypes, using apropiate folder name
local function use_syntax(plugin, alias, filetypes)
   if filetypes == nil then
      filetypes = { alias }
   elseif type(filetypes) == "string" then
      filetypes = { filetypes }
   end

   use {
      plugin,
      as = "syntax-" .. alias,
      ft = filetypes,
   }
end

-- Use plugin generating a trivial config call
local function use_setup(plugin_spec, module)
   plugin_spec = type(plugin_spec) == "string" and { plugin_spec } or plugin_spec
   module = module and module or string.match(plugin_spec[1], ".*/(.*)")
   plugin_spec.config = "require('" .. module .. "').setup()"

   use(plugin_spec)
end

-- Try to use local clone of plugin if available, fallback to original
local function use_local(plugin_spec)
   local plugin = type(plugin_spec) == "string" and plugin_spec or plugin_spec[1]
   local plugin_name = string.match(plugin, ".*/(.*)")
   local plugins_dir = "~/projects/nvim-plugins/"

   if fn.isdirectory(fn.expand(plugins_dir .. plugin_name)) == 1 then
      plugin_spec[1] = plugins_dir .. plugin_name
   end

   use(plugin_spec)
end

local function packer_setup()
   use "wbthomason/packer.nvim"

   -- === Language Specific ===
   use_syntax("arrufat/vala.vim", "vala")
   use_syntax("asciidoc/vim-asciidoc", "asciidoc", { "asciidoc", "adoc" })
   use_syntax("cakebaker/scss-syntax.vim", "scss")
   use_syntax("cespare/vim-toml", "toml")
   use_syntax("gkz/vim-ls", "livescript", "ls")
   use_syntax("jidn/vim-dbml", "dbml")
   use_syntax("leafo/moonscript-vim", "moonscript", "moon")
   use_syntax("neomutt/neomutt.vim", "mutt", { "mutt", "neomutt" })
   use_syntax("tridactyl/vim-tridactyl", "tridactyl")
   use_syntax("iosmanthus/vim-nasm", "nasm")
   use_syntax("vim-pandoc/vim-pandoc-syntax", "pandoc")
   use_syntax("mechatroner/rainbow_csv", "csv")
   use_syntax("baskerville/vim-sxhkdrc", "sxhkdrc")
   use_syntax("adimit/prolog.vim", "prolog")
   use_syntax("jwalton512/vim-blade", "blade")
   use { "vim-pandoc/vim-pandoc", ft = "pandoc" } -- Pandoc integration & utilities
   use { "lervag/vimtex", ft = { "tex", "latex" } } -- Latex integration & utilities

   -- === Colorschemes ===
   use "folke/tokyonight.nvim"

   -- === UI ===
   use_setup("nanozuki/tabby.nvim", "my.plugins.tabby") -- Tabline
   use_setup("nvim-lualine/lualine.nvim", "my.plugins.lualine") -- Statusline
   use_setup("goolord/alpha-nvim", "my.plugins.alpha") -- Dashboard
   use {
      "nvim-neo-tree/neo-tree.nvim", -- File explorer
      requires = {
         "nvim-lua/plenary.nvim",
         "kyazdani42/nvim-web-devicons",
         "MunifTanjim/nui.nvim",
      },
      config = function()
         -- If you want icons for diagnostic errors, you'll need to define them somewhere:
         vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
         vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
         vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
         vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
         local neotree = require "neo-tree"
         neotree.setup {
            enable_git_status = false,
            enable_diagnostics = false,
            default_component_configs = {
               container = {
                  enable_character_fade = false,
               },
            },
            window = {
               mappings = {
                  s = "open_split",
                  v = "open_vsplit",
                  o = {
                     "toggle_node",
                     nowait = false,
                  },
               }
            },
            event_handlers = {
               {
                  event = "file_opened",
                  handler = function ()
                     neotree.close "filesystem"
                  end
               }
            }
         }
      end,
   }

   use {
      "akinsho/toggleterm.nvim",
      config = function()
         require("toggleterm").setup {
            open_mapping = [[<c-\>]],
            persist_size = false,
            direction = "float",
         }
      end,
   }

   use_setup("anuvyklack/pretty-fold.nvim", "pretty-fold")

   use "kyazdani42/nvim-web-devicons"

   -- === Treesitter ===
   use_setup({
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
   }, "my.plugins.treesitter")

   use { -- Syntax aware text-objects
      "nvim-treesitter/nvim-treesitter-textobjects",
      after = "nvim-treesitter",
   }

   use { -- Smarter text-objects
      "RRethy/nvim-treesitter-textsubjects",
      after = "nvim-treesitter",
   }

   use { -- Context aware comment string (injections)
      "JoosepAlviste/nvim-ts-context-commentstring",
      after = "nvim-treesitter",
   }

   use { -- TreeSitter node viewer
      "nvim-treesitter/playground",
      after = "nvim-treesitter",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
      run = ":TSUpdate query",
   }

   use { -- Show cursor context block (class / function / if / for / etc.)
      "nvim-treesitter/nvim-treesitter-context",
      after = "nvim-treesitter",
      config = function()
         require("treesitter-context").setup {
            enabled = true,
            max_lines = 3,
         }
      end,
   }

   use {
      "nvim-neorg/tree-sitter-norg",
      after = "nvim-treesitter",
      ft = "norg",
   }

   -- === Telescope ===
   use_setup({
      "nvim-telescope/telescope.nvim",
      after = { "telescope-fzf-native.nvim" },
      cmd = "Telescope",
      module = { "telescope", "my.plugins.telescope" },
      requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
   }, "my.plugins.telescope")

   use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }

   -- === LSP ===
   use_setup({
      "neovim/nvim-lspconfig",
      requires = {
         "williamboman/nvim-lsp-installer",
         "onsails/lspkind-nvim", -- LSP Completion symbols
         "folke/lua-dev.nvim", -- sumneko_lua lsp + nvim integration
         "ray-x/lsp_signature.nvim", -- function signature as you type
      },
   }, "my.plugins.lspconfig")

   use_setup({ -- Completion engine for LSPs
      "hrsh7th/nvim-cmp",
      requires = {
         { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
         { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
         { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
         { "hrsh7th/cmp-path", after = "nvim-cmp" },
      },
   }, "my.plugins.cmp")

   use {
      "ray-x/lsp_signature.nvim",
      config = function()
         require("lsp_signature").setup {
            bind = true,
            floating_window = false,
            hint_enable = false,
            hint_prefix = " ",
            handler_opts = {
               border = "rounded",
            },
         }
      end,
   }

   use {
      "glepnir/lspsaga.nvim",
      config = function()
         require("lspsaga").init_lsp_saga {
            code_action_keys = {
               quit = "<ESC>",
               exec = "<CR>",
            },
         }
      end,
   }

   -- === Editing ===
   use "editorconfig/editorconfig-vim"
   use_setup("windwp/nvim-autopairs", "my.plugins.autopairs")
   use_setup("numToStr/Comment.nvim", "Comment")
   use_setup "kylechui/nvim-surround"

   use_setup({ -- File formatting
      "mhartington/formatter.nvim",
      cmd = { "Format", "FormatWrite" },
   }, "my.plugins.formatter")

   use_setup { -- Annotation generation
      "danymat/neogen",
      cmd = "Neogen",
   }

   use "mattn/emmet-vim"

   -- === Utilities ===
   use "tpope/vim-fugitive" -- Git integration
   use "rafamadriz/friendly-snippets" -- Collection of snippets
   use "HiPhish/info.vim" -- Info files
   use_setup("L3MON4D3/LuaSnip", "my.plugins.luasnip") -- Snippets engine

   use { -- Organization tool (note taking / todo lists / etc.)
      "nvim-neorg/neorg",
      ft = "norg",
      config = function()
         require("neorg").setup {
            load = {
               ["core.defaults"] = {},
               ["core.keybinds"] = {
                  config = { default_keybinds = true },
               },
               ["core.norg.concealer"] = {},
               ["core.norg.dirman"] = {
                  config = { workspaces = { notes = "~/documents/notes" } },
               },
               ["core.norg.completion"] = {
                  config = { engine = "nvim-cmp" },
               },
            },
         }
      end,
   }

   use { -- Preview color #aaaaaa
      "norcalli/nvim-colorizer.lua",
      cmd = "ColorizerToggle",
      config = function()
         require("colorizer").setup(nil, {
            RRGGBB = true,
         })
      end,
   }

   if packer_bootstrap then
      packer.sync()
   end
end

require("packer").startup {
   packer_setup,
   config = {
      display = {
         open_fn = function()
            return require("packer.util").float { border = "single" }
         end,
      },
      profile = {
         enabled = true,
         threshold = 1,
      },
   },
}
