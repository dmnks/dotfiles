" Simple todo mode for Markdown
function! s:rotate()
    let symbs = split(getline(3)[2:], ' => ')
    let line = getline('.')
    let symb = substitute(line, '^ *\* \(\u\{4\}\) .*$', '\1', 'g')
    if symb == line
        return
    endif
    let idx = index(symbs, symb)
    let symb = symbs[(idx + 1) % len(symbs)]
    let line = substitute(line, '\u\{4\}', symb, 'g')
    call setline('.', line)
endfunction
autocmd BufRead,BufNewFile *.wiki
    \ nmap <buffer> <silent> <c-j> :call <sid>rotate()<CR>
