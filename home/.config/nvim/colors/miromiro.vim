" miromiro colours
" Author:  jasonwryan
" URL:     http://jasonwryan.com

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name="miromiro"
" Normal colors  --- 
hi Normal          ctermfg=15
hi Ignore          ctermfg=8
hi Comment         ctermfg=7
hi LineNr          ctermfg=8
hi Float           ctermfg=3
hi Include         ctermfg=5
hi Define          ctermfg=2
hi Macro           ctermfg=13
hi PreProc         ctermfg=10
hi PreCondit       ctermfg=13
hi NonText         ctermfg=16
hi Directory       ctermfg=6
hi SpecialKey      ctermfg=11
hi Type            ctermfg=6
hi String          ctermfg=2
hi Constant        ctermfg=13
hi Special         ctermfg=10
hi SpecialChar     ctermfg=9
hi Number          ctermfg=14
hi Identifier      ctermfg=13
hi Conditional     ctermfg=14
hi Repeat          ctermfg=9
hi Statement       ctermfg=4
hi Label           ctermfg=13
hi Operator        ctermfg=3
hi Keyword         ctermfg=9   
hi StorageClass    ctermfg=11  
hi Structure       ctermfg=5
hi Typedef         ctermfg=6
hi Function        ctermfg=11
hi Exception       ctermfg=1
hi Underlined      ctermfg=4
hi Title           ctermfg=3   
hi Tag             ctermfg=11
hi Delimiter       ctermfg=12  
hi SpecialComment  ctermfg=9
hi Boolean         ctermfg=3
hi Todo            ctermfg=9
hi MoreMsg         ctermfg=13
hi ModeMsg         ctermfg=13
hi Debug           ctermfg=1
hi MatchParen      ctermfg=8    ctermbg=7
hi ErrorMsg        ctermfg=1    ctermbg=11
hi WildMenu        ctermfg=5    ctermbg=15
hi Folded          cterm=reverse ctermfg=6    ctermbg=0
hi Search          ctermfg=1    ctermbg=15
hi IncSearch       ctermfg=1    ctermbg=15
hi WarningMsg      ctermfg=9    ctermbg=15
hi Question        ctermfg=10   ctermbg=15
hi Pmenu           ctermfg=2    ctermbg=15
hi PmenuSel        ctermfg=1    ctermbg=15
hi Visual          ctermfg=8    ctermbg=15
hi CursorLine      cterm=NONE   ctermbg=233
hi CursorLineNr    ctermfg=11   ctermbg=233
hi StatusLine      ctermfg=0    ctermbg=7
hi StatusLineNC    ctermfg=8    ctermbg=0

" Diff lines ---
hi DiffLine        ctermbg=4
hi DiffText        ctermfg=16
hi DiffAdd         ctermfg=7    ctermbg=5
hi DiffChange      ctermfg=0    ctermbg=4
hi DiffDelete      ctermfg=0

" Specific for Vim script  --- 
hi vimCommentTitle ctermfg=10
hi vimFold         ctermfg=0    ctermbg=15

" Specific for help files  --- 
hi helpHyperTextJump ctermfg=11

" JS numbers only ---
hi javaScriptNumber ctermfg=11 

" Special for HTML ---
hi htmlTag        ctermfg=6
hi htmlEndTag     ctermfg=6
hi htmlTagName    ctermfg=11

" Specific for Perl  --- 
hi perlSharpBang  ctermfg=10  term=standout
hi perlStatement  ctermfg=13
hi perlStatementStorage ctermfg=1
hi perlVarPlain   ctermfg=3
hi perlVarPlain2  ctermfg=11

" Specific for Ruby  --- 
hi rubySharpBang  ctermfg=10  term=standout

" Spell checking  --- 
if version >= 700
  hi clear SpellBad
  hi clear SpellCap
  hi clear SpellRare
  hi clear SpellLocal
  hi SpellBad    ctermfg=9
  hi SpellCap    ctermfg=3    cterm=underline
  hi SpellRare   ctermfg=13   cterm=underline
  hi SpellLocal  cterm=None
endif
" vim: foldmethod=marker foldmarker={{{,}}}:
