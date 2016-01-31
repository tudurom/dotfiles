"  ╻ ╻╻┏┳┓┏━┓┏━╸
"  ┃┏┛┃┃┃┃┣┳┛┃
" ╹┗┛ ╹╹ ╹╹┗╸┗━╸

set nocompatible              " be iMproved, required
filetype off                  " required

" Plugins {{{
call plug#begin('~/.config/nvim/plugged')

  " Colorschemes
  Plug 'chriskempson/base16-vim'
  Plug 'noahfrederick/vim-noctu'

  " Others
  Plug 'scrooloose/nerdtree'

  Plug 'ntpeters/vim-better-whitespace'

  Plug 'gabrielelana/vim-markdown'

  Plug 'bling/vim-airline'

  Plug 'ervandew/supertab'

  " Focus...
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/limelight.vim'

  call plug#end()            " required
  filetype plugin indent on    " required
" }}}

" Essential things {{{
  syntax enable
  set number
  set tabstop=2
  set expandtab
  set shiftwidth=2
  set smartindent
  set cindent
" }}}

" Colors {{{
  set t_Co=256
  let base16colorspace=256
  set background=dark
  "colorscheme base16-ocean
  "colo noctu
  colo shblah
" }}}

" Airline {{{
  " let g:airline_powerline_fonts = 1
  let g:airline_left_sep='▓▒░'
  let g:airline_right_sep='░▒▓'
  "let g:airline_theme='term'
  set laststatus=2
" }}}

" NERD things {{{
  " Toggle NERDTree
  map <C-n> :NERDTreeToggle<CR>
" }}}

" Goyo settings {{{
  let g:goyo_width='80%'
  let g:goyo_height='90%'
" }}}

" Clipboard setting {{{
  set clipboard=unnamed
" }}}

" Word wrapping {{{
  set wrap
  set linebreak
  set nolist
  set textwidth=0
  set wrapmargin=0
" }}}

" Code folding {{{
  set fdm=marker
  map <C-d> za
" }}}

" Completion {{{
  filetype plugin on
  set omnifunc=syntaxcomplete#Complete
" }}}

" Focus... {{{
  let g:limelight_conceal_ctermfg = 'gray'
  autocmd! User GoyoEnter Limelight
  autocmd! User GoyoLeave Limelight!
" }}}
