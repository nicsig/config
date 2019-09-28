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
edit ~/wiki/vim/arglist.md
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
arglocal
%argdel
let s:l = 428 - ((3 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
428
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
arglocal
%argdel
let s:l = 5 - ((3 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
5
normal! 0
lcd ~/wiki/vim
wincmd w
arglocal
%argdel
if bufexists("~/.vim/plugged/vim-cmdline/autoload/cmdline.vim") | buffer ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim | else | edit ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim | endif
let s:l = 142 - ((64 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
142
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
arglocal
%argdel
let s:l = 191 - ((62 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
191
normal! 0
lcd ~/.vim/plugged/vim-markdown
wincmd w
arglocal
%argdel
if bufexists("/usr/local/share/vim/vim80/doc/usr_44.txt") | buffer /usr/local/share/vim/vim80/doc/usr_44.txt | else | edit /usr/local/share/vim/vim80/doc/usr_44.txt | endif
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
arglocal
%argdel
let s:l = 25 - ((4 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
25
normal! 0
lcd ~/.vim/plugged/vim-debug
wincmd w
arglocal
%argdel
if bufexists("~/.vim/plugged/vim-debug/syntax/timer_info.vim") | buffer ~/.vim/plugged/vim-debug/syntax/timer_info.vim | else | edit ~/.vim/plugged/vim-debug/syntax/timer_info.vim | endif
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim/plugged/vim-debug
wincmd w
arglocal
%argdel
if bufexists("~/.vim/plugged/vim-debug/ftplugin/timer_info.vim") | buffer ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim | else | edit ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim | endif
let s:l = 2 - ((1 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
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
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
arglocal
%argdel
let s:l = 164 - ((2 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
164
normal! 0
lcd ~/wiki/python
wincmd w
arglocal
%argdel
if bufexists("~/.vim/plugged/vim-debug/ftplugin/timer_info.vim") | buffer ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim | else | edit ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim | endif
let s:l = 1 - ((0 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim/plugged/vim-debug
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext 5
set stal=1
badd +1 ~/.vim/plugged/vim-debug/ftplugin/timer_info.vim
badd +1 ~/wiki/vim/arglist.md
badd +1 ~/wiki/vim/command.md
badd +1 ~/.vim/plugged/vim-markdown/syntax/markdown.vim
badd +1 ~/.vim/plugged/vim-debug/autoload/debug/timer.vim
badd +1 ~/wiki/python/python.md
badd +1 ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim
badd +1 ~/.vim/plugged/vim-debug/syntax/timer_info.vim
badd +0 /usr/local/share/vim/vim80/doc/usr_44.txt
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=1 shortmess=filnxtToOSacFIsW
set winminheight=1 winminwidth=1
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
