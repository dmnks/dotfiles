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
let g:ctrlp_extensions = ['tag']
let g:ctrlp_working_path_mode = 0

" #############################################################################
" # Appearance
" #############################################################################

syntax on
set termguicolors
" Needed for termguicolors to work in tmux
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
set background=dark
colorscheme one
set number
set wildmenu
set title
set nowrap
set cursorline
set colorcolumn=80
autocmd FileType gitcommit set textwidth=72 colorcolumn=73

" #############################################################################
" # Editing
" #############################################################################

" Have the Pythonic indentation regardless of the indent file used
set autoindent
set softtabstop=4
set shiftwidth=4
set expandtab
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

nmap <leader>b Oimport pudb; pu.db  # BREAKPOINT<esc>
nmap <leader>B Oimport ipdb; ipdb.set_trace()  # BREAKPOINT<esc>
nmap <leader>c :!git ctags<CR><CR>
nmap <leader>e :windo e<CR>

" Load additional config files
for f in split(glob('~/.vimrc.d/*.vim'), '\n')
    exe 'source' f
endfor
