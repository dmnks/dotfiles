" === General ===
" Be iMproved
set nocompatible

" === Vundle ===
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" custom plugins
Plugin 'morhetz/gruvbox'
Plugin 'scrooloose/syntastic'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" === Vundle end ===

let mapleader = ","

" === Appearance ===
syntax on
set number
set wildmenu
set title
set nowrap
" Just like the default status line (with the option unset) but with the
" syntastic flag
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline+=\ %#warningmsg#%{SyntasticStatuslineFlag()}%*
if has('gui_running')
    colorscheme gruvbox
    set cursorline
    set colorcolumn=80
    autocmd FileType gitcommit set colorcolumn=73
    " Enable spell checking
    setlocal spell spelllang=en
    " Disable mouse, we don't need it!
    set mouse=
    " Use block cursor in insert mode and disable blinking
    " (like in a terminal)
    set gcr=i:block,a:blinkon0
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    " Use a non-GUI tab pages line
    set guioptions-=e
    " Toggle background (taken from altercation/vim-colors-solarized)
    noremap <leader>b :let &background = (
        \ &background == "dark"? "light" : "dark" )<CR>
endif

" === Editing ===
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

" === Searching ===
set hlsearch
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
noremap <c-n> :nohl<CR>

" === Window Manipulation ===
" Bind the ctrl+movements keys to move around the windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" === Misc ===
let g:syntastic_python_pylint_args = "--max-line-length=79"
