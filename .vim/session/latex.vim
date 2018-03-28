let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +713 ~/Dropbox/wiki/latex/README/latex.md
badd +12 ~/Dropbox/wiki/latex/CODE/LaTeX_Beginner_Guide/2_Formatting_Words_Lines_and_Paragraphs/13_creating_a_macro_for_formatting_keywords.tex
argglobal
silent! argdel *
edit ~/Dropbox/wiki/latex/README/latex.md
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
argglobal
setlocal fdm=expr
setlocal fde=fold#md#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 713 - ((366 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
713
normal! 0
wincmd w
argglobal
if bufexists('~/Dropbox/wiki/latex/CODE/LaTeX_Beginner_Guide/2_Formatting_Words_Lines_and_Paragraphs/13_creating_a_macro_for_formatting_keywords.tex') | buffer ~/Dropbox/wiki/latex/CODE/LaTeX_Beginner_Guide/2_Formatting_Words_Lines_and_Paragraphs/13_creating_a_macro_for_formatting_keywords.tex | else | edit ~/Dropbox/wiki/latex/CODE/LaTeX_Beginner_Guide/2_Formatting_Words_Lines_and_Paragraphs/13_creating_a_macro_for_formatting_keywords.tex | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 12 - ((11 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
12
normal! 0
wincmd w
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
tabnext 1
if exists('s:wipebuf') && s:wipebuf != bufnr('%')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=1 shortmess=filnxtToOAacFIsW
set winminheight=1 winminwidth=1
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
let g:my_session = v:this_session
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
