let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +0 ~/.vim/plugged/vim-hydra/plugin/hydra.vim
badd +0 ~/Desktop/result
badd +1 /run/user/1000/hydra/head18.vim
badd +0 ~/Desktop/final_analysis.hydra
argglobal
%argdel
edit ~/.vim/plugged/vim-hydra/plugin/hydra.vim
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
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
arglocal
%argdel
let s:l = 49 - ((13 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
49
normal! 0
lcd ~/.vim/plugged/vim-hydra
wincmd w
arglocal
%argdel
if bufexists("~/Desktop/result") | buffer ~/Desktop/result | else | edit ~/Desktop/result | endif
if &buftype ==# 'terminal'
  silent file ~/Desktop/result
endif
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim/plugged/vim-hydra
wincmd w
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
tabedit /run/user/1000/hydra/head18.vim
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 86 + 59) / 119)
exe 'vert 2resize ' . ((&columns * 32 + 59) / 119)
arglocal
%argdel
let s:l = 1 - ((0 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim/plugged/vim-hydra
wincmd w
arglocal
%argdel
if bufexists("~/Desktop/final_analysis.hydra") | buffer ~/Desktop/final_analysis.hydra | else | edit ~/Desktop/final_analysis.hydra | endif
if &buftype ==# 'terminal'
  silent file ~/Desktop/final_analysis.hydra
endif
let s:l = 1 - ((0 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim/plugged/vim-hydra
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 86 + 59) / 119)
exe 'vert 2resize ' . ((&columns * 32 + 59) / 119)
tabnext 2
if exists('s:wipebuf') && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 winminheight=0 winminwidth=0 shortmess=filnxtToOacFIsW
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
