" #############################################################################
" # My vimrc file (extends /etc/vimrc in Fedora)
" #############################################################################

let mapleader = ' '

" #############################################################################
" # Plugin setup
" #############################################################################

" gruvbox
let g:gruvbox_invert_tabline = 1

" FZF
" https://github.com/junegunn/fzf/blob/master/README-VIM.md
" https://github.com/junegunn/fzf/wiki/Examples-(vim)
packadd! fzf  " add local plugin to runtimepath before system-wide one
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

" Vimwiki
let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 2
let wiki = {}
let wiki.path = '~/vimwiki/'
let wiki.nested_syntaxes = {'python': 'python', 'cpp': 'cpp', 'sh': 'sh'}
let g:vimwiki_list = [wiki]
" Autogenerate diary files
autocmd BufNewFile Diary\ *.wiki        silent 0r !gendiary year "%:t:r"
autocmd BufNewFile */diary/[^d]*.wiki   silent 0r !gendiary day "%:t:r"
" Binding to jump to current week in diary index
autocmd BufRead,BufNewFile Diary\ *.wiki,*/diary/diary.wiki
    \ nmap <buffer> <silent> <c-j>
    \ :exec search("^==== Week " . strftime("%V"))<CR>zt
nmap <c-p> <Plug>VimwikiPrevLink
nmap <c-n> <Plug>VimwikiNextLink
nmap <c-k> <Plug>VimwikiDiaryPrevDay
nmap <c-j> <Plug>VimwikiDiaryNextDay

" #############################################################################
" # Appearance
" #############################################################################

set termguicolors
set t_ut=
colorscheme gruvbox
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
" # Misc
" #############################################################################

set tags=tags
set ttimeoutlen=10
set dictionary=/usr/share/dict/words
set keywordprg=:Man

nmap <esc><esc> :nohl<CR>
nmap <leader>g :exec "G <cword>"<CR>
nmap <leader>c :!git ctags<CR><CR>
nmap <leader>e :windo e<CR>
nmap <leader>s :set spell!<CR>
nmap <F8> :exec "!codebox make \|\| read"<CR><CR>

if !has('nvim')
    set autoindent
    set background=dark
    set laststatus=2
    runtime ftplugin/man.vim
endif

" Load additional config files
for f in split(glob('~/.vimrc.d/*.vim'), '\n')
    exec 'source' f
endfor
