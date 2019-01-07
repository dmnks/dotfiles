" libdnf
autocmd BufRead,BufNewFile */code/libdnf/*
    \ setlocal textwidth=99 colorcolumn=100

let g:ale_pattern_options = {
\   '\(libdnf\).*[hc]pp$': {
\       'ale_cpp_gcc_options': '-std=c++11 -Wmissing-declarations $(pkg-config --cflags glib-2.0)',
\   },
\}

" yum
let g:ale_pattern_options = {
\   '\(createrepo\|urlgrabber\|yum\).*py$': {
\       'ale_enabled': 0,
\   },
\}
