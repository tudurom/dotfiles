let s:black = [ '#8e7b71', 8 ]
let s:white = [ '#3f3a3c', 7 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [ [s:white, s:black], [s:white, s:black] ]
let s:p.normal.right = [ [s:white, s:black], [s:white, s:black] ]
let s:p.inactive.right = [ [s:white, s:black], [s:white, s:black] ]
let s:p.inactive.left = [ [s:white, s:black], [s:white, s:black] ]
let s:p.insert.left = [ [s:white, s:black], [s:white, s:black] ]
let s:p.replace.left = [ [s:white, s:black], [s:white, s:black] ]
let s:p.visual.left = [ [s:white, s:black], [s:white, s:black] ]
let s:p.normal.middle = [ [s:black, s:white] ]
let s:p.inactive.middle = [ [s:white, s:black], [s:white, s:black] ]
let s:p.tabline.left = [ [s:white, s:black], [s:white, s:black] ]
let s:p.tabline.tabsel = [ [s:white, s:black], [s:white, s:black] ]
let s:p.tabline.middle = [ [s:white, s:black], [s:white, s:black] ]
let s:p.tabline.right = copy(s:p.normal.right)
let s:p.normal.error = [ [s:white, s:black], [s:white, s:black] ]
let s:p.normal.warning = [ [s:white, s:black], [s:white, s:black] ]

let g:lightline#colorscheme#woody#palette = lightline#colorscheme#flatten(s:p)
