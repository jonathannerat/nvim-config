" ╭───────────┐
" │ INTERFACE │
" └───────────┘
set background=dark
set completeopt+=menuone,noinsert,noselect
set conceallevel=2
set cursorline
set fillchars=eob:~
set lazyredraw
set list
set listchars=eol:↵,tab:│\ ,trail:·,extends:…,precedes:…,nbsp:☠
set noshowmode
set number relativenumber
set scrolloff=5
set shortmess+=ac
set showmatch
set splitbelow splitright
set termguicolors
set wrap



" ╭───────────┐
" │    FILE   │
" └───────────┘
set nobackup nowritebackup
set noswapfile
set undofile



" ╭───────────┐
" │  EDITING  │
" └───────────┘
set noautoindent copyindent preserveindent
set noexpandtab
set shiftwidth=2 tabstop=2
set spelllang=es,en
set linebreak



" ╭───────────┐
" │ BEHAVIOUR │
" └───────────┘
set inccommand=split
set ignorecase smartcase
set timeoutlen=300



" ╭───────────┐
" │  GLOBALS  │
" └───────────┘
" tmux fix for colors
let &t_8f = '\<Esc>[38;2;%lu;%lu;%lum'
let &t_8b = '\<Esc>[48;2;%lu;%lu;%lum'



" ╭───────────┐
" │ Firenvim  │
" └───────────┘
if exists('g:started_by_firenvim')
	set nowrap
	set laststatus=0
	set linespace=-2
	set guifont=Iosevka_Nerd_Font:h9
endif
