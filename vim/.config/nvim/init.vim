let mapleader = ' '

" #############################################################################
" # Plugin setup
" #############################################################################

call plug#begin()
Plug 'ellisonleao/gruvbox.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tpope/vim-commentary'
call plug#end()

" Gruvbox
let g:gruvbox_guisp_fallback = "bg"
colorscheme gruvbox
hi ColorColumn guibg=#282828
hi TabLineFill guibg=#282828
hi TabLine cterm=NONE guifg=#928374 guibg=#3c3836
hi TabLineSel guifg=#ebdbb2 guibg=#504945
hi WinSeparator guifg=#504945
hi StatusLineNC guifg=#3c3836

" Treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "bash", "lua", "vim", "vimdoc", "query",
                       "cmake", "markdown", "markdown_inline" },
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
EOF

" FZF
let g:fzf_layout = { 'tmux': '-yS' }
function! s:buflist()
    " Return listed buffers that have a name
    let listed = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    let named = map(listed, 'bufname(v:val)')
    let named = filter(named, '!empty(v:val)')
    return named
endfunction
command! GFiles
\   call fzf#run(fzf#wrap({
\       'source':  'git ls-files',
\       'options': '-m --prompt " File "',
\   }))
command! Buffers
\   call fzf#run(fzf#wrap({
\       'source':  reverse(<sid>buflist()),
\       'options': '+m --prompt " Buffer "',
\   }))
command! Tags
\   if !empty(tagfiles()) | call fzf#run(fzf#wrap({
\       'source':  "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
\       'sink':    'tag',
\       'options': '+m --prompt " Tag "',
\   })) | else | echoerr 'No tags found' | endif
nmap <leader><leader> :Buffers<CR>
nmap <leader>ff :GFiles<CR>
nmap <leader>fs :Tags<CR>

" #############################################################################
" # Appearance
" #############################################################################

set number
set numberwidth=6
set nowrap
set cursorline
set colorcolumn=80
set scrolloff=0
set laststatus=3

let c_no_curly_error = 1

" #############################################################################
" # Editing
" #############################################################################

autocmd BufRead,BufNewfile */.tmux.conf setlocal formatoptions-=t
autocmd VimResized,TabEnter * wincmd =

set textwidth=79
set softtabstop=4
set shiftwidth=4
set expandtab
set ttimeoutlen=10

nmap <leader>e :windo e<CR>
nmap <leader>s :set spell!<CR>
nmap <leader>p :set paste!<CR>

" #############################################################################
" # Searching
" #############################################################################

set ignorecase
set smartcase
set noincsearch

set tags=tags
set keywordprg=:Man

let g:ft_man_open_mode = 'vert'

nnoremap <silent> * :let @/='\<'.expand('<cword>').'\>'<bar>set hlsearch<CR>
nnoremap <silent> <C-l> :nohl<CR><C-l>

" #############################################################################
" # Git integration
" #############################################################################

autocmd FileType gitcommit setlocal spell

set grepprg=git\ grep\ -n\ $*
set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m
command -nargs=+ G exec "silent grep! <args>" | copen | redraw

nmap <leader>gg :exec "G <cword>"<CR>
nmap <silent> <leader>gb :call
\   system('tmux popup -E -w 80% -h 80% ' .
\          'sh -c "TIG_SCRIPT=<(echo :enter) tig blame +' .
\          line('.') . ' ' . expand('%') . '"')<CR>
nmap <silent> <leader>gB :call
\   system('tmux new-window -n BLAME ' .
\          'sh -c "TIG_SCRIPT=<(echo :enter) tig blame +' .
\          line('.') . ' ' . expand('%') . '"')<CR>
nmap <leader>c :call system('git ctags')<CR>

" #############################################################################
" # Misc
" #############################################################################

" Load additional config files
for f in split(glob('~/.vimrc.d/*.vim'), '\n')
    exec 'source' f
endfor
