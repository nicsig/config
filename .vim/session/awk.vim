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
tabnew
tabrewind
edit ~/wiki/awk/sed.md
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
let s:l = 936 - ((129 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
936
normal! 0
lcd ~/wiki/awk
tabnext
edit ~/.vim/plugged/vim-cheat/ftplugin/cheat.vim
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
let s:l = 1 - ((0 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim/plugged/vim-cheat
tabnext
edit ~/Desktop/ask.md
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
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe 'vert 1resize ' . ((&columns * 89 + 59) / 119)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe 'vert 2resize ' . ((&columns * 89 + 59) / 119)
exe '3resize ' . ((&lines * 0 + 16) / 33)
exe 'vert 3resize ' . ((&columns * 89 + 59) / 119)
exe '4resize ' . ((&lines * 27 + 16) / 33)
exe 'vert 4resize ' . ((&columns * 89 + 59) / 119)
argglobal
let s:l = 484 - ((31 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
484
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/vim/config.md") | buffer ~/wiki/vim/config.md | else | edit ~/wiki/vim/config.md | endif
let s:l = 1542 - ((138 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1542
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/complete.md") | buffer ~/wiki/vim/complete.md | else | edit ~/wiki/vim/complete.md | endif
let s:l = 163 - ((10 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
163
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-lg-lib/autoload/lg/window.vim") | buffer ~/.vim/plugged/vim-lg-lib/autoload/lg/window.vim | else | edit ~/.vim/plugged/vim-lg-lib/autoload/lg/window.vim | endif
let s:l = 318 - ((13 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
318
normal! 0
lcd ~/.vim/plugged/vim-lg-lib
wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe 'vert 1resize ' . ((&columns * 89 + 59) / 119)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe 'vert 2resize ' . ((&columns * 89 + 59) / 119)
exe '3resize ' . ((&lines * 0 + 16) / 33)
exe 'vert 3resize ' . ((&columns * 89 + 59) / 119)
exe '4resize ' . ((&lines * 27 + 16) / 33)
exe 'vert 4resize ' . ((&columns * 89 + 59) / 119)
tabnext
edit ~/Desktop/answer.md
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
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe 'vert 1resize ' . ((&columns * 89 + 59) / 119)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe 'vert 2resize ' . ((&columns * 89 + 59) / 119)
exe '3resize ' . ((&lines * 28 + 16) / 33)
exe 'vert 3resize ' . ((&columns * 89 + 59) / 119)
argglobal
let s:l = 183 - ((3 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
183
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/Desktop/vim.vim") | buffer ~/Desktop/vim.vim | else | edit ~/Desktop/vim.vim | endif
let s:l = 31 - ((24 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
31
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-session/plugin/session.vim") | buffer ~/.vim/plugged/vim-session/plugin/session.vim | else | edit ~/.vim/plugged/vim-session/plugin/session.vim | endif
let s:l = 313 - ((13 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
313
normal! 0
lcd ~/.vim/plugged/vim-session
wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe 'vert 1resize ' . ((&columns * 89 + 59) / 119)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe 'vert 2resize ' . ((&columns * 89 + 59) / 119)
exe '3resize ' . ((&lines * 28 + 16) / 33)
exe 'vert 3resize ' . ((&columns * 89 + 59) / 119)
tabnext
edit ~/wiki/admin/compiling.md
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
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe 'vert 1resize ' . ((&columns * 89 + 59) / 119)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe 'vert 2resize ' . ((&columns * 89 + 59) / 119)
exe '3resize ' . ((&lines * 28 + 16) / 33)
exe 'vert 3resize ' . ((&columns * 89 + 59) / 119)
argglobal
let s:l = 598 - ((3 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
598
normal! 0
lcd ~/wiki/admin
wincmd w
argglobal
if bufexists("~/wiki/vim/install.md") | buffer ~/wiki/vim/install.md | else | edit ~/wiki/vim/install.md | endif
let s:l = 255 - ((21 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
255
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/bin/upp") | buffer ~/bin/upp | else | edit ~/bin/upp | endif
let s:l = 153 - ((74 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
153
normal! 02|
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe 'vert 1resize ' . ((&columns * 89 + 59) / 119)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe 'vert 2resize ' . ((&columns * 89 + 59) / 119)
exe '3resize ' . ((&lines * 28 + 16) / 33)
exe 'vert 3resize ' . ((&columns * 89 + 59) / 119)
tabnext
edit ~/.vim/vimrc
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
let s:l = 4830 - ((8 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4830
normal! 026|
lcd ~/.vim
wincmd w
argglobal
if bufexists("/tmp/md.md") | buffer /tmp/md.md | else | edit /tmp/md.md | endif
let s:l = 1 - ((0 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 29 + 16) / 33)
tabnext 6
set stal=1
badd +0 ~/wiki/awk/sed.md
badd +1 ~/.vim/vimrc
badd +0 ~/.vim/plugged/vim-cheat/ftplugin/cheat.vim
badd +1 ~/Desktop/ask.md
badd +194 ~/Desktop/answer.md
badd +1 ~/wiki/admin/compiling.md
badd +0 ~/wiki/vim/config.md
badd +0 ~/wiki/vim/complete.md
badd +0 ~/.vim/plugged/vim-lg-lib/autoload/lg/window.vim
badd +0 ~/Desktop/vim.vim
badd +0 ~/.vim/plugged/vim-session/plugin/session.vim
badd +0 ~/wiki/vim/install.md
badd +0 ~/bin/upp
badd +0 /tmp/md.md
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOSacFIsW
set winminheight=0 winminwidth=0
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
