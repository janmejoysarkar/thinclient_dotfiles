call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'https://github.com/vim-airline/vim-airline' " Status bar
Plug 'SirVer/ultisnips'
call plug#end()

"""
"Remaps for CoC completion:
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
" Use <CR> to confirm completion
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"
" Trigger completion manually
inoremap <silent><expr> <C-Space> coc#refresh()
"""

colorscheme sorbet
set relativenumber
set hlsearch
syntax on
nnoremap Y "+y
vnoremap Y "+y
set mouse=a
set autoindent
