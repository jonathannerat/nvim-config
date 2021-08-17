let mapleader=' '
let localmapleader='\\'

lua require'my.mappings'.setup()

if exists('g:started_by_firenvim')
	inoremap <m-w> <c-w>
	nnoremap <m-w> <c-w>
endif
