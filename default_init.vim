syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set fileformat=unix
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
" set undodir=~/.vim/undodir
set undofile
set incsearch
set encoding=utf-8

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

call plug#begin('~/.local/share/nvim/plugged')

Plug 'joshdick/onedark.vim'         " Theme based in Atom colors
Plug 'jremmen/vim-ripgrep'          "
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Yggdroot/indentLine'          " Line to see better indenting
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mbbill/undotree'
Plug 'vim-python/python-syntax'
Plug 'leafgarland/typescript-vim'

call plug#end()

" colorscheme onedark
set background=dark

let python_highlight_all = 1

if executable('rg')
let g:rg_derive_root = 'true'
endif

let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-stand']
let mapleader = " "
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:ctrlp_use_caching = 0
let g:netrw_winsize = 25
