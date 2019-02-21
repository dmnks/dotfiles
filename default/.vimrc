let mapleader = ' '

" #############################################################################
" # Plugin setup
" #############################################################################

" gruvbox
let g:gruvbox_invert_tabline = 1

" ALE
let g:ale_linters = {
    \   'python': ['flake8', 'pyls'],
    \}
let g:ale_lint_on_text_changed = 'never'

" FZF
" https://github.com/junegunn/fzf/blob/master/README-VIM.md
" https://github.com/junegunn/fzf/wiki/Examples-(vim)
let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
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
function! s:buflist()
    " Return listed buffers that have a name
    let listed = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    let named = map(listed, 'bufname(v:val)')
    let named = map(filter(named, '!empty(v:val)'), 'v:val')
    return named
endfunction
command! FZFBuffers call fzf#run(fzf#wrap({
    \ 'source':  reverse(<sid>buflist()),
    \ 'options': '+m --prompt "buffer> "',
    \ }))
command! FZFTags if !empty(tagfiles()) | call fzf#run(fzf#wrap({
    \ 'source':  "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
    \ 'sink':    'tag',
    \ 'options': '+m --prompt "tag> "',
    \ })) | else | echoerr 'No tags found' | endif
nmap <c-p> :FZFBuffers<CR>
nmap <c-l> :FZF<CR>
nmap <c-k> :FZFTags<CR>

" Vimwiki
let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 2
let g:vimwiki_folding = 'expr'
let wiki = {}
let wiki.path = '~/vimwiki/'
let wiki.nested_syntaxes = {'python': 'python', 'cpp': 'cpp', 'sh': 'sh'}
let g:vimwiki_list = [wiki]

" nerdtree
map <c-n> :NERDTreeToggle<CR>

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
let &colorcolumn=join(range(80, 999), ",")
autocmd FileType gitcommit setlocal textwidth=72 colorcolumn=73
autocmd FileType gitcommit setlocal spell
set laststatus=2
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

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
set foldlevel=99

" #############################################################################
" # Motion
" #############################################################################

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
command -nargs=+ G exec "silent grep! " . <q-args> . " ':(exclude)po/*.po'"
    \ | copen | redraw!
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
