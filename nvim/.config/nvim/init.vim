" ╻┏┓╻╻╺┳╸ ╻ ╻╻┏┳┓
" ┃┃┗┫┃ ┃  ┃┏┛┃┃┃┃
" ╹╹ ╹╹ ╹ ╹┗┛ ╹╹ ╹
" init.vim written with extensibility in mind

filetype off

let g:uname = substitute(system("uname"), '\n\+$', '', '')

" Plugins {{{

call plug#begin('~/.config/nvim/bundle')

" For obvious reasons
Plug 'ntpeters/vim-better-whitespace'

" Simple tab completion
Plug 'ajh17/vimcompletesme'
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
if executable('go')
    Plug 'fatih/vim-go'
endif
if executable('clang')
    Plug 'justmao945/vim-clang'
endif

" Syntax checking
Plug 'scrooloose/syntastic'

" Show changes
Plug 'airblade/vim-gitgutter'

" One plugin to rule them all
Plug 'sheerun/vim-polyglot'

call plug#end()              " required
filetype plugin indent on    " required

" }}}

" Essential settings {{{

" Syntax and tabs
syntax enable " Enable syntax highlighting, duh
set number    " Looks better
set backspace=indent,eol,start
set tabstop=4
set expandtab
set shiftwidth=4
set smartindent
set cindent
" Make things snappy
set updatetime=250
" Fold markers
set fdm=marker
" ingorecase + smartcase
set ignorecase
set smartcase
" Make it natural
set splitright
set splitbelow

" Nope
set noswapfile
" Set backup/undo dirs
set backupdir=~/.config/nvim/tmp/backups/
set undodir=~/.config/nvim/tmp/undo/

" Make the folders automatically if they don't already exist.
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif

if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif

" Make undo work after the file is closed
set undofile
set undolevels=500
set undoreload=500

" }}}

" Keybindings {{{

" C-d to hide find results
nnoremap <silent> <Leader>d :noh<CR>
" Esc in terminal
tnoremap <Esc> <C-\><C-n>
" jk to exit insert mode
inoremap jk <ESC>
" Navigate long lines easily
map j gj
map k gk
" Just in case
cabbr W w
cabbr Q q
cabbr Wq wq

" }}}

" Colors {{{

set background=dark
colo shblah
" }}}

" NERD things {{{

" Toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

" }}}

" Statusline {{{

set laststatus=2 " Make the bar permanent
set showmode

" }}}

" Clipboard setting {{{

set clipboard^=unnamed,unnamedplus

" }}}

" Word wrapping {{{

set wrap
set linebreak
set nolist
set textwidth=0
set wrapmargin=0

" }}}

" Filetypes {{{

filetype plugin indent on
augroup Filetypes
    au!

    au BufRead,BufNewFile *.md setlocal textwidth=80 spell spelllang=en_us

augroup end

" }}}

" Leader hax {{{

map <Space> <Leader>
nmap <Leader>- :split<CR>
nmap <Leader>\| :vsplit<CR>

map <Leader>h <C-w>h
map <Leader>j <C-w>j
map <Leader>k <C-w>k
map <Leader>l <C-w>l
map <Leader>= <C-w>=

" }}}

filetype plugin on
set omnifunc=syntaxcomplete#Complete

" Golang {{{
let g:go_fmt_command = "goimports"
let g:go_term_mode = "split"
let g:go_term_enabled = 1
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
let g:go_list_type = "quickfix"
au FileType go nmap <leader>rt <Plug>(go-run-tab)
au FileType go nmap <Leader>rs <Plug>(go-run-split)
au FileType go nmap <Leader>rv <Plug>(go-run-vertical)

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
" }}}

" Syntax checking {{{

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" }}}

" Romanian Digraphs {{{
" Vim comes default with turkish ş and ţ

dig S, 536
dig s, 537

dig T, 538
dig t, 539

" }}}

" Hard mode {{{
"noremap <Up> <NOP>
"noremap <Down> <NOP>
"noremap <Left> <NOP>
"noremap <Right> <NOP>
"
"inoremap <Up> <NOP>
"inoremap <Down> <NOP>
"inoremap <Left> <NOP>
"inoremap <Right> <NOP>
" }}}
