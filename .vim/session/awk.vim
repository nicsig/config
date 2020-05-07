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
let s:l = 79 - ((78 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
79
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
2wincmd k
wincmd w
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 3 + 10) / 21)
exe '2resize ' . ((&lines * 8 + 10) / 21)
exe '3resize ' . ((&lines * 17 + 10) / 21)
argglobal
let s:l = 228 - ((1 * winheight(0) + 1) / 3)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
228
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/vim/config.md") | buffer ~/wiki/vim/config.md | else | edit ~/wiki/vim/config.md | endif
let s:l = 1692 - ((3 * winheight(0) + 4) / 8)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1692
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/complete.md") | buffer ~/wiki/vim/complete.md | else | edit ~/wiki/vim/complete.md | endif
let s:l = 163 - ((57 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
163
normal! 0
lcd ~/wiki/vim
wincmd w
exe '1resize ' . ((&lines * 3 + 10) / 21)
exe '2resize ' . ((&lines * 8 + 10) / 21)
exe '3resize ' . ((&lines * 17 + 10) / 21)
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
exe '1resize ' . ((&lines * 3 + 10) / 21)
exe '2resize ' . ((&lines * 8 + 10) / 21)
exe '3resize ' . ((&lines * 17 + 10) / 21)
argglobal
let s:l = 80 - ((3 * winheight(0) + 1) / 3)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
80
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim") | buffer ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim | else | edit ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim | endif
let s:l = 37 - ((17 * winheight(0) + 4) / 8)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
37
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
argglobal
if bufexists("~/Desktop/vim.vim") | buffer ~/Desktop/vim.vim | else | edit ~/Desktop/vim.vim | endif
let s:l = 69 - ((8 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
69
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 3 + 10) / 21)
exe '2resize ' . ((&lines * 8 + 10) / 21)
exe '3resize ' . ((&lines * 17 + 10) / 21)
tabnext
edit ~/.vim/plugin/README/matchup.md
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
exe '1resize ' . ((&lines * 12 + 10) / 21)
exe '2resize ' . ((&lines * 17 + 10) / 21)
argglobal
let s:l = 947 - ((54 * winheight(0) + 6) / 12)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
947
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugin/matchup.vim") | buffer ~/.vim/plugin/matchup.vim | else | edit ~/.vim/plugin/matchup.vim | endif
let s:l = 88 - ((84 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
88
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 12 + 10) / 21)
exe '2resize ' . ((&lines * 17 + 10) / 21)
tabnext
edit ~/Desktop/cwd.md
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
exe '1resize ' . ((&lines * 12 + 10) / 21)
exe '2resize ' . ((&lines * 17 + 10) / 21)
argglobal
let s:l = 219 - ((11 * winheight(0) + 6) / 12)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
219
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-fex/ftplugin/fex.vim") | buffer ~/.vim/plugged/vim-fex/ftplugin/fex.vim | else | edit ~/.vim/plugged/vim-fex/ftplugin/fex.vim | endif
let s:l = 4 - ((3 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4
normal! 0
lcd ~/.vim/plugged/vim-fex
wincmd w
exe '1resize ' . ((&lines * 12 + 10) / 21)
exe '2resize ' . ((&lines * 17 + 10) / 21)
tabnext
edit ~/.vim/plugged/vim-unix/autoload/unix.vim
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
exe '1resize ' . ((&lines * 3 + 10) / 21)
exe '2resize ' . ((&lines * 8 + 10) / 21)
exe '3resize ' . ((&lines * 17 + 10) / 21)
argglobal
let s:l = 55 - ((1 * winheight(0) + 1) / 3)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
55
normal! 0
lcd ~/.vim/plugged/vim-unix
wincmd w
argglobal
if bufexists("~/wiki/vim/shell.md") | buffer ~/wiki/vim/shell.md | else | edit ~/wiki/vim/shell.md | endif
let s:l = 26 - ((3 * winheight(0) + 4) / 8)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
26
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/.vim/autoload/myfuncs.vim") | buffer ~/.vim/autoload/myfuncs.vim | else | edit ~/.vim/autoload/myfuncs.vim | endif
let s:l = 27 - ((8 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
27
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 3 + 10) / 21)
exe '2resize ' . ((&lines * 8 + 10) / 21)
exe '3resize ' . ((&lines * 17 + 10) / 21)
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
exe '1resize ' . ((&lines * 1 + 10) / 21)
exe '2resize ' . ((&lines * 0 + 10) / 21)
exe '3resize ' . ((&lines * 0 + 10) / 21)
exe '4resize ' . ((&lines * 8 + 10) / 21)
exe '5resize ' . ((&lines * 17 + 10) / 21)
argglobal
let s:l = 107 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
107
normal! 0
lcd ~/.vim/plugged/vim-completion
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-completion/autoload/completion.vim") | buffer ~/.vim/plugged/vim-completion/autoload/completion.vim | else | edit ~/.vim/plugged/vim-completion/autoload/completion.vim | endif
let s:l = 301 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
301
normal! 0
lcd ~/.vim/plugged/vim-completion
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-completion/autoload/completion/util.vim") | buffer ~/.vim/plugged/vim-completion/autoload/completion/util.vim | else | edit ~/.vim/plugged/vim-completion/autoload/completion/util.vim | endif
let s:l = 40 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
40
normal! 0
lcd ~/.vim/plugged/vim-completion
wincmd w
argglobal
if bufexists("~/wiki/vim/config.md") | buffer ~/wiki/vim/config.md | else | edit ~/wiki/vim/config.md | endif
let s:l = 1495 - ((150 * winheight(0) + 4) / 8)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1495
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/complete.md") | buffer ~/wiki/vim/complete.md | else | edit ~/wiki/vim/complete.md | endif
let s:l = 475 - ((8 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
475
normal! 0
lcd ~/wiki/vim
wincmd w
exe '1resize ' . ((&lines * 1 + 10) / 21)
exe '2resize ' . ((&lines * 0 + 10) / 21)
exe '3resize ' . ((&lines * 0 + 10) / 21)
exe '4resize ' . ((&lines * 8 + 10) / 21)
exe '5resize ' . ((&lines * 17 + 10) / 21)
tabnext
edit ~/Desktop/refactor.md
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
exe '1resize ' . ((&lines * 3 + 10) / 21)
exe '2resize ' . ((&lines * 8 + 10) / 21)
exe '3resize ' . ((&lines * 17 + 10) / 21)
argglobal
let s:l = 45 - ((0 * winheight(0) + 1) / 3)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
45
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-vim/autoload/vim/refactor/substitute.vim") | buffer ~/.vim/plugged/vim-vim/autoload/vim/refactor/substitute.vim | else | edit ~/.vim/plugged/vim-vim/autoload/vim/refactor/substitute.vim | endif
let s:l = 75 - ((7 * winheight(0) + 4) / 8)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
75
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-vim/test/refactor/substitute.vim") | buffer ~/.vim/plugged/vim-vim/test/refactor/substitute.vim | else | edit ~/.vim/plugged/vim-vim/test/refactor/substitute.vim | endif
let s:l = 2 - ((1 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
exe '1resize ' . ((&lines * 3 + 10) / 21)
exe '2resize ' . ((&lines * 8 + 10) / 21)
exe '3resize ' . ((&lines * 17 + 10) / 21)
tabnext
edit ~/Desktop/text-properties.md
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
exe '2resize ' . ((&lines * 0 + 10) / 21)
argglobal
let s:l = 398 - ((316 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
398
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-quickhl/autoload/quickhl.vim") | buffer ~/.vim/plugged/vim-quickhl/autoload/quickhl.vim | else | edit ~/.vim/plugged/vim-quickhl/autoload/quickhl.vim | endif
let s:l = 86 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
86
normal! 0
lcd ~/.vim/plugged/vim-quickhl
wincmd w
exe '2resize ' . ((&lines * 0 + 10) / 21)
tabnext
edit ~/wiki/vim/sign.md
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
exe '2resize ' . ((&lines * 0 + 10) / 21)
argglobal
let s:l = 80 - ((79 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
80
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/popup.md") | buffer ~/wiki/vim/popup.md | else | edit ~/wiki/vim/popup.md | endif
let s:l = 438 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
438
normal! 0
lcd ~/wiki/vim
wincmd w
exe '2resize ' . ((&lines * 0 + 10) / 21)
tabnext
edit ~/wiki/vim/vimL.md
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
exe '1resize ' . ((&lines * 1 + 10) / 21)
exe '2resize ' . ((&lines * 0 + 10) / 21)
exe '3resize ' . ((&lines * 0 + 10) / 21)
argglobal
let s:l = 245 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
245
normal! 080|
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/mapping.md") | buffer ~/wiki/vim/mapping.md | else | edit ~/wiki/vim/mapping.md | endif
let s:l = 28 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
28
normal! 05|
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/todo/todo.md") | buffer ~/wiki/vim/todo/todo.md | else | edit ~/wiki/vim/todo/todo.md | endif
let s:l = 1 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-cmdline/autoload/cmdline/tab.vim") | buffer ~/.vim/plugged/vim-cmdline/autoload/cmdline/tab.vim | else | edit ~/.vim/plugged/vim-cmdline/autoload/cmdline/tab.vim | endif
let s:l = 54 - ((44 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
54
normal! 0
lcd ~/.vim/plugged/vim-cmdline
wincmd w
exe '1resize ' . ((&lines * 1 + 10) / 21)
exe '2resize ' . ((&lines * 0 + 10) / 21)
exe '3resize ' . ((&lines * 0 + 10) / 21)
tabnext
edit ~/Desktop/bug.md
set splitbelow splitright
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
5wincmd k
wincmd w
wincmd w
wincmd w
wincmd w
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 0 + 10) / 21)
exe '2resize ' . ((&lines * 0 + 10) / 21)
exe '3resize ' . ((&lines * 0 + 10) / 21)
exe '4resize ' . ((&lines * 0 + 10) / 21)
exe '5resize ' . ((&lines * 0 + 10) / 21)
exe '6resize ' . ((&lines * 13 + 10) / 21)
argglobal
let s:l = 42 - ((3 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
42
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-repeat/autoload/repeat.vim") | buffer ~/.vim/plugged/vim-repeat/autoload/repeat.vim | else | edit ~/.vim/plugged/vim-repeat/autoload/repeat.vim | endif
let s:l = 189 - ((184 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
189
normal! 011|
lcd ~/.vim/plugged/vim-repeat
wincmd w
argglobal
if bufexists("/run/user/1000/tmp/vim-repeat/autoload/repeat.vim") | buffer /run/user/1000/tmp/vim-repeat/autoload/repeat.vim | else | edit /run/user/1000/tmp/vim-repeat/autoload/repeat.vim | endif
let s:l = 36 - ((5 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
36
normal! 0
lcd /run/user/1000/tmp/vim-repeat
wincmd w
argglobal
if bufexists("~/Desktop/u.vim") | buffer ~/Desktop/u.vim | else | edit ~/Desktop/u.vim | endif
let s:l = 8 - ((7 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
8
normal! 05|
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/vim/mapping.md") | buffer ~/wiki/vim/mapping.md | else | edit ~/wiki/vim/mapping.md | endif
let s:l = 1564 - ((8 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1564
normal! 05|
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("/tmp/t.vim") | buffer /tmp/t.vim | else | edit /tmp/t.vim | endif
let s:l = 5 - ((4 * winheight(0) + 6) / 13)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
5
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 0 + 10) / 21)
exe '2resize ' . ((&lines * 0 + 10) / 21)
exe '3resize ' . ((&lines * 0 + 10) / 21)
exe '4resize ' . ((&lines * 0 + 10) / 21)
exe '5resize ' . ((&lines * 0 + 10) / 21)
exe '6resize ' . ((&lines * 13 + 10) / 21)
tabnext
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
tabnext 14
badd +1 ~/wiki/awk/sed.md
badd +1 ~/.vim/plugged/vim-cheat/ftplugin/cheat.vim
badd +1 ~/Desktop/ask.md
badd +1 ~/.vim/plugged/vim-vim/after/ftplugin/vim.vim
badd +1 ~/.vim/plugin/README/matchup.md
badd +1 ~/Desktop/cwd.md
badd +1 ~/.vim/plugged/vim-unix/autoload/unix.vim
badd +377 ~/.vim/plugged/vim-completion/plugin/completion.vim
badd +1 ~/Desktop/refactor.md
badd +1 ~/Desktop/text-properties.md
badd +1 ~/wiki/vim/sign.md
badd +1 ~/wiki/vim/vimL.md
badd +1 ~/Desktop/bug.md
badd +1907 ~/wiki/vim/config.md
badd +129 ~/wiki/vim/complete.md
badd +41 ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim
badd +69 ~/Desktop/vim.vim
badd +158 ~/.vim/plugin/matchup.vim
badd +59 ~/.vim/plugged/vim-fex/ftplugin/fex.vim
badd +26 ~/wiki/vim/shell.md
badd +612 ~/.vim/autoload/myfuncs.vim
badd +1033 ~/.vim/plugged/vim-completion/autoload/completion.vim
badd +8 ~/.vim/plugged/vim-completion/autoload/completion/util.vim
badd +21 ~/.vim/plugged/vim-vim/autoload/vim/refactor/substitute.vim
badd +2 ~/.vim/plugged/vim-vim/test/refactor/substitute.vim
badd +86 ~/.vim/plugged/vim-quickhl/autoload/quickhl.vim
badd +55 ~/wiki/vim/popup.md
badd +1 ~/wiki/vim/mapping.md
badd +208 ~/wiki/vim/todo/todo.md
badd +69 ~/.vim/plugged/vim-cmdline/autoload/cmdline/tab.vim
badd +247 ~/.vim/plugged/vim-repeat/autoload/repeat.vim
badd +20 /run/user/1000/tmp/vim-repeat/autoload/repeat.vim
badd +1 ~/Desktop/u.vim
badd +0 /tmp/t.vim
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
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
