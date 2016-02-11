" ╻┏┓╻╻╺┳╸ ╻ ╻╻┏┳┓
" ┃┃┗┫┃ ┃  ┃┏┛┃┃┃┃
" ╹╹ ╹╹ ╹ ╹┗┛ ╹╹ ╹
" init.vim written with extensibility in mind

set nocompatible              " be iMproved, required
filetype off                  " required

" Plugins {{{
  call plug#begin('~/.config/nvim/plugged')

  " Colorschemes
  Plug 'chriskempson/base16-vim'
  Plug 'noahfrederick/vim-noctu'

  " Focusing
  Plug 'junegunn/goyo.vim'

  " Others
  " File tree. Sometimes useful and sometimes it looks good
  Plug 'scrooloose/nerdtree'

  " For obvious reasons
  Plug 'ntpeters/vim-better-whitespace'

  " Statusline
  Plug 'itchyny/lightline.vim'

  " Syntax plugins
  Plug 'gabrielelana/vim-markdown'
  Plug 'othree/html5.vim'

  " Simple tab completion
  "Plug 'ervandew/supertab'
  Plug 'valloric/youcompleteme'

  Plug 'airblade/vim-gitgutter'

  " One plugin to rule them all
  Plug 'sheerun/vim-polyglot'

  call plug#end()            " required
  filetype plugin indent on    " required
" }}}

" Essential things {{{

  " Syntax and tabs
  syntax enable " Enable syntax highlighting, duh
  set number    " Looks better
  set tabstop=2
  set expandtab
  set shiftwidth=2
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
" }}}

" Keybindings {{{

  " C-d to hide find results
  nnoremap <silent> <C-d> :noh<CR>
  tnoremap <Esc> <C-\><C-n>

" }}}

" Colors {{{
  set t_Co=256
  set background=dark
  colo shblah
" }}}

" NERD things {{{
  " Toggle NERDTree
  map <C-n> :NERDTreeToggle<CR>
" }}}

" Statusline {{{
  set laststatus=2
  let g:lightline = {
    \ 'colorscheme': 'cloudy',
    \ 'active': {
    \   'left': [ [ 'filename' ],
    \             [ 'readonly', 'fugitive' ] ],
    \   'right': [ [ 'percent', 'lineinfo' ],
    \              [ 'fileencoding', 'filetype' ],
    \              [ 'fileformat', 'syntastic' ] ]
    \ },
    \ 'separator': { 'left': '▓▒░', 'right': '░▒▓' },
    \ 'subseparator': { 'left': '▒', 'right': '░' }
    \ }
" }}}

" Clipboard setting {{{
  set clipboard+=unnamedplus
" }}}

" Word wrapping {{{
  set wrap
  set linebreak
  set nolist
  set textwidth=0
  set wrapmargin=0
" }}}

" Focusing {{{
  let g:goyo_width='80%'
  let g:goyo_height='90%'
" }}}

" Completion {{{
  let g:deoplete#enable_at_startup = 1
" }}}
