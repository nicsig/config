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
exe '2resize ' . ((&lines * 0 + 8) / 16)
exe '3resize ' . ((&lines * 0 + 8) / 16)
argglobal
let s:l = 204 - ((203 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
204
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/vim/config.md") | buffer ~/wiki/vim/config.md | else | edit ~/wiki/vim/config.md | endif
let s:l = 1726 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1726
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/complete.md") | buffer ~/wiki/vim/complete.md | else | edit ~/wiki/vim/complete.md | endif
let s:l = 162 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
162
normal! 0
lcd ~/wiki/vim
wincmd w
exe '2resize ' . ((&lines * 0 + 8) / 16)
exe '3resize ' . ((&lines * 0 + 8) / 16)
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
exe '2resize ' . ((&lines * 0 + 8) / 16)
exe '3resize ' . ((&lines * 0 + 8) / 16)
argglobal
let s:l = 76 - ((64 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
76
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim") | buffer ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim | else | edit ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim | endif
let s:l = 37 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
37
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
argglobal
if bufexists("~/Desktop/vim.vim") | buffer ~/Desktop/vim.vim | else | edit ~/Desktop/vim.vim | endif
let s:l = 69 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
69
normal! 0
lcd ~/.vim
wincmd w
exe '2resize ' . ((&lines * 0 + 8) / 16)
exe '3resize ' . ((&lines * 0 + 8) / 16)
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
exe '2resize ' . ((&lines * 0 + 8) / 16)
argglobal
let s:l = 88 - ((83 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
88
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugin/README/matchup.md") | buffer ~/.vim/plugin/README/matchup.md | else | edit ~/.vim/plugin/README/matchup.md | endif
let s:l = 947 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
947
normal! 0
lcd ~/.vim
wincmd w
exe '2resize ' . ((&lines * 0 + 8) / 16)
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
exe '2resize ' . ((&lines * 0 + 8) / 16)
argglobal
let s:l = 4 - ((0 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4
normal! 0
lcd ~/.vim/plugged/vim-fex
wincmd w
argglobal
if bufexists("~/Desktop/cwd.md") | buffer ~/Desktop/cwd.md | else | edit ~/Desktop/cwd.md | endif
let s:l = 8 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
8
normal! 0
lcd ~/.vim
wincmd w
exe '2resize ' . ((&lines * 0 + 8) / 16)
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
exe '2resize ' . ((&lines * 0 + 8) / 16)
exe '3resize ' . ((&lines * 0 + 8) / 16)
exe '4resize ' . ((&lines * 0 + 8) / 16)
argglobal
let s:l = 55 - ((52 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
55
normal! 0
lcd ~/.vim/plugged/vim-unix
wincmd w
argglobal
if bufexists("~/wiki/vim/shell.md") | buffer ~/wiki/vim/shell.md | else | edit ~/wiki/vim/shell.md | endif
let s:l = 23 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
23
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/.vim/vimrc") | buffer ~/.vim/vimrc | else | edit ~/.vim/vimrc | endif
let s:l = 5305 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
5305
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/autoload/myfuncs.vim") | buffer ~/.vim/autoload/myfuncs.vim | else | edit ~/.vim/autoload/myfuncs.vim | endif
let s:l = 17 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
17
normal! 0
lcd ~/.vim
wincmd w
exe '2resize ' . ((&lines * 0 + 8) / 16)
exe '3resize ' . ((&lines * 0 + 8) / 16)
exe '4resize ' . ((&lines * 0 + 8) / 16)
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
exe '2resize ' . ((&lines * 0 + 8) / 16)
exe '3resize ' . ((&lines * 0 + 8) / 16)
exe '4resize ' . ((&lines * 0 + 8) / 16)
exe '5resize ' . ((&lines * 0 + 8) / 16)
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
let s:l = 1718 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1718
normal! 038|
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/complete.md") | buffer ~/wiki/vim/complete.md | else | edit ~/wiki/vim/complete.md | endif
let s:l = 443 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
443
normal! 0
lcd ~/wiki/vim
wincmd w
exe '2resize ' . ((&lines * 0 + 8) / 16)
exe '3resize ' . ((&lines * 0 + 8) / 16)
exe '4resize ' . ((&lines * 0 + 8) / 16)
exe '5resize ' . ((&lines * 0 + 8) / 16)
tabnext
edit ~/wiki/vim/command.md
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
let s:l = 706 - ((181 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
706
normal! 0
lcd ~/wiki/vim
tabnext
edit ~/Desktop/parse_winlayout.vim
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
exe '2resize ' . ((&lines * 0 + 8) / 16)
exe '3resize ' . ((&lines * 0 + 8) / 16)
exe '4resize ' . ((&lines * 0 + 8) / 16)
argglobal
let s:l = 19 - ((16 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
19
normal! 061|
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/vim/folding.md") | buffer ~/wiki/vim/folding.md | else | edit ~/wiki/vim/folding.md | endif
let s:l = 190 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
190
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-fold/autoload/fold/motion.vim") | buffer ~/.vim/plugged/vim-fold/autoload/fold/motion.vim | else | edit ~/.vim/plugged/vim-fold/autoload/fold/motion.vim | endif
let s:l = 56 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
56
normal! 017|
lcd ~/.vim/plugged/vim-fold
wincmd w
argglobal
if bufexists("/tmp/vim.vim") | buffer /tmp/vim.vim | else | edit /tmp/vim.vim | endif
let s:l = 5 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
5
normal! 0
lcd ~/.vim
wincmd w
exe '2resize ' . ((&lines * 0 + 8) / 16)
exe '3resize ' . ((&lines * 0 + 8) / 16)
exe '4resize ' . ((&lines * 0 + 8) / 16)
tabnext
edit ~/.vim/plugged/vim-window/plugin/window.vim
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
exe '1resize ' . ((&lines * 0 + 8) / 16)
exe '2resize ' . ((&lines * 0 + 8) / 16)
exe '3resize ' . ((&lines * 0 + 8) / 16)
exe '4resize ' . ((&lines * 10 + 8) / 16)
argglobal
let s:l = 531 - ((7 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
531
normal! 0
lcd ~/.vim/plugged/vim-window
wincmd w
argglobal
if bufexists("~/.vim/plugin/fzf.vim") | buffer ~/.vim/plugin/fzf.vim | else | edit ~/.vim/plugin/fzf.vim | endif
let s:l = 19 - ((18 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
19
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/autoload/plugin/fzf.vim") | buffer ~/.vim/autoload/plugin/fzf.vim | else | edit ~/.vim/autoload/plugin/fzf.vim | endif
let s:l = 69 - ((2 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
69
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/after/syntax/conf.vim") | buffer ~/.vim/after/syntax/conf.vim | else | edit ~/.vim/after/syntax/conf.vim | endif
let s:l = 1 - ((0 * winheight(0) + 5) / 10)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim
wincmd w
4wincmd w
exe '1resize ' . ((&lines * 0 + 8) / 16)
exe '2resize ' . ((&lines * 0 + 8) / 16)
exe '3resize ' . ((&lines * 0 + 8) / 16)
exe '4resize ' . ((&lines * 10 + 8) / 16)
tabnext 11
badd +936 ~/wiki/awk/sed.md
badd +1 ~/.vim/plugged/vim-cheat/ftplugin/cheat.vim
badd +204 ~/Desktop/ask.md
badd +76 ~/.vim/plugged/vim-vim/after/ftplugin/vim.vim
badd +88 ~/.vim/plugin/matchup.vim
badd +4 ~/.vim/plugged/vim-fex/ftplugin/fex.vim
badd +55 ~/.vim/plugged/vim-unix/autoload/unix.vim
badd +107 ~/.vim/plugged/vim-completion/plugin/completion.vim
badd +706 ~/wiki/vim/command.md
badd +19 ~/Desktop/parse_winlayout.vim
badd +516 ~/.vim/plugged/vim-window/plugin/window.vim
badd +1718 ~/wiki/vim/config.md
badd +443 ~/wiki/vim/complete.md
badd +37 ~/.vim/plugged/vim-vim/autoload/vim/refactor/method.vim
badd +69 ~/Desktop/vim.vim
badd +947 ~/.vim/plugin/README/matchup.md
badd +8 ~/Desktop/cwd.md
badd +23 ~/wiki/vim/shell.md
badd +1679 ~/.vim/vimrc
badd +17 ~/.vim/autoload/myfuncs.vim
badd +301 ~/.vim/plugged/vim-completion/autoload/completion.vim
badd +40 ~/.vim/plugged/vim-completion/autoload/completion/util.vim
badd +190 ~/wiki/vim/folding.md
badd +51 ~/.vim/plugged/vim-fold/autoload/fold/motion.vim
badd +2 /tmp/vim.vim
badd +36 ~/.vim/plugin/fzf.vim
badd +0 ~/.vim/autoload/plugin/fzf.vim
badd +0 ~/.vim/after/syntax/conf.vim
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
