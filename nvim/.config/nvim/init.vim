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

Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
Plug 'ajh17/vimcompletesme'
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'w0rp/ale'
Plug 'airblade/vim-gitgutter'
Plug 'godlygeek/tabular'
Plug 'rking/ag.vim'
Plug 'simeji/winresizer'
Plug 'tudurom/bleh.vim'
Plug 'whatyouhide/vim-gotham'
Plug 'lilydjwg/colorizer'
Plug 'isa/vim-matchit'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Goyo' }
Plug 'chaoren/vim-wordmotion'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-abolish'
Plug 'matze/vim-move'
Plug 'srcery-colors/srcery-vim'
Plug 'morhetz/gruvbox'
Plug 'editorconfig/editorconfig-vim'

call plug#end()
filetype plugin indent on
" }}}

" Essential settings {{{

" Syntax and tabs
syntax enable
set number
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

" Use system's clipboard (X's CLIPBOARD)
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

" Leader-d to hide find results
nnoremap <silent> <Leader>d :noh<CR>
" Esc in terminal
if has('nvim')
	tnoremap <Esc> <C-\><C-n>
endif
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
nmap <Leader>w :w<CR>

nnoremap <silent> B :Buffers<CR>

" }}}

" Whitespace stripping {{{

highlight ExtraWhitespace ctermbg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red
match ExtraWhitespace /\s\+$/
autocmd BufWritePre * %s/\s\+$//e

" }}}

" Colors {{{

set termguicolors
set background=light
" colo bleh
colo gruvbox

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

inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" }}}

" Usability {{{

" close if final buffer is netrw or the quickfix
augroup finalcountdown
	au!
	autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" || &buftype == 'quickfix' |q|endif
augroup END

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
let g:ale_cpp_clangtidy_options = '-Wall -std=c++11 -x c++'
let g:ale_cpp_clangcheck_options = '-- -Wall -std=c++11 -x c++'
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

" coc.nvim {{{

set cmdheight=2
set updatetime=300
set shortmess+=c

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" }}}

" Functions {{{
:command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g
" }}}

aug AutoCompileMD
	au!
	au BufWritePost ~/usr/work/*.md silent !pandoc -o %:p:r.pdf % &
aug END
