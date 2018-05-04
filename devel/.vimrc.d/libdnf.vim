autocmd BufRead,BufNewFile */projects/libdnf/*
    \ setlocal textwidth=99 colorcolumn=100

let g:ale_pattern_options = {
\   'projects/libdnf/.*$': {
\       'ale_cpp_gcc_options': '-std=c++11 -Wmissing-declarations $(pkg-config --cflags glib-2.0)',
\   },
\}
