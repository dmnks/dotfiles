" #############################################################################
" # Startup
" #############################################################################

" " Eagerly disable netrw to avoid race conditions with nvim-tree
" " (see :h nvim-tree for details)
" lua << EOF
" vim.g.loaded_netrw = 1
" vim.g.loaded_netrwPlugin = 1
" EOF

let mapleader = ' '

" #############################################################################
" # Plugin setup
" #############################################################################

let g:fzf_colors = {
\   'fg':           ['fg', 'Normal'],
\   'bg':           ['bg', 'CursorLine'],
\   'border':       ['bg', 'CursorLine'],
\   'query':        ['fg', 'Normal'],
\   'hl':           ['fg', 'Comment'],
\   'fg+':          ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
\   'bg+':          ['bg', 'StatusLine'],
\   'hl+':          ['fg', 'Statement'],
\   'prompt':       ['fg', 'Conditional'],
\   'pointer':      ['fg', 'Exception'],
\   'marker':       ['fg', 'Keyword'],
\   'ghost':        ['fg', 'Comment'],
\   'scrollbar':    ['fg', 'WinSeparator'],
\   }


call plug#begin()
" Plug 'nvim-tree/nvim-web-devicons'
" Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'tpope/vim-commentary'
call plug#end()

" " Nvim-tree
" lua << EOF
" require('nvim-tree').setup {
"   actions = {
"     open_file = {
"       window_picker =  {
"         enable = false,
"       },
"     },
"   },
" }
" EOF
" nmap <leader>t :NvimTreeToggle<CR>

" Lualine
lua << EOF
require('lualine').setup {
  options = {
    globalstatus = true,
  },
}
EOF

" Treesitter
lua << EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "cpp", "bash", "lua", "vim", "vimdoc", "query",
                       "cmake", "markdown", "markdown_inline" },
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
require('treesitter-context').setup {
  enabled = true,
  max_lines = 1,
  trim_scope = 'inner',
  multiwindow = true,
}
require("gruvbox").setup {
  bold = false,
  italic = {
    strings = false,
  },
}
EOF


colorscheme gruvbox

" FZF
let g:fzf_layout = {
\   'window': { 'width': 0.5, 'height': 0.5, 'border': 'sharp', 'yoffset': 0 }}
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
\       'options': '-m --ghost "Open a file"',
\   }))
command! Buffers
\   call fzf#run(fzf#wrap({
\       'source':  reverse(<sid>buflist()),
\       'options': '+m --ghost "Open a buffer"',
\   }))
command! Tags
\   if !empty(tagfiles()) | call fzf#run(fzf#wrap({
\       'source':  "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
\       'sink':    'tag',
\       'options': '+m --ghost "Find a symbol"',
\   })) | else | echoerr 'No tags found' | endif
nmap <leader><leader> :Buffers<CR>
nmap <leader>ff :GFiles<CR>
nmap <leader>fs :Tags<CR>

" #############################################################################
" # Navigation
" #############################################################################

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <C-n> gt
nnoremap <C-p> gT

" #############################################################################
" # Appearance
" #############################################################################

set number
set numberwidth=6
set nowrap
set cursorline
set scrolloff=0
set laststatus=3

let c_no_curly_error = 1

nmap <silent> <leader>r :source ~/.config/nvim/init.vim<CR>

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
set mouse=
set splitkeep=screen

nmap <silent> <leader>e :windo e<CR>
nmap <silent> <leader>s :set spell!<CR>
nmap <silent> <leader>p :set paste!<CR>
nmap <silent> <leader>p V"_dP

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
nnoremap <silent> <esc><esc> :nohl<CR>

" #############################################################################
" # Git integration
" #############################################################################

autocmd FileType gitcommit setlocal spell

set grepprg=git\ grep\ -n\ $*
set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m
command -nargs=+ G exec "silent grep! <args>" | copen | redraw

nmap <silent> <leader>gg :exec "G <cword>"<CR>
nmap <silent> <leader>gl :call
\   system('tmux new-window -n " ' . expand('%:t') . ':' . line('.') . '" ' .
\          'sh -c "TIG_SCRIPT=<(echo :enter) tig -L' .
\          line('.') . ',+1:' . expand('%') . '"')<CR>
nmap <silent> <leader>gL :call
\   system('tmux new-window -n " ' . expand('%:t') . '" ' .
\          'sh -c "TIG_SCRIPT=<(echo :enter) tig --follow ' .
\          expand('%') . '"')<CR>
nmap <silent> <leader>gb :call
\   system('tmux new-window -n " ' . expand('%:t') . '" ' .
\          'sh -c "TIG_SCRIPT=<(echo :enter) tig blame +' .
\          line('.') . ' ' . expand('%') . '"')<CR>
nmap <silent> <leader>c :call system('git ctags')<CR>

" #############################################################################
" # Misc
" #############################################################################

" Load additional config files
for f in split(glob('~/.vimrc.d/*.vim'), '\n')
    exec 'source' f
endfor

lua << EOF
-- Function to open tig in a floating terminal
function OpenTermPopup(cmd)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = 0

  -- Create a scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Open a floating window
  vim.api.nvim_open_win(buf, true, {
    title = "Git Status",
    title_pos = "center",
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = 0,
    style = "minimal",
    border = "solid",
  })

  vim.fn.termopen(cmd, {
    on_exit = function()
        vim.api.nvim_buf_delete(buf, { force = true })
    end,
  })

  vim.cmd("startinsert") -- start in insert mode for terminal input
end

-- Optional keymap, e.g. <leader>g
vim.keymap.set("n", "<M-s>", function() OpenTermPopup("tide git") end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gl", function()
    local line = vim.fn.line(".")
    local file = vim.fn.expand("%")
    local cmd = string.format("tig -L%d,+1:%s", line, file)
    OpenTermPopup(string.format("sh -c 'TIG_SCRIPT=<(echo :enter) %s'", cmd))
end, { noremap = true, silent = true })

-- vim.opt.statusline = "%!v:lua.MyStatusLine()"
-- 
-- function _G.MyStatusLine()
--   if vim.bo.buftype == "terminal" then
--     return ""  -- empty statusline for terminal buffers
--   end
--   return "%f %h%m%r%=%-14.(%l,%c%V%) %P"  -- default-ish statusline
-- end

EOF
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-blink0-TermCursor
