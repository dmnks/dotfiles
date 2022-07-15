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
    \            'highlight': 'Comment'}}
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
set background=dark
hi ColorColumn guibg=#282828
hi TabLineFill guibg=#282828
hi VertSplit guifg=#1d2021
set fillchars=vert:┃
set number
set title
set nowrap
set guicursor=a:blinkon0
set cursorline
set colorcolumn=80
autocmd FileType gitcommit setlocal textwidth=72 colorcolumn=73
autocmd FileType gitcommit setlocal spell
set scrolloff=0
nmap <F5> :let &background = ( &background == "dark"? "light" : "dark" )<CR>

" Simplify tabline
" Taken from: https://www.reddit.com/r/vim/comments/ghedcp/
"             is_it_possible_to_make_the_tab_name_only_be_the/
function! Tabline() abort
    let l:line = ''
    let l:current = tabpagenr()

    for l:i in range(1, tabpagenr('$'))
        if l:i == l:current
            let l:line .= '%#TabLineSel#'
        else
            let l:line .= '%#TabLine#'
        endif

        let l:label = fnamemodify(
            \ bufname(tabpagebuflist(l:i)[tabpagewinnr(l:i) - 1]),
            \ ':t'
        \ )

        let l:line .= '  ' . l:label . '  '
    endfor

    let l:line .= '%#TabLineFill#'

    return l:line
endfunction
set tabline=%!Tabline()

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
nnoremap * :let @/='\<'.expand('<cword>').'\>'<bar>set hlsearch<CR>

" #############################################################################
" # Common helpers
" #############################################################################

function! s:cycle(symbs)
    let l:len = len(a:symbs[0])
    let l:line = getline('.')
    let l:idx = index(a:symbs, l:line[:l:len - 1])
    echom l:line[:l:len]
    let l:symb = a:symbs[(l:idx + 1) % len(a:symbs)]
    call setline('.', l:symb . l:line[l:len:])
endfunction

" #############################################################################
" # Simple .plan support
" # More info: https://garbagecollected.org/2017/10/24/the-carmack-plan/
" #############################################################################

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
    nmap <buffer> <silent> <NUL> :call <sid>cycle([' ', '*', '+', '-'])<CR>
    nmap <buffer> <silent> <CR>  :call <sid>planNext()<CR>
endfunction

function! s:planNext()
    let l:format = '= %a %b %d, %Y ' . repeat('=', 20)
    let l:line = getline(search('^= ', 'bn'))
    let l:prev = strptime(l:format, l:line)
    if l:prev == 0
        return
    endif
    " +1 hour to cover for DST changes
    let l:next = strftime(l:format, l:prev + 25*60*60)
    call append(line('.'), ['', l:next, ''])
    normal! 3j
endfunction

autocmd BufNewFile,BufRead *.plan   set filetype=plan
autocmd BufNewFile *.plan           0r ~/.vim/skeleton.plan | norm G
autocmd FileType plan               call <sid>planInit()

" #############################################################################
" # Maintenance release mode
" #############################################################################

function! s:maintInit()
    nmap <buffer> <silent> <NUL> :call <sid>cycle(['    ', 'drop', 'pick', 'open'])<CR>
    nmap <buffer> <silent> <CR>  :call <sid>maintShow()<CR>
    nmap <buffer> <silent> <C-s> :echom trim(system("git maint status"))<CR>
endfunction

function! s:maintShow()
    let l:hash = split(getline('.')[5:], ' ')[0]
    silent exec "!tig show " . l:hash | redraw!
endfunction

autocmd BufNewFile,BufRead *.maint  call <sid>maintInit()

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
nmap <leader>e :windo e<CR>
nmap <leader>s :set spell!<CR>
nmap <leader>c :!git ctags<CR><CR>
nmap <leader>p :edit ~/.plan<CR>
nmap <F8> :exec "!dsh exec make \|\| read"<CR><CR>
nmap <c-n> :tabnext<CR>
nmap <c-p> :tabprev<CR>

if has('nvim')
    autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
else
    set autoindent
    set laststatus=2
    runtime ftplugin/man.vim
endif

autocmd BufWritePost ~/.Xresources silent !xrdb <afile>

" Load additional config files
for f in split(glob('~/.vimrc.d/*.vim'), '\n')
    exec 'source' f
endfor
