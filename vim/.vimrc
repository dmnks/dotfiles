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
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" ctrlp
let g:ctrlp_cmd = 'CtrlPBuffer'

" vim-airline
let g:airline_powerline_fonts = 1
set laststatus=2
set noshowmode
set ttimeoutlen=50

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
set spell spelllang=en

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
" # Motion
" #############################################################################

" Bind the ctrl+movements keys to move around the windows
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l
nmap <c-h> <c-w>h

nmap ]c :cnext<CR>
nmap [c :cprev<CR>
nmap ]l :lnext<CR>
nmap [l :lprev<CR>

" #############################################################################
" # Searching
" #############################################################################

set hlsearch
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
nmap <leader>n :nohl<CR>

" #############################################################################
" # Misc
" #############################################################################

" Load additional config files
for f in split(glob('~/.vimrc.d/*.vim'), '\n')
    exe 'source' f
endfor
