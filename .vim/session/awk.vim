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
tabnew
tabnew
tabnew
tabnew
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
arglocal
%argdel
let s:l = 936 - ((28 * winheight(0) + 15) / 30)
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
arglocal
%argdel
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
2wincmd k
wincmd w
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
arglocal
%argdel
let s:l = 206 - ((205 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
206
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/wiki/vim/config.md") | buffer ~/wiki/vim/config.md | else | edit ~/wiki/vim/config.md | endif
let s:l = 1726 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1726
normal! 0
lcd ~/wiki/vim
wincmd w
arglocal
%argdel
if bufexists("~/wiki/vim/complete.md") | buffer ~/wiki/vim/complete.md | else | edit ~/wiki/vim/complete.md | endif
let s:l = 158 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
158
normal! 0
lcd ~/wiki/vim
wincmd w
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/.vim/plugged/vim-vim/after/ftplugin/vim.vim
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
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
arglocal
%argdel
let s:l = 76 - ((64 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
76
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
arglocal
%argdel
if bufexists("~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim") | buffer ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim | else | edit ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim | endif
let s:l = 37 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
37
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
arglocal
%argdel
if bufexists("~/Desktop/vim.vim") | buffer ~/Desktop/vim.vim | else | edit ~/Desktop/vim.vim | endif
let s:l = 69 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
69
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/.vim/plugin/matchup.vim
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
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
arglocal
%argdel
let s:l = 88 - ((83 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
88
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/.vim/plugin/README/matchup.md") | buffer ~/.vim/plugin/README/matchup.md | else | edit ~/.vim/plugin/README/matchup.md | endif
let s:l = 947 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
947
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/.vim/plugged/vim-fex/ftplugin/fex.vim
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
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 27 + 16) / 33)
arglocal
%argdel
let s:l = 4 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4
normal! 0
lcd ~/.vim/plugged/vim-fex
wincmd w
arglocal
%argdel
if bufexists("~/Desktop/cwd.md") | buffer ~/Desktop/cwd.md | else | edit ~/Desktop/cwd.md | endif
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
if bufexists("/usr/local/share/vim/vim82/doc/options.txt") | buffer /usr/local/share/vim/vim82/doc/options.txt | else | edit /usr/local/share/vim/vim82/doc/options.txt | endif
let s:l = 6733 - ((17 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
6733
normal! 033|
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 27 + 16) / 33)
tabnext
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
tabnext
edit ~/.vim/plugged/vim-unix/autoload/unix.vim
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
wincmd =
arglocal
%argdel
let s:l = 55 - ((27 * winheight(0) + 3) / 7)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
55
normal! 0
lcd ~/.vim/plugged/vim-unix
wincmd w
arglocal
%argdel
if bufexists("~/wiki/vim/shell.md") | buffer ~/wiki/vim/shell.md | else | edit ~/wiki/vim/shell.md | endif
let s:l = 23 - ((3 * winheight(0) + 3) / 7)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
23
normal! 0
lcd ~/wiki/vim
wincmd w
arglocal
%argdel
if bufexists("~/.vim/vimrc") | buffer ~/.vim/vimrc | else | edit ~/.vim/vimrc | endif
let s:l = 5310 - ((3 * winheight(0) + 3) / 7)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
5310
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/.vim/autoload/myfuncs.vim") | buffer ~/.vim/autoload/myfuncs.vim | else | edit ~/.vim/autoload/myfuncs.vim | endif
let s:l = 17 - ((2 * winheight(0) + 3) / 6)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
17
normal! 0
lcd ~/.vim
wincmd w
wincmd =
tabnext
edit ~/.vim/plugged/vim-completion/plugin/completion.vim
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
wincmd =
arglocal
%argdel
let s:l = 107 - ((9 * winheight(0) + 3) / 6)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
107
normal! 0
lcd ~/.vim/plugged/vim-completion
wincmd w
arglocal
%argdel
if bufexists("~/.vim/plugged/vim-completion/autoload/completion.vim") | buffer ~/.vim/plugged/vim-completion/autoload/completion.vim | else | edit ~/.vim/plugged/vim-completion/autoload/completion.vim | endif
let s:l = 301 - ((18 * winheight(0) + 2) / 5)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
301
normal! 0
lcd ~/.vim/plugged/vim-completion
wincmd w
arglocal
%argdel
if bufexists("~/.vim/plugged/vim-completion/autoload/completion/util.vim") | buffer ~/.vim/plugged/vim-completion/autoload/completion/util.vim | else | edit ~/.vim/plugged/vim-completion/autoload/completion/util.vim | endif
let s:l = 40 - ((2 * winheight(0) + 2) / 5)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
40
normal! 0
lcd ~/.vim/plugged/vim-completion
wincmd w
arglocal
%argdel
if bufexists("~/wiki/vim/config.md") | buffer ~/wiki/vim/config.md | else | edit ~/wiki/vim/config.md | endif
let s:l = 1718 - ((2 * winheight(0) + 2) / 5)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1718
normal! 038|
lcd ~/wiki/vim
wincmd w
arglocal
%argdel
if bufexists("~/wiki/vim/complete.md") | buffer ~/wiki/vim/complete.md | else | edit ~/wiki/vim/complete.md | endif
let s:l = 436 - ((24 * winheight(0) + 2) / 5)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
436
normal! 04|
lcd ~/wiki/vim
wincmd w
wincmd =
tabnext
edit ~/wiki/vim/command.md
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
arglocal
%argdel
let s:l = 707 - ((171 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
707
normal! 037|
lcd ~/wiki/vim
tabnext 10
badd +936 ~/wiki/awk/sed.md
badd +1 ~/.vim/plugged/vim-cheat/ftplugin/cheat.vim
badd +206 ~/Desktop/ask.md
badd +76 ~/.vim/plugged/vim-vim/after/ftplugin/vim.vim
badd +88 ~/.vim/plugin/matchup.vim
badd +4 ~/.vim/plugged/vim-fex/ftplugin/fex.vim
badd +19 ~/.vim/plugged/vim-unix/autoload/unix.vim
badd +372 ~/.vim/plugged/vim-completion/plugin/completion.vim
badd +707 ~/wiki/vim/command.md
badd +1718 ~/wiki/vim/config.md
badd +159 ~/wiki/vim/complete.md
badd +37 ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim
badd +69 ~/Desktop/vim.vim
badd +947 ~/.vim/plugin/README/matchup.md
badd +8 ~/Desktop/cwd.md
badd +1 /usr/local/share/vim/vim82/doc/options.txt
badd +23 ~/wiki/vim/shell.md
badd +3406 ~/.vim/vimrc
badd +17 ~/.vim/autoload/myfuncs.vim
badd +187 ~/.vim/plugged/vim-completion/autoload/completion.vim
badd +40 ~/.vim/plugged/vim-completion/autoload/completion/util.vim
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
let g:my_session = v:this_session
let g:my_session = v:this_session
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
