let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +1 ~/wiki/vim/arglist.md
badd +1 ~/wiki/vim/command.md
badd +1 ~/.vim/plugged/vim-markdown/syntax/markdown.vim
badd +1 ~/.vim/plugged/vim-debug/autoload/debug/timer.vim
badd +1 ~/wiki/python/python.md
badd +1 ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim
badd +1 /usr/local/share/vim/vim80/doc/usr_44.txt
badd +1 ~/.vim/plugged/vim-debug/syntax/timer_info.vim
badd +0 ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim
argglobal
%argdel
edit ~/wiki/vim/arglist.md
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
let s:l = 426 - ((318 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
426
normal! 0
lcd ~/wiki/vim
tabedit ~/wiki/vim/command.md
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
let s:l = 3 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
3
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-cmdline/autoload/cmdline.vim") | buffer ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim | else | edit ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim | endif
if &buftype ==# 'terminal'
  silent file ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim
endif
let s:l = 85 - ((13 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
85
normal! 0
lcd ~/.vim/plugged/vim-cmdline
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabedit ~/.vim/plugged/vim-markdown/syntax/markdown.vim
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
let s:l = 189 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
189
normal! 0
lcd ~/.vim/plugged/vim-markdown
wincmd w
argglobal
if bufexists("/usr/local/share/vim/vim80/doc/usr_44.txt") | buffer /usr/local/share/vim/vim80/doc/usr_44.txt | else | edit /usr/local/share/vim/vim80/doc/usr_44.txt | endif
if &buftype ==# 'terminal'
  silent file /usr/local/share/vim/vim80/doc/usr_44.txt
endif
let s:l = 1 - ((0 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabedit ~/.vim/plugged/vim-debug/autoload/debug/timer.vim
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
argglobal
let s:l = 22 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
22
normal! 05|
lcd ~/.vim/plugged/vim-debug
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-debug/syntax/timer_info.vim") | buffer ~/.vim/plugged/vim-debug/syntax/timer_info.vim | else | edit ~/.vim/plugged/vim-debug/syntax/timer_info.vim | endif
if &buftype ==# 'terminal'
  silent file ~/.vim/plugged/vim-debug/syntax/timer_info.vim
endif
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim/plugged/vim-debug
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-debug/ftplugin/timer_info.vim") | buffer ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim | else | edit ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim | endif
if &buftype ==# 'terminal'
  silent file ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim
endif
let s:l = 1 - ((0 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim/plugged/vim-debug
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
tabedit ~/wiki/python/python.md
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
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 29 + 16) / 33)
argglobal
let s:l = 161 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
161
normal! 0
lcd ~/wiki/python
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-debug/ftplugin/timer_info.vim") | buffer ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim | else | edit ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim | endif
if &buftype ==# 'terminal'
  silent file ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim
endif
let s:l = 1 - ((0 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim/plugged/vim-debug
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 29 + 16) / 33)
tabnext 5
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
