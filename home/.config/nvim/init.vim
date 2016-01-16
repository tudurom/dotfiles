"  ╻ ╻╻┏┳┓┏━┓┏━╸
"  ┃┏┛┃┃┃┃┣┳┛┃
" ╹┗┛ ╹╹ ╹╹┗╸┗━╸

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
  " alternatively, pass a path where Vundle should install plugins
  "call vundle#begin('~/some/path/here')

  " let Vundle manage Vundle, required
  Plugin 'VundleVim/Vundle.vim'

  " The following are examples of different formats supported.
  " Keep Plugin commands between vundle#begin/end.
  " plugin on GitHub repo
  Plugin 'tpope/vim-fugitive'

  " Colorschemes
  Plugin 'chriskempson/base16-vim'

  " Others
  Plugin 'scrooloose/nerdtree'

  Plugin 'ntpeters/vim-better-whitespace'

  Plugin 'gabrielelana/vim-markdown'

  Plugin 'bling/vim-airline'
  Plugin 'Valloric/YouCompleteMe'
  Plugin 'mustache/vim-mustache-handlebars'

  " All of your Plugins must be added before the following line
  call vundle#end()            " required
  filetype plugin indent on    " required
  " To ignore plugin indent changes, instead use:
  "filetype plugin on
  "
  " Brief help
  " :PluginList       - lists configured plugins
  " :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
  " :PluginSearch foo - searches for foo; append `!` to refresh local cache
  " :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
  "
  " see :h vundle for more details or wiki for FAQ
  " Put your non-Plugin stuff after this line

" Essential things
  syntax enable
  set number
  set tabstop=2
  set expandtab
  set shiftwidth=2
  set smartindent
  set cindent

" Colors
  set t_Co=256
  let base16colorspace=256
  set background=dark
  colorscheme base16-ocean

" Airline things
  " let g:airline_powerline_fonts = 1
  let g:airline_left_sep='▓▒░'
  let g:airline_right_sep='░▒▓'
  "let g:airline_theme='term'
  set laststatus=2

" NERD things
  " Toggle NERDTree
  map <C-n> :NERDTreeToggle<CR>

" Clipboard setting
  set clipboard=unnamed

" Word wrapping
  set wrap
  set linebreak
  set nolist
  set textwidth=0
  set wrapmargin=0
