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
tabrewind
edit ~/wiki/awk/sed.md
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
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
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
argglobal
let s:l = 222 - ((20 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
222
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/vim/config.md") | buffer ~/wiki/vim/config.md | else | edit ~/wiki/vim/config.md | endif
let s:l = 1589 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1589
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/complete.md") | buffer ~/wiki/vim/complete.md | else | edit ~/wiki/vim/complete.md | endif
let s:l = 161 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
161
normal! 0
lcd ~/wiki/vim
wincmd w
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/Desktop/answer.md
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
argglobal
let s:l = 183 - ((110 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
183
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/Desktop/vim.vim") | buffer ~/Desktop/vim.vim | else | edit ~/Desktop/vim.vim | endif
let s:l = 66 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
66
normal! 021|
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/.vim/plugged/vim-vim/after/ftplugin/vim.vim
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
argglobal
let s:l = 39 - ((27 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
39
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim") | buffer ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim | else | edit ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim | endif
let s:l = 20 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
20
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
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
argglobal
let s:l = 28 - ((23 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
28
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugin/README/matchup.md") | buffer ~/.vim/plugin/README/matchup.md | else | edit ~/.vim/plugin/README/matchup.md | endif
let s:l = 939 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
939
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
1wincmd k
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
argglobal
let s:l = 12 - ((7 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
12
normal! 053|
lcd ~/.vim/plugged/vim-fex
wincmd w
argglobal
if bufexists("~/Desktop/cwd.md") | buffer ~/Desktop/cwd.md | else | edit ~/Desktop/cwd.md | endif
let s:l = 5 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
5
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/wiki/vim/shell.md
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
exe '2resize ' . ((&lines * 28 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
argglobal
let s:l = 93 - ((3 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
93
normal! 014|
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/Desktop/bug.md") | buffer ~/Desktop/bug.md | else | edit ~/Desktop/bug.md | endif
let s:l = 18 - ((17 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
18
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-tmuxify/autoload/tmuxify.vim") | buffer ~/.vim/plugged/vim-tmuxify/autoload/tmuxify.vim | else | edit ~/.vim/plugged/vim-tmuxify/autoload/tmuxify.vim | endif
let s:l = 42 - ((3 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
42
normal! 0
lcd ~/.vim/plugged/vim-tmuxify
wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/.vim/plugged/vim-fex/.git/index
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
wincmd =
argglobal
let s:l = 5 - ((4 * winheight(0) + 3) / 7)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
5
normal! 0
lcd ~/.vim/plugged/vim-fex
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-fex/.git/COMMIT_EDITMSG") | buffer ~/.vim/plugged/vim-fex/.git/COMMIT_EDITMSG | else | edit ~/.vim/plugged/vim-fex/.git/COMMIT_EDITMSG | endif
let s:l = 1 - ((0 * winheight(0) + 5) / 10)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim/plugged/vim-fex/.git
wincmd w
2wincmd w
wincmd =
tabnext 9
badd +1 ~/wiki/awk/sed.md
badd +1 ~/.vim/plugged/vim-cheat/ftplugin/cheat.vim
badd +1 ~/Desktop/ask.md
badd +190 ~/Desktop/answer.md
badd +1 ~/.vim/plugged/vim-vim/after/ftplugin/vim.vim
badd +1 ~/.vim/plugin/matchup.vim
badd +36 ~/.vim/plugged/vim-fex/ftplugin/fex.vim
badd +40 ~/wiki/vim/shell.md
badd +1589 ~/wiki/vim/config.md
badd +161 ~/wiki/vim/complete.md
badd +66 ~/Desktop/vim.vim
badd +20 ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim
badd +939 ~/.vim/plugin/README/matchup.md
badd +2 ~/Desktop/cwd.md
badd +1 ~/Desktop/bug.md
badd +1 ~/.vim/plugged/vim-tmuxify/autoload/tmuxify.vim
badd +0 ~/.vim/plugged/vim-fex/.git/index
badd +0 ~/.vim/plugged/vim-fex/.git/COMMIT_EDITMSG
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
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
