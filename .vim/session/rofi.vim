let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +34 ~/wiki/rofi.md
badd +14 ~/.config/rofi/scripts/sh.sh
badd +1 ~/.config/rofi/README.md
badd +1 ~/.config/rofi/config.rasi
badd +1 ~/.config/rofi/scripts/bangs
badd +1 ~/.config/rofi/scripts/locate
badd +1 ~/.config/rofi/scripts/bookmarks
badd +1 ~/.config/rofi/scripts/README.md
argglobal
%argdel
edit ~/wiki/rofi.md
set splitbelow splitright
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
2wincmd k
wincmd w
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
arglocal
%argdel
let s:l = 34 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
34
normal! 0
lcd ~/wiki
wincmd w
arglocal
%argdel
if bufexists("~/.config/rofi/README.md") | buffer ~/.config/rofi/README.md | else | edit ~/.config/rofi/README.md | endif
if &buftype ==# 'terminal'
  silent file ~/.config/rofi/README.md
endif
let s:l = 154 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
154
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/.config/rofi/config.rasi") | buffer ~/.config/rofi/config.rasi | else | edit ~/.config/rofi/config.rasi | endif
if &buftype ==# 'terminal'
  silent file ~/.config/rofi/config.rasi
endif
let s:l = 95 - ((5 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
95
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
tabedit ~/.config/rofi/scripts/sh.sh
set splitbelow splitright
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
4wincmd k
wincmd w
wincmd w
wincmd w
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
exe '4resize ' . ((&lines * 0 + 16) / 33)
exe '5resize ' . ((&lines * 26 + 16) / 33)
arglocal
%argdel
let s:l = 14 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
14
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/.config/rofi/scripts/bangs") | buffer ~/.config/rofi/scripts/bangs | else | edit ~/.config/rofi/scripts/bangs | endif
if &buftype ==# 'terminal'
  silent file ~/.config/rofi/scripts/bangs
endif
let s:l = 43 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
43
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/.config/rofi/scripts/locate") | buffer ~/.config/rofi/scripts/locate | else | edit ~/.config/rofi/scripts/locate | endif
if &buftype ==# 'terminal'
  silent file ~/.config/rofi/scripts/locate
endif
let s:l = 8 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
8
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/.config/rofi/scripts/bookmarks") | buffer ~/.config/rofi/scripts/bookmarks | else | edit ~/.config/rofi/scripts/bookmarks | endif
if &buftype ==# 'terminal'
  silent file ~/.config/rofi/scripts/bookmarks
endif
let s:l = 14 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
14
normal! 0105|
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/.config/rofi/scripts/README.md") | buffer ~/.config/rofi/scripts/README.md | else | edit ~/.config/rofi/scripts/README.md | endif
if &buftype ==# 'terminal'
  silent file ~/.config/rofi/scripts/README.md
endif
let s:l = 2 - ((1 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
normal! 0
lcd ~/.vim
wincmd w
5wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
exe '4resize ' . ((&lines * 0 + 16) / 33)
exe '5resize ' . ((&lines * 26 + 16) / 33)
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
