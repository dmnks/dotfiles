" #############################################################################
" # General
" #############################################################################

" Initialize Vundle
source ~/.vundle

let mapleader = " "

" #############################################################################
" # Vundle plugins setup
" #############################################################################

" gruvbox
let g:gruvbox_invert_tabline = 1

" ALE
let g:ale_lint_on_text_changed = 'never'

" #############################################################################
" # Appearance
" #############################################################################

syntax on
set termguicolors
set t_8f=[38;2;%lu;%lu;%lum  " for tmux
set t_8b=[48;2;%lu;%lu;%lum  " for tmux
set background=dark
map <F5> :let &background = ( &background == "dark"? "light" : "dark" )<CR>
colorscheme gruvbox
set number
set wildmenu
set title
set nowrap
set cursorline
set colorcolumn=80
autocmd FileType gitcommit setlocal textwidth=72 colorcolumn=73
autocmd FileType gitcommit setlocal spell

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

nmap ]q :cnext<CR>
nmap [q :cprev<CR>
nmap ]l :lnext<CR>
nmap [l :lprev<CR>
nmap ]L :llast<CR>
nmap ]t :tnext<CR>
nmap [t :tprev<CR>

" #############################################################################
" # Searching
" #############################################################################

set hlsearch
set ignorecase
set smartcase
" Highlight dynamically as pattern is typed
set incsearch
nmap <leader>n :nohl<CR>
set grepprg=git\ grep\ -n\ $*
command -nargs=+ G execute "silent grep! <args>" | copen | redraw!

" #############################################################################
" # Misc
" #############################################################################

set tags=tags

nmap <leader>b Oimport pudb; pu.db  # BREAKPOINT<esc>
nmap <leader>B Oimport ipdb; ipdb.set_trace()  # BREAKPOINT<esc>
nmap <leader>c :!git ctags<CR><CR>
nmap <leader>e :windo e<CR>
nmap <leader>s :set spell!<CR>
nmap <leader>r :redraw!<CR>

" Load additional config files
for f in split(glob('~/.vimrc.d/*.vim'), '\n')
    exe 'source' f
endfor

" #############################################################################
" # Custom commands
" #############################################################################

command! -bar Tags if !empty(tagfiles()) | call fzf#run({
\   'source': "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
\   'sink':   'tag',
\   'down':   '40%',
\ }) | else | echo 'No tags' | endif

nmap <c-p> :FZF<CR>
nmap <leader>t :Tags<CR>
