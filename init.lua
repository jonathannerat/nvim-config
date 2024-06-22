local utils = require "user.utils"

-- Bootstrapping lazy.nvim
utils.bootstrap {
   url = "https://github.com/folke/lazy.nvim.git",
   branch = "stable",
}

require "user.vim_options"

local option = require "user.options"

-- Load plugins from another file
require("lazy").setup("user.plugins", {
    dev = {
        path = option "dirs.nvim_plugins",
        patterns = {"jonathannerat"}
    }
})

require "user.filetypes"
require "user.commands"
require "user.mappings"

vim.cmd("colorscheme " .. option "theme")
