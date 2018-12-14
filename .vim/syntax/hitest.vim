" Where does the code in this script come from?{{{
"
"     $VIMRUNTIME/syntax/hitest.vim
"}}}
" What does it do?{{{
"
" Print your current highlight settings.
"}}}
" How to use it?{{{
"
"    :so%
"}}}
" Why don't you use the original script?{{{
"
" It contains a few errors:
"
"     • `:normal` instead of `normal!`
"      (which causes an issue because of a custom mapping installed by `vim-search`)
"
"     • doesn't temporarily reset 'ww'
"     (which causes an issue because we do `set ww=h,l` in our vimrc)
"}}}

let s:report      = &report
let s:wrapscan    = &wrapscan
let s:ww          = &ww
let s:register_a  = @a
let s:register_se = @/

set report=99999 shortmess=aoOstTW wrapscan ww=b,s

let @a = execute('hi')

" Open a new window if the current one isn't empty
if line('$') != 1 || getline(1) != ''
    new
endif

sil edit Highlight\ test

setl autoindent bh=wipe bt=nofile fo=t noet noswf sw=16 ts=16
let &tw = &columns

" insert highlight settings
%d_
put a

" remove the colored xxx items
g/xxx /s///e

" remove color settings (not needed here)
v/links to/ s/\s.*$//e

" move linked groups to the end of file
g/links to/ move $

" move linked group names to the matching preferred groups
%s/^\(\w\+\)\s*\(links to\)\s*\(\w\+\)$/\3\t\2 \1/e
g/links to/ normal! mz3ElD0#$p'zdd

" delete empty lines
g/^ *$/ delete

" precede syntax command
%s/^[^ ]*/syn keyword &\t&/

" execute syntax commands
syntax clear
%y a
@a

" remove syntax commands again
%s/^syn keyword //

" pretty formatting
g/^/exe "normal! Wi\<CR>\t\eAA\ex"
g/^\S/j

" find out first syntax highlighting
let s:various = &highlight . ',:Normal,:Cursor,:,'
let s:i = 1
while s:various =~ ':'.substitute(getline(s:i), '\s.*$', ',', '')
    let s:i += 1
    if s:i > line('$') | break | endif
endwhile

" insert headlines
call append(0, 'Highlighting groups for various occasions')
call append(1, '-----------------------------------------')

if s:i < line('$')-1
    let s:header = 'Syntax highlighting groups'
    call append(s:i+1, ['', s:header, substitute(s:header, '.', '-', 'g')])
endif

normal! 0

exe '1'

" restore global options and registers
let &report      = s:report
let &wrapscan    = s:wrapscan
let &ww          = s:ww
let @a           = s:register_a

" restore last search pattern
call histdel('search', -1)
let @/ = s:register_se

unlet s:report s:register_a s:register_se s:wrapscan s:ww

