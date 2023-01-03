let s:days = globpath("~/diary", "*/*/*/*", 0, 1)

function! s:cycle(list)
    let l:len = len(a:list[0])
    let l:line = getline('.')
    let l:i = index(a:list, l:line[:l:len - 1])
    let l:next = a:list[(l:i + 1) % len(a:list)]
    call setline('.', l:next . l:line[l:len:])
endfunction

function! s:next(i)
    let l:index = index(s:days, expand("%:p"))
    let l:next = l:index + a:i
    if l:next > len(s:days) - 1
        echom "Already at newest entry"
        return
    elseif l:next < 0
        echom "Already at oldest entry"
        return
    endif
    exec "edit ". s:days[l:next]
endfunction

function! s:init()
    syntax match todoOpen "^TODO.*$"
    syntax match todoDone "^DONE.*$"
    highlight def link todoOpen diffRemoved
    highlight def link todoDone diffAdded
    setlocal formatoptions+=ro
    setlocal comments=n:TODO
    nmap <buffer> <silent> <c-a> :call <sid>cycle(["TODO", "DONE"])<CR>
    nmap <buffer> <silent> <c-k> :call <sid>next(-1)<cr>
    nmap <buffer> <silent> <c-j> :call <sid>next(1)<cr>
    nmap <buffer> <silent> <c-t> :exec 'edit `EDITOR=echo note`'<CR>
    nmap <buffer> <silent> gf    :exec 'edit `EDITOR=echo note ' . expand("<cfile>") . '`'<CR>
endfunction

autocmd BufNewFile,BufRead */diary/*    set filetype=diary
autocmd BufWritePre */diary/*           call mkdir(expand("%:p:h"), "p")
autocmd FileType diary                  call <sid>init()
