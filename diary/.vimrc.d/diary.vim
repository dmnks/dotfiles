function! s:cycle(list)
    let l:len = len(a:list[0])
    let l:line = getline('.')
    let l:i = index(a:list, l:line[:l:len - 1])
    let l:next = a:list[(l:i + 1) % len(a:list)]
    call setline('.', l:next . l:line[l:len:])
endfunction

function! s:init()
    syntax match todoOpen "^TODO.\+$"
    syntax match todoWork "^WORK.\+$"
    syntax match todoDone "^DONE.\+$"
    syntax match todoDate "^DATE.\+$"
    highlight def link todoOpen PreProc
    highlight def link todoWork Type
    highlight def link todoDone Normal
    highlight def link todoDate Conditional
    setlocal formatoptions+=ro
    setlocal comments=n:TODO
    nmap <buffer> <silent> <NUL> :call <sid>cycle(["TODO", "DONE", "WORK", "DATE"])<CR>
endfunction

autocmd BufNewFile,BufRead */diary/*    set filetype=diary
autocmd FileType diary                  call <sid>init()
