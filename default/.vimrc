" #############################################################################
" # Plugin setup
" #############################################################################

let mapleader = ' '

" gruvbox
let g:gruvbox_invert_tabline = 1

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
    let named = filter(named, '!empty(v:val)')
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
nmap <leader><leader> :FZFBuffers<CR>
nmap <leader>f :FZF<CR>
nmap <leader>t :FZFTags<CR>

" Vimwiki
let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 2
let wiki = {}
let wiki.path = '~/vimwiki/'
let wiki.nested_syntaxes = {'python': 'python', 'cpp': 'cpp', 'sh': 'sh'}
let g:vimwiki_list = [wiki]
nmap <c-n> <Plug>VimwikiNextLink
nmap <c-p> <Plug>VimwikiPrevLink

" #############################################################################
" # Appearance
" #############################################################################

syntax on
set termguicolors
" Needed for tmux, see :help xterm-true-color
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
set t_ut=
set background=dark
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
set scrolloff=0
nmap <F5> :let &background = ( &background == "dark"? "light" : "dark" )<CR>

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
" # Searching
" #############################################################################

set hlsearch
set ignorecase
set smartcase
" Highlight dynamically as pattern is typed
set incsearch
set grepprg=git\ grep\ -n\ $*
command -nargs=+ G exec "silent grep! " . <q-args> . " ':(exclude)po/*.po'"
    \ | copen | redraw!

" #############################################################################
" # Simple .plan support
" # More info: https://garbagecollected.org/2017/10/24/the-carmack-plan/
" #############################################################################

function! s:planToggle()
    let l:symbs = [' ', '*', '+', '-', '@']
    let l:line = getline('.')
    let l:idx = index(l:symbs, l:line[0])
    let l:symb = symbs[(l:idx + 1) % len(l:symbs)]
    call setline('.', l:symb . l:line[1:])
endfunction

function! s:planNext()
    let l:delim = repeat('=', 20)
    if expand('%:t:r') == 'weekly'
        let l:format = '= Week %V, %b %d, %Y ' . l:delim
        let l:delta = 24*60*60*7
    else
        let l:format = '= %a %b %d, %Y ' . l:delim
        let l:delta = 24*60*60
    endif
    let l:line = getline(search('^= ', 'bn'))
    let l:prev = strptime(l:format, l:line)
    let l:next = strftime(l:format, l:prev + l:delta)
    call append(line('.'), ['', l:next, ''])
    normal! 3j
endfunction

function! s:planInit()
    " Syntax
    syntax match todoDate "^= .*$"
    syntax match todoOpen "^  .*$"
    syntax match todoGoal "^@ .*$"
    syntax match todoPost "^+ .*$"
    syntax match todoDrop "^- .*$"
    highlight def link todoDate Constant
    highlight def link todoOpen Define
    highlight def link todoGoal Identifier
    highlight def link todoPost Typedef
    highlight def link todoDrop Comment
    " Mappings
    nmap <buffer> <silent> <c-t> :call <sid>planToggle()<CR>
    nmap <buffer> <silent> <c-n> :call search('^[ @] ')<CR>
    nmap <buffer> <silent> <c-p> :call search('^[ @] ', 'b')<CR>
    nmap <buffer> <silent> <CR> :call <sid>planNext()<CR>
endfunction

autocmd BufRead,BufNewFile *.plan call <sid>planInit()

" #############################################################################
" # Misc
" #############################################################################

set tags=tags
set ttimeoutlen=10
set dictionary=/usr/share/dict/words
runtime ftplugin/man.vim
set keywordprg=:Man

nmap <esc><esc> :nohl<CR>
nmap <leader>g :exec "G <cword>"<cr>
nmap <leader>c :!git ctags<CR><CR>
nmap <leader>e :windo e<CR>
nmap <leader>b Oimport pudb; pu.db  # BREAKPOINT<esc>
nmap <leader>s :set spell!<CR>

" Load additional config files
for f in split(glob('~/.vimrc.d/*.vim'), '\n')
    exec 'source' f
endfor
