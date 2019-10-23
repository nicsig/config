let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
" badd +5569 ~/Dropbox/notes
" badd +40 /usr/share/vim/vim80/syntax/syntax.vim
argglobal
silent! argdel *
set stal=2
edit ~/Dropbox/notes
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
2,4fold
6,44fold
46,86fold
88,238fold
240,306fold
308,460fold
462,478fold
480,584fold
586,680fold
682,776fold
778,897fold
899,1003fold
1005,1060fold
1062,1230fold
1232,1639fold
1641,1825fold
1827,1871fold
1873,1947fold
1949,2011fold
2015,2031fold
2033,2158fold
2160,2225fold
2227,2251fold
2253,2384fold
2386,2517fold
2519,2650fold
2652,2679fold
2681,2722fold
2726,2840fold
2844,3103fold
3105,4279fold
4281,4332fold
4334,4341fold
4345,4355fold
4357,4630fold
4632,4981fold
4983,5015fold
5019,5122fold
5124,5152fold
5154,5279fold
5281,5317fold
5319,5363fold
5365,5442fold
5444,5498fold
5500,5597fold
5599,5633fold
5635,5703fold
5705,5730fold
5731,5731fold
4983
normal! zo
let s:l = 5013 - ((13 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
5013
normal! 0
wincmd w
argglobal
if bufexists('/usr/share/vim/vim80/doc/usr_05.txt') | buffer /usr/share/vim/vim80/doc/usr_05.txt | else | edit /usr/share/vim/vim80/doc/usr_05.txt | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
silent! normal! zE
let s:l = 464 - ((16 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
464
normal! 02|
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabedit /usr/share/vim/vim80/doc/usr_44.txt
set splitbelow splitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
silent! normal! zE
let s:l = 59 - ((14 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
59
normal! 055|
tabedit /usr/share/vim/vim80/syntax/syntax.vim
set splitbelow splitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 40 - ((21 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
40
normal! 02|
tabnext 1
set stal=1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOcFIsW
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
