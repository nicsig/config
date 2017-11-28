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
badd +1 ~/Dropbox/conf/bin/awk/histogram.awk
badd +5013 ~/Dropbox/notes
badd +1306 ~/Dropbox/conf/cheat/vim
badd +10 ~/Dropbox/conf/vim/after/syntax/sh.vim
badd +1 ~/Dropbox/conf/vim/after/syntax/awk.vim
badd +1 ~/.bashrc
argglobal
silent! argdel *
set stal=2
edit ~/Dropbox/conf/cheat/vim
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd t
set winheight=1 winwidth=1
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
argglobal
setlocal fdm=expr
setlocal fde=<SNR>77_stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
14202
normal! zo
let s:l = 14160 - ((165 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
14160
normal! 0
wincmd w
argglobal
edit ~/Dropbox/notes
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
5521
normal! zo
let s:l = 5569 - ((13 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
5569
normal! 0
wincmd w
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
tabedit ~/Dropbox/conf/vim/after/syntax/sh.vim
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd t
set winheight=1 winwidth=1
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
1
normal! zo
let s:l = 8 - ((3 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
8
normal! 0
wincmd w
argglobal
edit ~/.bashrc
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
39
normal! zo
let s:l = 52 - ((18 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
52
normal! 0
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabedit ~/Dropbox/conf/bin/awk/histogram.awk
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd t
set winheight=1 winwidth=1
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
186
normal! zo
let s:l = 204 - ((203 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
204
normal! 04|
wincmd w
argglobal
edit ~/Dropbox/conf/vim/after/syntax/awk.vim
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
1
normal! zo
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 02|
wincmd w
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
tabnext 3
set stal=1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOcFIsW
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
let g:my_session = v:this_session
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
