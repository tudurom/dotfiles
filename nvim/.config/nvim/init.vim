" ╻┏┓╻╻╺┳╸ ╻ ╻╻┏┳┓
" ┃┃┗┫┃ ┃  ┃┏┛┃┃┃┃
" ╹╹ ╹╹ ╹ ╹┗┛ ╹╹ ╹
" init.vim written with extensibility in mind

set nocompatible              " be iMproved, required
filetype off                  " required

" Plugins {{{
  set rtp+=~/.config/nvim/bundle/Vundle.vim
  call vundle#begin('~/.config/nvim/bundle')
  
  Plugin 'gmarik/Vundle.vim'

  " Colorschemes
  Plugin 'chriskempson/base16-vim'
  Plugin 'noahfrederick/vim-noctu'

  " Focusing
  Plugin 'junegunn/goyo.vim'

  " Others
  " File tree. Sometimes useful and sometimes it looks good
  Plugin 'scrooloose/nerdtree'

  " For obvious reasons
  Plugin 'ntpeters/vim-better-whitespace'

  " Statusline
  Plugin 'itchyny/lightline.vim'

  " Syntax plugins
  Plugin 'gabrielelana/vim-markdown'
  Plugin 'othree/html5.vim'

  " Simple tab completion
  "Plug 'ervandew/supertab'
  Plugin 'valloric/youcompleteme'

  Plugin 'airblade/vim-gitgutter'

  " One plugin to rule them all
  Plugin 'sheerun/vim-polyglot'

  call vundle#end()            " required
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
  " Fuck YCM
  let g:ycm_global_ycm_extra_conf = '/home/tudurom/problems/.ycm_extra_conf.py'

  " Nope
  set noswapfile
  " Set backup/undo dirs
  set backupdir=~/.config/nvim/tmp/backups//
  set undodir=~/.config/nvim/tmp/undo//

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
  set clipboard^=unnamed,unnamedplus
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
