local custom = require("user.utils").custom

require "user.options"

-- === Plugins ===
-- Bootstraping
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

vim.cmd("colorscheme " .. custom "theme")
