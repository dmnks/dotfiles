" #############################################################################
" # Simple .plan support
" # More info: https://garbagecollected.org/2017/10/24/the-carmack-plan/
" #############################################################################

function! s:planCycle(list)
    let l:len = len(a:list[0])
    let l:line = getline('.')
    let l:i = index(a:list, l:line[:l:len - 1])
    if l:i < 0
        return
    endif
    let l:next = a:list[(l:i + 1) % len(a:list)]
    call setline('.', l:next . l:line[l:len:])
endfunction

function! s:planInit()
    set colorcolumn=
    set nonumber

    " Syntax
    syntax match planDate "^= .\+$"
    syntax match planOpen "^  \S.\+$"
    syntax match planPost "^+ .\+$"
    syntax match planDrop "^- .\+$"
    syntax match planNote "^# .\+$"
    highlight planDate ctermfg=13
    highlight planOpen ctermfg=10
    highlight planPost ctermfg=11
    highlight planDrop ctermfg=8
    highlight planNote ctermfg=8

    " Mappings
    nmap <buffer> <silent> <NUL>
    \   :call <sid>planCycle([' ', '*', '+', '-'])<CR>
    nmap <buffer> <silent> <CR>         :call <sid>planNext()<CR>
    nmap <silent> q :q<CR>
endfunction

function! s:planNext()
    let l:format = '= %b %d %Y ' . repeat('=', 35)
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

autocmd BufNewFile,BufRead */plan/*.plan    set filetype=plan
autocmd BufNewFile */plan/*.plan            0r ~/.vim/skeleton.plan | norm G
autocmd FileType plan                       call <sid>planInit()
