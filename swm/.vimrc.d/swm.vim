autocmd BufRead,BufNewFile */libdnf/*
    \ setlocal textwidth=99 |
    \ let &colorcolumn=join(range(100, 999), ",")

let g:ale_pattern_options = {
\   '\(libdnf\).*[hc]pp$': {
\       'ale_cpp_gcc_options': '-std=c++11 -Wmissing-declarations $(pkg-config --cflags glib-2.0)',
\   },
\   '\(createrepo\|urlgrabber\|yum\).*py$': {
\       'ale_enabled': 0,
\   },
\}
