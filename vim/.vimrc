" #############################################################################
" # My vimrc file (extends /etc/vimrc in Fedora)
" #############################################################################

let mapleader = ' '

" #############################################################################
" # Plugin setup
" #############################################################################

" FZF
" https://github.com/junegunn/fzf/blob/master/README-VIM.md
" https://github.com/junegunn/fzf/wiki/Examples-(vim)
let $FZF_DEFAULT_OPTS='--layout=reverse'
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
let g:fzf_layout = {
    \ 'window': {'yoffset': 0, 'width': 0.5, 'height': 0.5, 'border': 'sharp',
    \            'highlight': 'Normal'}}
function! s:buflist()
    " Return listed buffers that have a name
    let listed = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    let named = map(listed, 'bufname(v:val)')
    let named = filter(named, '!empty(v:val)')
    return named
endfunction
command! FZFBuffers
    \ call fzf#run(fzf#wrap({
    \   'source':  reverse(<sid>buflist()),
    \   'options': '+m --prompt "buffer> "',
    \ }))
command! FZFTags
    \ if !empty(tagfiles()) | call fzf#run(fzf#wrap({
    \   'source':  "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
    \   'sink':    'tag',
    \   'options': '+m --prompt "tag> "',
    \ })) | else | echoerr 'No tags found' | endif
command! FZFBox
    \ call fzf#run(fzf#wrap({
    \   'source':  'ls',
    \   'dir':     trim(system('codebox pwd')),
    \   'options': '-m --prompt "box> "',
    \ }))
nmap <leader><leader> :FZFBuffers<CR>
nmap <leader>ff :FZF<CR>
nmap <leader>fs :FZFTags<CR>
nmap <leader>fb :FZFBox<CR>

" #############################################################################
" # Appearance
" #############################################################################

set termguicolors
colorscheme gruvbox
set t_ut=
set number
set title
set nowrap
set guicursor=a:blinkon0
set cursorline
let &colorcolumn=join(range(80, 999), ",")
autocmd FileType gitcommit setlocal textwidth=72 colorcolumn=73
autocmd FileType gitcommit setlocal spell
set scrolloff=0
nmap <F5> :let &background = ( &background == "dark"? "light" : "dark" )<CR>

" #############################################################################
" # Editing
" #############################################################################

set softtabstop=4
set shiftwidth=4
set expandtab
autocmd BufRead,BufNewFile */rpm/*.[ch] set noexpandtab
set textwidth=79

" #############################################################################
" # Searching
" #############################################################################

set ignorecase
set smartcase
set grepprg=git\ grep\ -n\ $*
command -nargs=+ G exec "silent grep! " . <q-args> . " ':(exclude)po/*.po'"
    \ | copen | redraw!

" #############################################################################
" # Simple .plan support
" # More info: https://garbagecollected.org/2017/10/24/the-carmack-plan/
" #############################################################################

function! s:planToggle()
    let l:symbs = [' ', '*', '+', '-']
    let l:line = getline('.')
    let l:idx = index(l:symbs, l:line[0])
    let l:symb = symbs[(l:idx + 1) % len(l:symbs)]
    call setline('.', l:symb . l:line[1:])
endfunction

function! s:planInit()
    " Syntax
    syntax match planDate "^= .\+$"
    syntax match planOpen "^  \S.\+$"
    syntax match planPost "^+ .\+$"
    syntax match planDrop "^- .\+$"
    syntax match planDefn "^@ .\+$"
    highlight def link planDate Constant
    highlight def link planOpen Define
    highlight def link planPost Typedef
    highlight def link planDrop Comment
    highlight def link planDefn Identifier
    " Mappings
    nmap <buffer> <silent> <c-n> :call search('^ ', '', line('$'))<CR>
    nmap <buffer> <silent> <c-p> :call search('^ ', 'b', 10)<CR>
    nmap <buffer> <silent> <NUL> :call <sid>planToggle()<CR>
endfunction

function! s:planNext()
    let l:format = '= %a %b %d, %Y ' . repeat('=', 20)
    let l:line = getline(search('^= ', 'bn'))
    let l:prev = strptime(l:format, l:line)
    " +1 hour to cover for DST changes
    let l:next = strftime(l:format, l:prev + 25*60*60)
    call append(line('.'), ['', l:next, ''])
    normal! 3j
endfunction

function! s:planDaily()
    nmap <buffer> <silent> <CR> :call <sid>planNext()<CR>
endfunction

autocmd BufNewFile,BufRead *.plan   set filetype=plan
autocmd BufNewFile *.plan           0r ~/.vim/skeleton.plan | norm G
autocmd BufRead daily.plan          call <sid>planDaily()
autocmd FileType plan               call <sid>planInit()

" #############################################################################
" # Misc
" #############################################################################

set tags=tags
set ttimeoutlen=10
set dictionary=/usr/share/dict/words
set keywordprg=:Man
let g:ft_man_open_mode = 'vert'

nmap <esc><esc> :nohl<CR>
nmap <leader>g :exec "G <cword>"<CR>
nmap <leader>c :!git ctags<CR><CR>
nmap <leader>e :windo e<CR>
nmap <leader>s :set spell!<CR>
nmap <F8> :exec "!codebox make \|\| read"<CR><CR>

if has('nvim')
    autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
else
    set autoindent
    set background=dark
    set laststatus=2
    runtime ftplugin/man.vim
endif

autocmd BufWritePost ~/.Xresources silent !xrdb <afile>

" Load additional config files
for f in split(glob('~/.vimrc.d/*.vim'), '\n')
    exec 'source' f
endfor
