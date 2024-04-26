local utils = require "user.utils"
local option = require "user.options"

require "user.vim_options"

-- Bootstraping lazy.nvim
utils.bootstrap {
   url = "https://github.com/folke/lazy.nvim.git",
   branch = "stable",
}

-- Load plugins from another file
require("lazy").setup("user.plugins", {
    dev = {
        path = "~/projects/nvim-plugins",
        patterns = {"jonathannerat"}
    }
})

require "user.filetypes"
require "user.commands"
require "user.mappings"
require "user.highlights"

vim.cmd("colorscheme " .. option "theme")
