autocmd BufRead,BufNewFile */{rpm,popt}/**/*.{c,h,at} setlocal noexpandtab
autocmd BufRead,BufNewFile */{rpm,popt}/**/{CMakeLists.txt,*.cmake}
\   setlocal softtabstop=0 shiftwidth=8 noexpandtab
autocmd BufRead,BufNewFile */rpm/**/atlocal.in set filetype=sh
autocmd BufRead,BufNewFile */rpm/**/mktree.common set filetype=sh
