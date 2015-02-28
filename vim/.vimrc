" #############################################################################
" # General
" #############################################################################

" Initialize Vundle
source ~/.vundle

let mapleader = " "

" #############################################################################
" # Vundle plugins setup
" #############################################################################

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pyflakes', 'pep8']
let g:syntastic_aggregate_errors = 1

" nerdtree
map <leader>t :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']

" vim-airline
let g:airline_powerline_fonts = 1
set laststatus=2
set noshowmode

" #############################################################################
" # Appearance
" #############################################################################

syntax on
set background=dark
colorscheme solarized
call togglebg#map("<F5>")
set number
set wildmenu
set title
set nowrap
set cursorline
set colorcolumn=80
autocmd FileType gitcommit set colorcolumn=73
" Enable spell checking
setlocal spell spelllang=en

" #############################################################################
" # Editing
" #############################################################################

" Have the Pythonic indentation regardless of the indent file used
set softtabstop=4
set shiftwidth=4
set expandtab
" Start scrolling three lines before the horizontal window border
set scrolloff=8
set sidescrolloff=15
set sidescroll=1
" Allow backspace in insert mode
set backspace=indent,eol,start

" #############################################################################
" # Searching
" #############################################################################

set hlsearch
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
noremap <leader>n :nohl<CR>

" #############################################################################
" # Window manipulation
" #############################################################################

" Bind the ctrl+movements keys to move around the windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h
