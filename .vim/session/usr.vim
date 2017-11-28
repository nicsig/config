let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/.vim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +1 ~/Dropbox/notes
badd +40 /usr/share/vim/vim80/syntax/syntax.vim
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
586,696fold
698,792fold
794,913fold
915,1019fold
1021,1076fold
1078,1246fold
1248,1655fold
1657,1841fold
1843,1887fold
1889,1963fold
1965,2027fold
2031,2046fold
2048,2175fold
2177,2242fold
2244,2268fold
2270,2405fold
2407,2538fold
2540,2671fold
2673,2700fold
2702,2743fold
2747,2861fold
2865,3124fold
3126,4300fold
4302,4353fold
4355,4362fold
4366,4376fold
4378,4651fold
4653,5002fold
5004,5036fold
5040,5143fold
5145,5173fold
5175,5300fold
5302,5338fold
5340,5384fold
5386,5463fold
5465,5519fold
5521,5618fold
5620,5654fold
5656,5724fold
5726,5751fold
5752,5752fold
5004
normal! zo
let s:l = 5013 - ((712 * winheight(0) + 0) / 1)
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
let s:l = 464 - ((3 * winheight(0) + 14) / 28)
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
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
