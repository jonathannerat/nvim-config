vim.g.user_emmet_mode = "in"
vim.g.user_emmet_install_global = 0

vim.api.nvim_create_autocmd("FileType", {
   pattern = { "html", "css", "blade", "vue" },
   command = "EmmetInstall",
})
