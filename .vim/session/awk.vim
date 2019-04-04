let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
argglobal
%argdel
set stal=2
tabnew
tabnew
tabnew
tabnew
tabrewind
edit ~/Desktop/countries
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/awk/awk.md") | buffer ~/wiki/awk/awk.md | else | edit ~/wiki/awk/awk.md | endif
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
4381
normal! zo
let s:l = 4381 - ((52 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4381
normal! 0
lcd ~/wiki/awk
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext
edit ~/wiki/awk/sed.md
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
1
normal! zo
let s:l = 12 - ((11 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
12
normal! 0
lcd ~/wiki/awk
tabnext
edit /usr/share/man/man1/man.1.gz
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 1resize ' . ((&columns * 59 + 59) / 119)
exe '2resize ' . ((&lines * 28 + 16) / 33)
exe 'vert 2resize ' . ((&columns * 59 + 59) / 119)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 465 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
465
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("/usr/share/man/man1/grep.1.gz") | buffer /usr/share/man/man1/grep.1.gz | else | edit /usr/share/man/man1/grep.1.gz | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 1088 - ((13 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1088
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 1resize ' . ((&columns * 59 + 59) / 119)
exe '2resize ' . ((&lines * 28 + 16) / 33)
exe 'vert 2resize ' . ((&columns * 59 + 59) / 119)
tabnext
edit ~/Desktop/mypgm.1
set splitbelow splitright
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
3wincmd k
wincmd w
wincmd w
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 1resize ' . ((&columns * 59 + 59) / 119)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 2resize ' . ((&columns * 59 + 59) / 119)
exe '3resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 3resize ' . ((&columns * 59 + 59) / 119)
exe '4resize ' . ((&lines * 24 + 16) / 33)
exe 'vert 4resize ' . ((&columns * 59 + 59) / 119)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 18 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
18
normal! 02|
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/man/glossary.md") | buffer ~/wiki/man/glossary.md | else | edit ~/wiki/man/glossary.md | endif
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
1
normal! zo
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/wiki/man
wincmd w
argglobal
if bufexists("~/wiki/man/man.md") | buffer ~/wiki/man/man.md | else | edit ~/wiki/man/man.md | endif
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
144
normal! zo
let s:l = 147 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
147
normal! 042|
lcd ~/wiki/man
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-snippets/UltiSnips/nroff.snippets") | buffer ~/.vim/plugged/vim-snippets/UltiSnips/nroff.snippets | else | edit ~/.vim/plugged/vim-snippets/UltiSnips/nroff.snippets | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 22 - ((13 * winheight(0) + 12) / 24)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
22
normal! 018|
lcd ~/.vim/plugged/vim-snippets
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 1resize ' . ((&columns * 59 + 59) / 119)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 2resize ' . ((&columns * 59 + 59) / 119)
exe '3resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 3resize ' . ((&columns * 59 + 59) / 119)
exe '4resize ' . ((&lines * 24 + 16) / 33)
exe 'vert 4resize ' . ((&columns * 59 + 59) / 119)
tabnext
edit ~/.vim/plugged/vim-search/autoload/search.vim
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
6
normal! zo
252
normal! zo
301
normal! zo
let s:l = 24 - ((23 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
24
normal! 0
lcd ~/.vim/plugged/vim-search
tabnext 5
set stal=1
badd +1 ~/Desktop/countries
badd +13 ~/wiki/awk/sed.md
badd +465 /usr/share/man/man1/man.1.gz
badd +18 ~/Desktop/mypgm.1
badd +4381 ~/wiki/awk/awk.md
badd +1088 /usr/share/man/man1/grep.1.gz
badd +56 ~/wiki/man/glossary.md
badd +147 ~/wiki/man/man.md
badd +9 ~/.vim/plugged/vim-snippets/UltiSnips/nroff.snippets
badd +24 ~/.vim/plugged/vim-search/autoload/search.vim
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOacFIsW
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
