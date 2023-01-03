function! s:cycle(list)
    let l:len = len(a:list[0])
    let l:line = getline('.')
    let l:i = index(a:list, l:line[:l:len - 1])
    let l:next = a:list[(l:i + 1) % len(a:list)]
    call setline('.', l:next . l:line[l:len:])
endfunction

function! s:init()
    syntax match todoOpen "^TODO.*$"
    syntax match todoDone "^DONE.*$"
    highlight def link todoOpen diffRemoved
    highlight def link todoDone diffAdded
    setlocal formatoptions+=ro
    setlocal comments=n:TODO
    nmap <buffer> <silent> <c-a> :call <sid>cycle(["TODO", "DONE"])<CR>
    nmap <buffer> <silent> <c-k> :exec 'edit `EDITOR=echo note ' . expand("%:t") . '-1day`'<CR>
    nmap <buffer> <silent> <c-j> :exec 'edit `EDITOR=echo note ' . expand("%:t") . '+1day`'<CR>
    nmap <buffer> <silent> <c-t> :exec 'edit `EDITOR=echo note`'<CR>
    nmap <buffer> <silent> gf    :exec 'edit `EDITOR=echo note ' . expand("<cfile>") . '`'<CR>
endfunction

autocmd BufNewFile,BufRead */diary/*    set filetype=diary
autocmd BufWritePre */diary/*           call mkdir(expand("%:p:h"), "p")
autocmd FileType diary                  call <sid>init()
