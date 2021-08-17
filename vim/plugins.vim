" ╭───────────┐
" │  Pandoc   │
" └───────────┘
let g:pandoc#formatting#mode = 'h'
let g:pandoc#formatting#textwidth = 100

" ╭─────────────────────┐
" │ Markdown Previewer  │
" └─────────────────────┘
let g:mkdp_open_to_the_world = 1
let g:mkdp_echo_preview_url = 1
let g:mkdp_port = 8007

" ╭──────────────┐
" │ Colorschemes │
" └──────────────┘
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_flat_style = 'hard'
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_palette = 'material'
let g:material_style = 'deep ocean'
let g:neon_style = 'dark'
let g:tokyonight_style = 'night'

" ╭───────────┐
" │    Nnn    │
" └───────────┘
let g:nnn#set_default_mappings = 0
let g:nnn#layout = { 'left': '~20%' }
let g:nnn#action = {
	\ '<c-t>': 'tab split',
	\ '<c-x>': 'split',
	\ '<c-v>': 'vsplit',
\ }

" ╭───────────┐
" │ Firenvim  │
" └───────────┘
let g:firenvim_config = { 'localSettings': {} }

let fc = g:firenvim_config['localSettings']
let fc_site_enable = { 'takeover': 'never', 'priority': 1 }

" enable command line
let fc['.*'] = { 'cmdline': 'neovim', 'takeover': 'never' }

" ╭────────────┐
" │   Vimtex   │
" └────────────┘
let g:tex_flavor='latex'
let g:tex_conceal='abdmg'
let g:vimtex_compiler_latexmk = {
\ 'build_dir' : 'build',
\ 'callback' : 1,
\ 'continuous' : 1,
\ 'executable' : 'latexmk',
\ 'hooks' : [],
\ 'options' : [
\   '-verbose',
\   '-file-line-error',
\   '-synctex=1',
\   '-interaction=nonstopmode',
\ ],
\}

packadd packer.nvim
lua require'my.plugins'.setup()
