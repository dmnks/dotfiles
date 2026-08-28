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

call plug#begin()
Plug 'nvim-tree/nvim-web-devicons'
" Plug 'nvim-tree/nvim-tree.lua'
" Plug 'nvim-lualine/lualine.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf.vim'
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
"lua << EOF
"require('lualine').setup {
"    options = {
"        section_separators = "",
"        component_separators = "",
"        globalstatus = true,
"    },
"    sections = {
"        lualine_c = {
"            {
"                "filename",
"                fmt = function(name)
"                    if vim.bo.filetype == "fzf" then
"                        return name:gsub("^%d+;#", "")
"                    end
"                    return name
"                end,
"            },
"        },
"    },
"}
"EOF

lua << EOF
require("gruvbox").setup {
  terminal_colors = false,
  bold = false,
  italic = {
    strings = false,
  },
}
EOF

colorscheme gruvbox

lua << EOF
local function set_colors()
    local new_bg = vim.o.background
    if new_bg == "dark" then
      vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#282828" })
      vim.api.nvim_set_hl(0, "TermNormal", { fg = "#d5c4a1" })
    else
      vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#fbf1c7" })
      vim.api.nvim_set_hl(0, "TermNormal", { link = "Normal" })
    end
    vim.api.nvim_set_hl(0, "TabLineSel", { link = "StatusLine" })
end
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = set_colors;
})
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.wo.winhighlight = "Normal:TermNormal,FloatBorder:Comment," ..
                          "FloatTitle:Identifier"
  end,
})
set_colors()
EOF

" FZF
let g:fzf_colors =
\ { 'fg':           ['fg', 'TermNormal'],
  \ 'bg':           ['bg', 'Normal'],
  \ 'query':        ['fg', 'Normal'],
  \ 'hl':           ['fg', 'Comment'],
  \ 'fg+':          ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':          ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':          ['fg', 'Identifier'],
  \ 'info':         ['fg', 'Comment'],
  \ 'border':       ['fg', 'Comment'],
  \ 'input-border': ['fg', 'Identifier'],
  \ 'prompt':       ['fg', 'Identifier'],
  \ 'pointer':      ['fg', 'Exception'],
  \ 'marker':       ['fg', 'Keyword'],
  \ 'spinner':      ['fg', 'Label'],
  \ 'scrollbar':    ['bg', 'CursorLine', 'CursorColumn'],
  \ 'ghost':        ['fg', 'Comment'],
  \ 'header':       ['fg', 'Comment'] }
let g:fzf_layout = { 'window': { 'yoffset': 0, 'width': 0.5, 'height': 0.5 } }
let g:fzf_vim = {}
let g:fzf_vim.preview_window = []
let g:fzf_vim.buffers_options = '--ghost "Select a buffer"'
let g:fzf_vim.tags_options = '--ghost "Select a tag"'
function! s:worktree(path)
    exec "cd " . a:path
endfunction
command! Projects
    \ call fzf#run(fzf#wrap({
    \   'source':  'find $HOME/code -maxdepth 4 -name .git -type d -printf "%h\n"',
    \   'sink':    function('<sid>worktree'),
    \   'options': '-m --ghost "Select a project"',
    \ }))
command! Worktrees
    \ call fzf#run(fzf#wrap({
    \   'source':  'git worktree list --porcelain | ' .
    \              'sed -n "s/worktree //p" |' .
    \              'sort',
    \   'sink':    function('<sid>worktree'),
    \   'options': '-m --ghost "Select a worktree"',
    \ }))
command! GFiles
    \ call fzf#vim#files(
    \   getcwd(),
    \   {'source': 'git -C ' . shellescape(getcwd()) . ' ls-files',
    \    'options': '--ghost "Open a file"' })
nmap <leader><leader> :Buffers<CR>
nmap <leader>fw :Worktrees<CR>
nmap <leader>ff :GFiles<CR>
nmap <leader>fs :Tags<CR>

" #############################################################################
" # Navigation
" #############################################################################

tnoremap <A-q> <C-\><C-n>

tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l

nnoremap <A-q> <C-6>
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
nnoremap <A-o> gt
nnoremap <A-i> gT

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
set guicursor+=t:block-blinkon0
set cmdheight=0

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
nmap <silent> <leader>c :call system('git ctags')<CR>

lua << EOF
local function popup(cmd, title, width, height)
  local width = math.floor(vim.o.columns * width)
  local height = math.floor(vim.o.lines * height)

  local buf = vim.api.nvim_create_buf(false, true)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = "center",
  })

  vim.fn.termopen(cmd, {
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end)
    end,
  })

  vim.cmd("startinsert")
end

vim.keymap.set("n", "<M-s>", function()
  popup("tide git", "Git Status", 0.9, 0.9)
end)
vim.keymap.set("n", "<leader>gl", function()
  ln = vim.fn.line(".")
  fn = vim.fn.expand("%")
  popup("sh -c 'TIG_SCRIPT=<(echo :enter) tig -L" .. ln .. ",+1:" .. fn .. "'",
        "Git Log: " .. fn .. ":" .. ln,
        0.9, 0.9)
end)
vim.keymap.set("n", "<leader>gL", function()
  fn = vim.fn.expand("%")
  popup("sh -c 'TIG_SCRIPT=<(echo :enter) tig --follow " .. fn .. "'",
        "Git Log: " .. fn,
        0.9, 0.9)
end)
vim.keymap.set("n", "<leader>gb", function()
  ln = vim.fn.line(".")
  fn = vim.fn.expand("%")
  popup("sh -c 'TIG_SCRIPT=<(echo :enter) tig blame +" ..
        ln .. " " .. fn .. "'",
        "Git Blame: " .. fn .. ":" .. ln,
        0.9, 0.9)
end)

local function osc7()
  io.stdout:write("\27]7;file://" .. vim.uv.os_gethostname() ..
                  vim.fn.getcwd() .. "\27\\")
  io.stdout:flush()
end

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, { callback = osc7 })

vim.opt.title = true
vim.opt.titlestring = "%{substitute(getcwd(), '^/home/mdomonko/code/', '', '')} — Neovim"

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end,
})
vim.keymap.set("t", "<C-\\><C-n>", "<Nop>")
vim.keymap.set("t", "<A-h>", function()
  vim.cmd.wincmd("h")
end)
vim.keymap.set("t", "<A-l>", function()
  vim.cmd.wincmd("l")
end)
vim.keymap.set("n", "<A-o>", "<Cmd>botright vsplit | terminal<CR>i")
vim.keymap.set("t", "<A-o>", "<Cmd>botright vsplit | terminal<CR>")
vim.keymap.set("n", "<A-e>", "<Cmd>botright split | terminal<CR>i")
vim.keymap.set("t", "<A-e>", "<Cmd>botright split | terminal<CR>")

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  callback = function()
    vim.wo.cursorline = vim.bo.buftype ~= "terminal"
  end,
})

local function tab_name(tab)
  local win = vim.api.nvim_tabpage_get_win(tab)
  local buf = vim.api.nvim_win_get_buf(win)

  if vim.bo[buf].buftype == "terminal" then
    return vim.b[buf].term_title or "terminal"
  end

  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
end

EOF

" #############################################################################
" # Misc
" #############################################################################

" Load additional config files
for f in split(glob('~/.vimrc.d/*.vim'), '\n')
    exec 'source' f
endfor
