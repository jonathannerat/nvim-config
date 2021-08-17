augroup reload_configs
	au!
	au BufWritePost ~/.config/nvim/vim/*.vim ++nested source %
	au BufWritePost ~/.local/src/dotfiles/.config/nvim/vim/*.vim ++nested source %
augroup END

augroup firevim_rules
	au!
	au BufEnter www.overleaf.com_project-* setlocal textwidth=100 spell
augroup END

augroup writing_rules
	au!
	au FileType mail,tex,pandoc setlocal textwidth=100 spell
augroup END
