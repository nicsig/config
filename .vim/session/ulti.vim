let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +16 ~/.vim/UltiSnips/sh.snippets
badd +7 /tmp/sh.sh
badd +792 ~/.vim/UltiSnips/README.md
badd +1 ~/.vim/UltiSnips/markdown.snippets
badd +40 ~/.vim/UltiSnips/help.snippets
badd +1 ~/.vim/UltiSnips/vim.snippets
badd +116 ~/Desktop/md.md
badd +20 ~/.vim/pythonx/snippet_helpers.py
argglobal
silent! argdel *
set stal=2
edit ~/.vim/UltiSnips/vim.snippets
set splitbelow splitright
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
2wincmd k
wincmd w
wincmd w
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
arglocal
silent! argdel *
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
429
normal! zo
let s:l = 431 - ((162 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
431
normal! 0
wincmd w
arglocal
silent! argdel *
if bufexists('~/.vim/UltiSnips/help.snippets') | buffer ~/.vim/UltiSnips/help.snippets | else | edit ~/.vim/UltiSnips/help.snippets | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
29
normal! zo
31
normal! zo
let s:l = 37 - ((3 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
37
normal! 044|
wincmd w
arglocal
silent! argdel *
if bufexists('~/.vim/UltiSnips/markdown.snippets') | buffer ~/.vim/UltiSnips/markdown.snippets | else | edit ~/.vim/UltiSnips/markdown.snippets | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
51
normal! zo
let s:l = 51 - ((50 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
51
normal! 0
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
tabedit ~/Desktop/md.md
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
arglocal
silent! argdel *
setlocal fdm=expr
setlocal fde=fold#md#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 12 - ((11 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
12
normal! 05|
wincmd w
arglocal
silent! argdel *
if bufexists('~/.vim/pythonx/snippet_helpers.py') | buffer ~/.vim/pythonx/snippet_helpers.py | else | edit ~/.vim/pythonx/snippet_helpers.py | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 1 - ((0 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabedit ~/.vim/UltiSnips/README.md
set splitbelow splitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
arglocal
silent! argdel *
setlocal fdm=expr
setlocal fde=fold#md#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
1149
normal! zo
let s:l = 1473 - ((26 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1473
normal! 0
tabedit /tmp/sh.sh
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
arglocal
silent! argdel *
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 7 - ((6 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
7
normal! 09|
wincmd w
arglocal
silent! argdel *
if bufexists('~/.vim/UltiSnips/sh.snippets') | buffer ~/.vim/UltiSnips/sh.snippets | else | edit ~/.vim/UltiSnips/sh.snippets | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 9 - ((8 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
9
normal! 0
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext 4
set stal=1
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
let g:my_session = v:this_session
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
