let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +7 /tmp/sh.sh
badd +20 ~/.vim/pythonx/snippet_helpers.py
badd +28 ~/.vim/UltiSnips/sh.snippets
badd +4 ~/.vim/UltiSnips/README.md
badd +1 ~/.vim/UltiSnips/markdown.snippets
badd +40 ~/.vim/UltiSnips/help.snippets
badd +2 ~/.vim/UltiSnips/vim.snippets
badd +116 ~/Desktop/md.md
badd +384 ~/Dropbox/wiki/vim/exception.md
badd +42 ~/.vim/plugged/vim-source/autoload/source.vim
badd +0 ~/.vim/plugged/vim-source/diffpanel_3
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
let s:l = 2 - ((1 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
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
let s:l = 40 - ((3 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
40
normal! 045|
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
let s:l = 61 - ((3 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
61
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
let s:l = 116 - ((13 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
116
normal! 0
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
normal! 03|
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
let s:l = 28 - ((3 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
28
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
let s:l = 1 - ((0 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
tabedit ~/.vim/plugged/vim-source/undotree_2
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd w
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
exe 'vert 1resize ' . ((&columns * 30 + 59) / 119)
exe '2resize ' . ((&lines * 28 + 16) / 33)
exe 'vert 2resize ' . ((&columns * 30 + 59) / 119)
exe '3resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 3resize ' . ((&columns * 88 + 59) / 119)
exe '4resize ' . ((&lines * 26 + 16) / 33)
exe 'vert 4resize ' . ((&columns * 88 + 59) / 119)
exe '5resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 5resize ' . ((&columns * 88 + 59) / 119)
arglocal
silent! argdel *
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 3 - ((2 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
3
normal! 0
wincmd w
arglocal
silent! argdel *
if bufexists('~/.vim/plugged/vim-source/diffpanel_3') | buffer ~/.vim/plugged/vim-source/diffpanel_3 | else | edit ~/.vim/plugged/vim-source/diffpanel_3 | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 1 - ((0 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
arglocal
silent! argdel *
if bufexists('~/.vim/plugged/vim-sandwich/doc/operator-sandwich.txt') | buffer ~/.vim/plugged/vim-sandwich/doc/operator-sandwich.txt | else | edit ~/.vim/plugged/vim-sandwich/doc/operator-sandwich.txt | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal nofen
silent! normal! zE
let s:l = 73 - ((2 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
73
normal! 0
wincmd w
arglocal
silent! argdel *
if bufexists('~/.vim/plugged/vim-source/autoload/source.vim') | buffer ~/.vim/plugged/vim-source/autoload/source.vim | else | edit ~/.vim/plugged/vim-source/autoload/source.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 42 - ((15 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
42
let s:c = 103 - ((82 * winwidth(0) + 44) / 88)
if s:c > 0
  exe 'normal! ' . s:c . '|zs' . 103 . '|'
else
  normal! 0103|
endif
wincmd w
arglocal
silent! argdel *
if bufexists('~/Dropbox/wiki/vim/exception.md') | buffer ~/Dropbox/wiki/vim/exception.md | else | edit ~/Dropbox/wiki/vim/exception.md | endif
setlocal fdm=expr
setlocal fde=fold#md#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
202
normal! zo
313
normal! zo
512
normal! zo
553
normal! zo
823
normal! zo
1315
normal! zo
let s:l = 329 - ((3 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
329
normal! 05|
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 1resize ' . ((&columns * 30 + 59) / 119)
exe '2resize ' . ((&lines * 28 + 16) / 33)
exe 'vert 2resize ' . ((&columns * 30 + 59) / 119)
exe '3resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 3resize ' . ((&columns * 88 + 59) / 119)
exe '4resize ' . ((&lines * 26 + 16) / 33)
exe 'vert 4resize ' . ((&columns * 88 + 59) / 119)
exe '5resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 5resize ' . ((&columns * 88 + 59) / 119)
tabnext 5
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
