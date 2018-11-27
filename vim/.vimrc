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

" Add error/warning summary to statusline
" https://github.com/w0rp/ale#5v-how-can-i-show-errors-or-warnings-in-my-statusline
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? '' : printf(
    \   ' %dE %dW ',
    \   all_errors,
    \   all_non_errors,
    \)
endfunction

" FZF
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
nmap <c-p> :GFiles<CR>
nmap <leader>t :Tags<CR>

" Tagbar
nmap <F6> :TagbarToggle<CR>

" Vimwiki
let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 2
let wiki = {}
let wiki.path = '~/vimwiki/'
let wiki.nested_syntaxes = {'python': 'python', 'cpp': 'cpp', 'sh': 'sh'}
let g:vimwiki_list = [wiki]

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
set laststatus=2
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" Add ALE status
set statusline+=\ %#Error#%{LinterStatus()}
let g:markdown_folding = 1
autocmd BufRead,BufNewFile *.md set conceallevel=2

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
set textwidth=79

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
nmap ]Q :clast<CR>
nmap [Q :cfirst<CR>
nmap ]l :lnext<CR>
nmap [l :lprev<CR>
nmap ]L :llast<CR>
nmap [L :lfirst<CR>
nmap ]t :tnext<CR>
nmap [t :tprev<CR>
nmap ]T :tlast<CR>
nmap [T :tfirst<CR>

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
command -nargs=+ G exec "silent grep! " . <q-args> | copen | redraw!
nmap <leader>g :exec "G <cword>"<cr>

" #############################################################################
" # Misc
" #############################################################################

set tags=tags
set ttimeoutlen=10
set dictionary=/usr/share/dict/words
set complete+=k

nmap <leader>b Oimport pudb; pu.db  # BREAKPOINT<esc>
nmap <leader>B :G '\# BREAKPOINT'<CR>
nmap <leader>c :!git ctags<CR><CR>
nmap <leader>e :windo e<CR>
nmap <leader>s :set spell!<CR>
nmap <leader>r :redraw!<CR>

" Load additional config files
for f in split(glob('~/.vimrc.d/*.vim'), '\n')
    exec 'source' f
endfor

" Simple TODO mode for Markdown
autocmd BufRead,BufNewFile *.md
    \ syntax region taskDone start="^ *- \[X] " end="$"
        \ contains=markdownListMarker |
    \ highlight def link taskDone Comment |
    \ nmap <buffer> <silent> <CR> :call <sid>rotate()<CR> |
    \ nmap <leader>d O- [ ] 
function! s:rotate()
    let symbs = [' ', 'X']
    let line = getline('.')
    let symb = substitute(line, '^ *- \[\(.\)] .*$', '\1', 'g')
    if symb == line
        return
    endif
    let idx = index(symbs, symb)
    let symb = symbs[(idx + 1) % len(symbs)]
    let line = substitute(line, '^\( *- \[\).\(] .*\)$', '\1' . symb . '\2', 'g')
    call setline('.', line)
endfunction
