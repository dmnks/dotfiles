command! -nargs=? Note call <sid>edit(<q-args>)
command! NoteReload call <sid>load()

function! s:edit(time)
    let l:time = a:time
    if empty(l:time)
        let l:time = "today"
    endif
    exec "edit" "~/diary/" .
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
    let s:entries = globpath("~/diary", "*/*/*/*", 0, 1)
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
    highlight def link todoOpen diffRemoved
    highlight def link todoDone diffAdded
    setlocal formatoptions+=ro
    setlocal comments=n:TODO
    nmap <buffer> <silent> <c-a> :call <sid>cycle(["TODO", "DONE"])<CR>
    nmap <buffer> <silent> <c-k> :call <sid>move(-1)<cr>
    nmap <buffer> <silent> <c-j> :call <sid>move(1)<cr>
    nmap <buffer> <silent> <c-t> :Note<cr>
    call <sid>load()
endfunction

autocmd BufNewFile,BufRead */diary/*    set filetype=diary
autocmd BufWritePre */diary/*           call mkdir(expand("%:p:h"), "p")
autocmd FileType diary                  call <sid>init()
