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
    " syntax match planGoal "^@ .\+$"
    highlight link planDate Constant
    highlight link planOpen Macro
    highlight link planPost Type
    highlight link planDrop Comment
    " highlight link planGoal Define

    " Mappings
    nmap <buffer> <silent> <C-space>
    \   :call <sid>planCycle([' ', '*', '+', '-'])<CR>
    nmap <buffer> <silent> <CR>         :call <sid>planNext()<CR>
    nmap <silent> q :q<CR>
endfunction

function! s:planNext()
    let l:format = '= %a %b %d %Y ' . repeat('=', 35)
    let l:line = getline(search('^= ', 'bn'))
    let l:prev = strptime(l:format, l:line)
    if l:prev == 0
        return
    endif
    " +1 hour to cover for DST changes
    let l:delta = 25*60*60
    " Skip weekends
    if split(l:line)[1] == 'Fri'
        let l:delta = l:delta * 3
    endif
    let l:next = strftime(l:format, l:prev + l:delta)
    call append(line('.'), ['', l:next, ''])
    normal! 3j
endfunction

autocmd BufNewFile,BufRead */plan/*.plan    set filetype=plan
autocmd BufNewFile */plan/*.plan            0r ~/.vim/skeleton.plan | norm G
autocmd FileType plan                       call <sid>planInit()
