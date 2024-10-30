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
let g:fzf_layout = { 'tmux': '-p -yS' }
function! s:buflist()
    " Return listed buffers that have a name
    let listed = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    let named = map(listed, 'bufname(v:val)')
    let named = filter(named, '!empty(v:val)')
    return named
endfunction
command! GFiles
    \ call fzf#run(fzf#wrap({
    \   'source':  'git ls-files',
    \   'options': '-m --prompt " File "',
    \ }))
command! Buffers
    \ call fzf#run(fzf#wrap({
    \   'source':  reverse(<sid>buflist()),
    \   'options': '+m --prompt " Buffer "',
    \ }))
command! Tags
    \ if !empty(tagfiles()) | call fzf#run(fzf#wrap({
    \   'source':  "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
    \   'sink':    'tag',
    \   'options': '+m --prompt " Tag "',
    \ })) | else | echoerr 'No tags found' | endif
nmap <leader>ff :GFiles<CR>
nmap <leader><leader> :Buffers<CR>
nmap <leader>fs :Tags<CR>

" #############################################################################
" # Appearance
" #############################################################################

set termguicolors
" Fix spell highlight, see https://github.com/morhetz/gruvbox/issues/175
let g:gruvbox_guisp_fallback = "bg"
colorscheme gruvbox
set background=dark
hi ColorColumn guibg=#282828
hi TabLineFill guibg=#1d2021
hi TabLine cterm=NONE guifg=#928374 guibg=#1d2021
hi TabLineSel guifg=#ebdbb2
hi VertSplit guifg=#171a1a
hi StatusLineNC guifg=#1d2021
set fillchars=vert:┃
set number
set numberwidth=6
set title
set nowrap
set guicursor=a:blinkon0
set cursorline
set colorcolumn=80
autocmd FileType gitcommit setlocal textwidth=72 colorcolumn=73
autocmd FileType gitcommit setlocal spell
autocmd BufRead,BufNewfile */.tmux.conf setlocal formatoptions-=t
autocmd VimResized,TabEnter * wincmd =
set scrolloff=0

let c_no_curly_error = 1

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
set textwidth=79

" #############################################################################
" # Searching
" #############################################################################

set ignorecase
set smartcase
set noincsearch
set grepprg=git\ grep\ -n\ $*
command -nargs=+ G exec "silent grep! " . <q-args> . " ':(exclude)po/*.po'"
    \ | copen | redraw!
nnoremap <silent> * :let @/='\<'.expand('<cword>').'\>'<bar>set hlsearch<CR>

" #############################################################################
" # Misc
" #############################################################################

set tags=tags
set ttimeoutlen=10
set dictionary=/usr/share/dict/words
set keywordprg=:Man
let g:ft_man_open_mode = 'vert'

nnoremap <silent> <C-l> :nohl<CR><C-l>
nmap <leader>gg :exec "G <cword>"<CR>
nmap <leader>gb :call
    \ system('tmux popup -E -w 80% -h 80% tig blame +'
    \ . line('.') . ' ' . expand('%'))<CR>
nmap <leader>gB :call
    \ system('tmux new-window -n Blame tig blame +'
    \ . line('.') . ' ' . expand('%'))<CR>
nmap <leader>e :windo e<CR>
nmap <leader>s :set spell!<CR>
nmap <leader>p :set paste!<CR>
nmap <leader>c :call system('git ctags')<CR>
nmap <C-j> ddp
nmap <C-k> ddkP

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
