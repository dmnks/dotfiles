let s:path = "~/diary"
command! -nargs=? Note call <sid>edit(<q-args>)
command! NoteReload call <sid>load()

function! s:edit(time)
    let l:time = a:time
    if empty(l:time)
        let l:time = "today"
    endif
    exec "edit" s:path . "/" .
    \   system("date +'%Y/Q%q/W%V/%Y-%m-%d' -d '" . a:time . "'")
endfunction

function! s:move(i)
    let l:index = index(s:entries, expand("%:p"))
    let l:next = l:index + a:i
    if l:next > len(s:entries) - 1
        echom "Already at newest entry"
        return
    elseif l:next < 0
        echom "Already at oldest entry"
        return
    endif
    exec "edit" s:entries[l:next]
endfunction

function! s:load()
    let s:entries = globpath(s:path, "*/*/*/*", 0, 1)
endfunction

function! s:cycle(list)
    let l:len = len(a:list[0])
    let l:line = getline('.')
    let l:i = index(a:list, l:line[:l:len - 1])
    if l:i < 0
        return
    endif
    let l:next = a:list[(l:i + 1) % len(a:list)]
    call setline('.', l:next . l:line[l:len:])
endfunction

function! s:init()
    syntax match todoOpen "^TODO.*$"
    syntax match todoDone "^DONE.*$"
    syntax match todoDate "^DATE.*$"
    syntax match todoNote "^NOTE.*$"
    highlight def link todoOpen diffAdded
    highlight def link todoDone Constant
    highlight def link todoDate diffRemoved
    highlight def link todoNote Identifier
    setlocal formatoptions+=ro
    setlocal comments=n:TODO
    nmap <buffer> <silent> <c-a>
    \   :call <sid>cycle(["TODO", "DONE", "NOTE", "DATE"])<CR>
    nmap <buffer> <silent> <c-k> :call <sid>move(-1)<cr>
    nmap <buffer> <silent> <c-j> :call <sid>move(1)<cr>
    nmap <buffer> <silent> <c-t> :Note<cr>
    nmap <buffer> <silent> <c-m> :Note last Mon<cr>
    call <sid>load()
    exec "lcd" s:path
endfunction

autocmd BufNewFile,BufRead */diary/*    set filetype=diary
autocmd BufWritePre */diary/*           call mkdir(expand("%:p:h"), "p")
autocmd BufWritePost */diary/*          call <sid>load()
autocmd FileType diary                  call <sid>init()
