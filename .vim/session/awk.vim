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
let s:l = 228 - ((54 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
228
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/vim/config.md") | buffer ~/wiki/vim/config.md | else | edit ~/wiki/vim/config.md | endif
let s:l = 1726 - ((194 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1726
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/complete.md") | buffer ~/wiki/vim/complete.md | else | edit ~/wiki/vim/complete.md | endif
let s:l = 163 - ((83 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
163
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
argglobal
let s:l = 80 - ((68 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
80
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim") | buffer ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim | else | edit ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim | endif
let s:l = 37 - ((21 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
37
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
argglobal
if bufexists("~/Desktop/vim.vim") | buffer ~/Desktop/vim.vim | else | edit ~/Desktop/vim.vim | endif
let s:l = 69 - ((16 * winheight(0) + 0) / 0)
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
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
argglobal
let s:l = 947 - ((104 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
947
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugin/matchup.vim") | buffer ~/.vim/plugin/matchup.vim | else | edit ~/.vim/plugin/matchup.vim | endif
let s:l = 88 - ((19 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
88
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
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
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
argglobal
let s:l = 8 - ((7 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
8
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-fex/ftplugin/fex.vim") | buffer ~/.vim/plugged/vim-fex/ftplugin/fex.vim | else | edit ~/.vim/plugged/vim-fex/ftplugin/fex.vim | endif
let s:l = 4 - ((3 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4
normal! 0
lcd ~/.vim/plugged/vim-fex
wincmd w
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
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
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
argglobal
let s:l = 55 - ((52 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
55
normal! 0
lcd ~/.vim/plugged/vim-unix
wincmd w
argglobal
if bufexists("~/wiki/vim/shell.md") | buffer ~/wiki/vim/shell.md | else | edit ~/wiki/vim/shell.md | endif
let s:l = 26 - ((3 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
26
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/.vim/autoload/myfuncs.vim") | buffer ~/.vim/autoload/myfuncs.vim | else | edit ~/.vim/autoload/myfuncs.vim | endif
let s:l = 27 - ((3 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
27
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
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
exe '1resize ' . ((&lines * 26 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
exe '4resize ' . ((&lines * 0 + 16) / 33)
exe '5resize ' . ((&lines * 0 + 16) / 33)
argglobal
let s:l = 107 - ((95 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
107
normal! 0
lcd ~/.vim/plugged/vim-completion
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-completion/autoload/completion.vim") | buffer ~/.vim/plugged/vim-completion/autoload/completion.vim | else | edit ~/.vim/plugged/vim-completion/autoload/completion.vim | endif
let s:l = 301 - ((25 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
301
normal! 0
lcd ~/.vim/plugged/vim-completion
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-completion/autoload/completion/util.vim") | buffer ~/.vim/plugged/vim-completion/autoload/completion/util.vim | else | edit ~/.vim/plugged/vim-completion/autoload/completion/util.vim | endif
let s:l = 40 - ((10 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
40
normal! 0
lcd ~/.vim/plugged/vim-completion
wincmd w
argglobal
if bufexists("~/wiki/vim/config.md") | buffer ~/wiki/vim/config.md | else | edit ~/wiki/vim/config.md | endif
let s:l = 1533 - ((909 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1533
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/complete.md") | buffer ~/wiki/vim/complete.md | else | edit ~/wiki/vim/complete.md | endif
let s:l = 475 - ((12 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
475
normal! 03|
lcd ~/wiki/vim
wincmd w
exe '1resize ' . ((&lines * 26 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
exe '4resize ' . ((&lines * 0 + 16) / 33)
exe '5resize ' . ((&lines * 0 + 16) / 33)
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
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
argglobal
let s:l = 45 - ((24 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
45
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-vim/autoload/vim/refactor/substitute.vim") | buffer ~/.vim/plugged/vim-vim/autoload/vim/refactor/substitute.vim | else | edit ~/.vim/plugged/vim-vim/autoload/vim/refactor/substitute.vim | endif
let s:l = 75 - ((59 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
75
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-vim/test/refactor/substitute.vim") | buffer ~/.vim/plugged/vim-vim/test/refactor/substitute.vim | else | edit ~/.vim/plugged/vim-vim/test/refactor/substitute.vim | endif
let s:l = 2 - ((1 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
normal! $
lcd ~/.vim/plugged/vim-vim
wincmd w
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
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
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
argglobal
let s:l = 1 - ((0 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-quickhl/autoload/quickhl.vim") | buffer ~/.vim/plugged/vim-quickhl/autoload/quickhl.vim | else | edit ~/.vim/plugged/vim-quickhl/autoload/quickhl.vim | endif
let s:l = 85 - ((79 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
85
normal! 08|
lcd ~/.vim/plugged/vim-quickhl
wincmd w
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/Desktop/popup.md
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
let s:l = 10 - ((9 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
10
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/Desktop/test1.vim") | buffer ~/Desktop/test1.vim | else | edit ~/Desktop/test1.vim | endif
let s:l = 1 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/Desktop/recipe_float.vim") | buffer ~/Desktop/recipe_float.vim | else | edit ~/Desktop/recipe_float.vim | endif
let s:l = 26 - ((23 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
26
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/.vim/plugged/vim-cookbook/autoload/cookbook.vim
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
let s:l = 88 - ((4 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
88
normal! 043|
lcd ~/.vim/plugged/vim-cookbook
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-cookbook/autoload/cookbook/popup/terminal.vim") | buffer ~/.vim/plugged/vim-cookbook/autoload/cookbook/popup/terminal.vim | else | edit ~/.vim/plugged/vim-cookbook/autoload/cookbook/popup/terminal.vim | endif
let s:l = 49 - ((42 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
49
normal! 01|
lcd ~/.vim/plugged/vim-cookbook
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 29 + 16) / 33)
tabnext 12
badd +936 ~/wiki/awk/sed.md
badd +71 ~/.vim/plugged/vim-cheat/ftplugin/cheat.vim
badd +1 ~/Desktop/ask.md
badd +93 ~/.vim/plugged/vim-vim/after/ftplugin/vim.vim
badd +947 ~/.vim/plugin/README/matchup.md
badd +8 ~/Desktop/cwd.md
badd +57 ~/.vim/plugged/vim-unix/autoload/unix.vim
badd +371 ~/.vim/plugged/vim-completion/plugin/completion.vim
badd +1 ~/Desktop/refactor.md
badd +1 ~/Desktop/text-properties.md
badd +12 ~/Desktop/popup.md
badd +86 ~/.vim/plugged/vim-cookbook/autoload/cookbook.vim
badd +1444 ~/wiki/vim/config.md
badd +451 ~/wiki/vim/complete.md
badd +14 ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim
badd +69 ~/Desktop/vim.vim
badd +1 ~/.vim/plugin/matchup.vim
badd +1 ~/.vim/plugged/vim-fex/ftplugin/fex.vim
badd +23 ~/wiki/vim/shell.md
badd +842 ~/.vim/autoload/myfuncs.vim
badd +1093 ~/.vim/plugged/vim-completion/autoload/completion.vim
badd +8 ~/.vim/plugged/vim-completion/autoload/completion/util.vim
badd +7 ~/.vim/plugged/vim-vim/autoload/vim/refactor/substitute.vim
badd +1 ~/.vim/plugged/vim-vim/test/refactor/substitute.vim
badd +182 ~/.vim/plugged/vim-quickhl/autoload/quickhl.vim
badd +74 ~/Desktop/test1.vim
badd +1 ~/Desktop/recipe_float.vim
badd +14 ~/.vim/plugged/vim-cookbook/autoload/cookbook/popup/terminal.vim
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
