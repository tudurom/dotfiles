" ╻┏┓╻╻╺┳╸ ╻ ╻╻┏┳┓
" ┃┃┗┫┃ ┃  ┃┏┛┃┃┃┃
" ╹╹ ╹╹ ╹ ╹┗┛ ╹╹ ╹
" init.vim without description
" don't try it with vanilla vim

filetype off

set encoding=utf-8
scriptencoding utf-8

let g:uname = substitute(system("uname"), '\n\+$', '', '')
set rtp+=/usr/share/vim/vimfiles

" Plugins {{{

call plug#begin('~/.config/nvim/bundle')

Plug 'ntpeters/vim-better-whitespace'
Plug 'ajh17/vimcompletesme'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go'
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'rip-rip/clang_complete'
Plug 'w0rp/ale'
Plug 'airblade/vim-gitgutter'
Plug 'godlygeek/tabular'
Plug 'rking/ag.vim'
Plug 'simeji/winresizer'
Plug 'whatyouhide/vim-gotham'
Plug 'tudurom/bleh.vim'
Plug 'lilydjwg/colorizer'
Plug 'isa/vim-matchit'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Goyo' }
Plug 'chaoren/vim-wordmotion'

call plug#end()
filetype plugin indent on
" }}}

" Essential settings {{{

" Syntax and tabs
syntax enable " Enable syntax highlighting, duh
set number    " Looks better
set backspace=indent,eol,start
set tabstop=4
set noexpandtab
set softtabstop=-1
set shiftwidth=4
set smartindent

" Make things snappy
set updatetime=250

" Fold markers
set fdm=marker

" Respect case in searches only if search query contains upper-case chars
set ignorecase
set smartcase
set infercase

" Other search tricks
set hlsearch
set incsearch
set inccommand=split

" Make it natural
set splitright
set splitbelow

" Make buffers more emacs-y
set hidden
set autochdir

" Kill lag
set lazyredraw

set clipboard^=unnamedplus

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

" Wildmenu. Show all suggestions
set wildmode=longest,list,full
set wildmenu
set wildignorecase

" Search for files recursively
set path+=**

" netrw

" open in split window
let g:netrw_browse_split=4
" on the right
let g:netrw_altv=1
" tree view
let g:netrw_liststyle=3
" ignore git ignored files
let g:netrw_list_hide=netrw_gitignore#Hide()
" ignore files that start with a dot
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" }}}

" Keybindings {{{

" C-d to hide find results
nnoremap <silent> <Leader>d :noh<CR>
" Esc in terminal
if has('nvim')
	tnoremap <Esc> <C-\><C-n>
endif
" Navigate long lines easily
map j gj
map k gk
" Just in case
cabbr W w
cabbr Q q
cabbr Wq wq

map <Space> <Leader>
nmap <Leader>- :split<CR>
nmap <Leader>\| :vsplit<CR>

map <Leader>h <C-w>h
map <Leader>j <C-w>j
map <Leader>k <C-w>k
map <Leader>l <C-w>l
map <Leader>= <C-w>=
map <Leader><Space> <C-w><C-w>
nmap <Leader>r :WinResizerStartResize<CR>
nmap <Leader>s :StripWhitespace<CR>
nmap <Leader>w :w<CR>

" }}}

" Colors {{{

set background=dark
colo bleh

" }}}

" Statusline {{{

set laststatus=2 " Make the bar permanent
set showmode
set ruler

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

	au BufRead,BufNewFile *.md setlocal textwidth=80 spell spelllang=en,ro
	au BufRead,BufNewFile *.html imap <C-Space> <C-X><C-O>
	autocmd vimresized * execute "normal \<C-W>="

augroup end

" }}}

" Completion {{{

filetype plugin on
let b:vcm_tab_complete = 'omni'
set omnifunc=syntaxcomplete#Complete
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
augroup completionhide
	au!
	autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
augroup end
let g:clang_library_path='/usr/lib'

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
if !exists('g:deoplete#omni#input_patterns')
	let g:deoplete#omni#input_patterns = {}
endif
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" }}}

" Usability {{{

" close if final buffer is netrw or the quickfix
augroup finalcountdown
	au!
	autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" || &buftype == 'quickfix' |q|endif
augroup END

" }}}

" vim-go {{{

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

" ag {{{
let g:ag_prg="ag -i --vimgrep"
let g:ag_highlight=1
nnoremap \ :Ag<SPACE>
" }}}

" ale {{{
let g:ale_completion_enabled = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '× '
let g:ale_sign_warning = '> '
" }}}

" Goyo {{{

let g:limelight_conceal_ctermfg = 8
function! s:goyo_enter()
	Limelight
	set noshowmode
	set noshowcmd
	set wrap
	set scrolloff=999
endfunction

function! s:goyo_leave()
	Limelight!
	set showmode
	set showcmd
	set nowrap
	set scrolloff=0
endfunction

augroup goyoactions
	au!
	autocmd! User GoyoEnter nested call <SID>goyo_enter()
	autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup end

" }}}

" Romanian Digraphs {{{
" Vim comes default with turkish ş and ţ

dig S, 536 " Ș
dig s, 537 " ș

dig T, 538 " Ț
dig t, 539 " ț

" }}}

" Functions {{{
:command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g
" }}}
