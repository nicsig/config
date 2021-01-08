let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
argglobal
%argdel
tabnew
tabnew
tabnew
tabnew
tabrewind
edit ~/wiki/vim/arglist.md
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
balt ~/wiki/c/c.md
let s:l = 426 - ((318 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 426
normal! 0
lcd ~/wiki/vim
tabnext
edit ~/wiki/vim/command.md
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
keepjumps exe s:l
normal! zt
keepjumps 3
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-cmdline/autoload/cmdline.vim") | buffer ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim | else | edit ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim | endif
balt ~/wiki/vim/command.md
let s:l = 85 - ((13 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 85
normal! 0
lcd ~/.vim/plugged/vim-cmdline
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext
edit ~/.vim/plugged/vim-markdown/syntax/markdown.vim
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
keepjumps exe s:l
normal! zt
keepjumps 189
normal! 0
lcd ~/.vim/plugged/vim-markdown
wincmd w
argglobal
if bufexists("/usr/local/share/vim/vim80/doc/usr_44.txt") | buffer /usr/local/share/vim/vim80/doc/usr_44.txt | else | edit /usr/local/share/vim/vim80/doc/usr_44.txt | endif
balt ~/.vim/plugged/vim-markdown/syntax/markdown.vim
let s:l = 1 - ((0 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext
edit ~/.vim/plugged/vim-debug/autoload/debug/timer.vim
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
keepjumps exe s:l
normal! zt
keepjumps 22
normal! 05|
lcd ~/.vim/plugged/vim-debug
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-debug/syntax/timer_info.vim") | buffer ~/.vim/plugged/vim-debug/syntax/timer_info.vim | else | edit ~/.vim/plugged/vim-debug/syntax/timer_info.vim | endif
balt ~/.vim/plugged/vim-debug/autoload/debug/timer.vim
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
lcd ~/.vim/plugged/vim-debug
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-debug/ftplugin/timer_info.vim") | buffer ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim | else | edit ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim | endif
balt ~/.vim/plugged/vim-debug/autoload/debug/timer.vim
let s:l = 1 - ((0 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
lcd ~/.vim/plugged/vim-debug
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
tabnext
edit ~/wiki/python/python.md
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
keepjumps exe s:l
normal! zt
keepjumps 161
normal! 0
lcd ~/wiki/python
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-debug/ftplugin/timer_info.vim") | buffer ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim | else | edit ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim | endif
balt ~/wiki/python/python.md
let s:l = 1 - ((0 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
lcd ~/.vim/plugged/vim-debug
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 29 + 16) / 33)
tabnext 5
badd +1 ~/wiki/vim/command.md
badd +1 ~/.vim/plugged/vim-markdown/syntax/markdown.vim
badd +1 ~/.vim/plugged/vim-debug/autoload/debug/timer.vim
badd +1 ~/wiki/python/python.md
badd +1 ~/wiki/vim/arglist.md
badd +1 ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim
badd +1 /usr/local/share/vim/vim80/doc/usr_44.txt
badd +1 ~/.vim/plugged/vim-debug/syntax/timer_info.vim
badd +1 ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOSacFIsW
set winminheight=0 winminwidth=0
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
