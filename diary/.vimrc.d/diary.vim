function! s:cycle(list)
    let l:len = len(a:list[0])
    let l:line = getline('.')
    let l:i = index(a:list, l:line[:l:len - 1])
    let l:next = a:list[(l:i + 1) % len(a:list)]
    call setline('.', l:next . l:line[l:len:])
endfunction

function! s:init()
    syntax match todoOpen "^\[ \].\+$"
    syntax match todoDone "^\[X\].\+$"
    highlight def link todoOpen PreProc
    highlight def link todoDone Normal
    setlocal formatoptions+=ro
    setlocal comments=n:\[\ \]
    nmap <buffer> <silent> <NUL> :call <sid>cycle(["[ ]", "[X]"])<CR>
endfunction

autocmd BufNewFile,BufRead */diary/*    set filetype=diary
autocmd FileType diary                  call <sid>init()
