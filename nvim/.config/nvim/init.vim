" ╻┏┓╻╻╺┳╸ ╻ ╻╻┏┳┓
" ┃┃┗┫┃ ┃  ┃┏┛┃┃┃┃
" ╹╹ ╹╹ ╹ ╹┗┛ ╹╹ ╹
" init.vim without description

filetype off

let g:uname = substitute(system("uname"), '\n\+$', '', '')

" Plugins {{{

call plug#begin('~/.config/nvim/bundle')

" For obvious reasons
Plug 'ntpeters/vim-better-whitespace'

" Simple tab completion
Plug 'ajh17/vimcompletesme'
if executable('go')
	Plug 'fatih/vim-go'
endif
if executable('clang')
	Plug 'rip-rip/clang_complete'
endif

" Syntax checking
Plug 'scrooloose/syntastic'

" Show changes
Plug 'airblade/vim-gitgutter'

" Markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

Plug 'othree/html5.vim'

" Tmux integration
Plug 'christoomey/vim-tmux-navigator'

" Resize mode
Plug 'simeji/winresizer'

" Colors
Plug 'whatyouhide/vim-gotham'

" Going mainstream
"Plug 'itchyny/lightline.vim'
Plug 'vim-airline/vim-airline'

call plug#end()
filetype plugin indent on

let g:vim_markdown_frontmatter = 1
" }}}

" Essential settings {{{

" Syntax and tabs
syntax enable " Enable syntax highlighting, duh
set number    " Looks better
set backspace=indent,eol,start
set tabstop=4
set noexpandtab
set copyindent
set preserveindent
set softtabstop=0
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
colo gotham

" }}}

" NERD things {{{

" Toggle NERDTree
"map <C-n> :NERDTreeToggle<CR>

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

" Completion {{{

filetype plugin on
let b:vcm_tab_complete = 'omni'
set omnifunc=syntaxcomplete#Complete
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
autocmd CompleteDone * pclose

let g:clang_library_path='/usr/lib'

" }}}

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

" Functions {{{
:command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g
" }}}

" Tmux integration {{{
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <BS> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
nnoremap <silent> <C-\> :TmuxNavigatePrevious<cr>
" }}}

" Lightline {{{

let g:airline_theme='gotham'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 2
let g:airline#extensions#branch#enabled = 1
let g:airline_skip_empty_sections = 1

" }}}
