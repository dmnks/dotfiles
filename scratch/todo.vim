function! s:nextDay()
    let l:line = getline(search('^@', 'bn'))
    let l:prev = strptime('%a %Y-%m-%d', l:line[2:])
    let l:next = strftime('%a %Y-%m-%d', l:prev + 24*60*60)
    call append(line('.'), '')
    normal! j
    call append(line('.'), '@ ' . l:next)
    normal! j
endfunction
autocmd BufRead,BufNewFile journal*.diff
    \ nmap <buffer> <silent> <leader>j :call <sid>nextDay()<CR>
