"
" Terminal setup.
"
set background=dark
if version > 580
    highlight clear
    if exists("g:syntax_on")
        syntax reset
    endif
endif
let g:colors_name="shblah"

"
" Highlighting definitions.
"

    "
    " Actual colours and styles.
    "
    highlight Comment      term=NONE cterm=bold ctermfg=0    ctermbg=NONE
    highlight Constant     term=NONE cterm=bold ctermfg=4    ctermbg=NONE
    highlight Cursor       term=NONE cterm=bold ctermfg=3    ctermbg=NONE
    highlight CursorLine   term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE
    highlight DiffAdd      term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE
    highlight DiffChange   term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE
    highlight DiffDelete   term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE
    highlight Folded       term=NONE cterm=bold ctermfg=0    ctermbg=NONE
    highlight Function     term=NONE cterm=bold ctermfg=4    ctermbg=NONE
    highlight Identifier   term=NONE cterm=bold ctermfg=1    ctermbg=NONE
    highlight IncSearch    term=NONE cterm=NONE ctermfg=0    ctermbg=NONE
    highlight NonText      term=NONE cterm=bold ctermfg=0    ctermbg=NONE
    highlight Normal       term=NONE cterm=NONE ctermfg=7    ctermbg=NONE
    highlight Pmenu        term=NONE cterm=NONE ctermfg=0    ctermbg=NONE
    highlight PreProc      term=NONE cterm=bold ctermfg=5    ctermbg=NONE
    highlight Search       term=NONE cterm=bold ctermfg=0    ctermbg=NONE
    highlight Special      term=NONE cterm=bold ctermfg=2    ctermbg=NONE
    highlight SpecialKey   term=NONE cterm=NONE ctermfg=2    ctermbg=NONE
    highlight Statement    term=NONE cterm=bold ctermfg=2    ctermbg=NONE
    highlight StatusLine   term=NONE cterm=NONE ctermfg=7    ctermbg=NONE
    highlight StatusLineNC term=NONE cterm=NONE ctermfg=6    ctermbg=NONE
    highlight String       term=NONE cterm=NONE ctermfg=1    ctermbg=NONE
    highlight Todo         term=NONE cterm=NONE ctermfg=0    ctermbg=NONE
    highlight Type         term=NONE cterm=NONE ctermfg=2    ctermbg=NONE
    highlight VertSplit    term=NONE cterm=bold ctermfg=0    ctermbg=NONE
    highlight Visual       term=NONE cterm=bold ctermfg=4    ctermbg=NONE

    "
    " General highlighting group links.
    "
    highlight! link Title           Normal
    highlight! link LineNr          NonText
    highlight! link TabLine         StatusLineNC
    highlight! link TabLineFill     StatusLineNC
    highlight! link TabLineSel      StatusLine
    highlight! link VimHiGroup      VimGroup

" Test the actual colorscheme
syn match Comment      "__Comment.*"
syn match Constant     "__Constant.*"
syn match Cursor       "__Cursor.*"
syn match CursorLine   "__CursorLine.*"
syn match DiffAdd      "__DiffAdd.*"
syn match DiffChange   "__DiffChange.*"
syn match DiffDelete   "__DiffDelete.*"
syn match Folded       "__Folded.*"
syn match Function     "__Function.*"
syn match Identifier   "__Identifier.*"
syn match IncSearch    "__IncSearch.*"
syn match NonText      "__NonText.*"
syn match Normal       "__Normal.*"
syn match Pmenu        "__Pmenu.*"
syn match PreProc      "__PreProc.*"
syn match Search       "__Search.*"
syn match Special      "__Special.*"
syn match SpecialKey   "__SpecialKey.*"
syn match Statement    "__Statement.*"
syn match StatusLine   "__StatusLine.*"
syn match StatusLineNC "__StatusLineNC.*"
syn match String       "__String.*"
syn match Todo         "__Todo.*"
syn match Type         "__Type.*"
syn match VertSplit    "__VertSplit.*"
syn match Visual       "__Visual.*"
