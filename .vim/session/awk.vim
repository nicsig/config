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
balt ~/wiki/awk/sed.md
let s:l = 72 - ((71 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 72
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
balt ~/.vim/plugged/vim-cheat/ftplugin/cheat.vim
let s:l = 1 - ((0 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
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
balt ~/Desktop/ask.md
let s:l = 899 - ((167 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 899
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/vim/config.md") | buffer ~/wiki/vim/config.md | else | edit ~/wiki/vim/config.md | endif
balt ~/Desktop/ask.md
let s:l = 1733 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1733
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/complete.md") | buffer ~/wiki/vim/complete.md | else | edit ~/wiki/vim/complete.md | endif
balt ~/Desktop/ask.md
let s:l = 139 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 139
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
balt ~/.vim/plugged/vim-vim/after/ftplugin/vim.vim
let s:l = 84 - ((83 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 84
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
argglobal
if bufexists("~/Desktop/vim.vim") | buffer ~/Desktop/vim.vim | else | edit ~/Desktop/vim.vim | endif
balt ~/.vim/plugged/vim-vim/after/ftplugin/vim.vim
let s:l = 69 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 69
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
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
balt ~/.vim/plugin/README/matchup.md
let s:l = 947 - ((131 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 947
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugin/matchup.vim") | buffer ~/.vim/plugin/matchup.vim | else | edit ~/.vim/plugin/matchup.vim | endif
balt ~/.vim/plugin/README/matchup.md
let s:l = 88 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 88
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
balt ~/Desktop/cwd.md
let s:l = 219 - ((28 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 219
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-fex/ftplugin/fex.vim") | buffer ~/.vim/plugged/vim-fex/ftplugin/fex.vim | else | edit ~/.vim/plugged/vim-fex/ftplugin/fex.vim | endif
balt ~/Desktop/cwd.md
let s:l = 4 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 4
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
balt ~/.vim/plugged/vim-unix/autoload/unix.vim
let s:l = 58 - ((27 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 58
normal! 0
lcd ~/.vim/plugged/vim-unix
wincmd w
argglobal
if bufexists("~/wiki/vim/shell.md") | buffer ~/wiki/vim/shell.md | else | edit ~/wiki/vim/shell.md | endif
balt ~/.vim/plugged/vim-unix/autoload/unix.vim
let s:l = 21 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 21
normal! 0
lcd ~/wiki/vim
wincmd w
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
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
balt ~/.vim/plugged/vim-completion/plugin/completion.vim
let s:l = 1 - ((0 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
lcd ~/.vim/plugged/vim-completion
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-completion/autoload/completion.vim") | buffer ~/.vim/plugged/vim-completion/autoload/completion.vim | else | edit ~/.vim/plugged/vim-completion/autoload/completion.vim | endif
balt ~/.vim/plugged/vim-completion/plugin/completion.vim
let s:l = 285 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 285
normal! 0
lcd ~/.vim/plugged/vim-completion
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-completion/autoload/completion/util.vim") | buffer ~/.vim/plugged/vim-completion/autoload/completion/util.vim | else | edit ~/.vim/plugged/vim-completion/autoload/completion/util.vim | endif
balt ~/.vim/plugged/vim-completion/plugin/completion.vim
let s:l = 43 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 43
normal! 0
lcd ~/.vim/plugged/vim-completion
wincmd w
argglobal
if bufexists("~/wiki/vim/config.md") | buffer ~/wiki/vim/config.md | else | edit ~/wiki/vim/config.md | endif
balt ~/.vim/plugged/vim-completion/plugin/completion.vim
let s:l = 1537 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1537
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/complete.md") | buffer ~/wiki/vim/complete.md | else | edit ~/wiki/vim/complete.md | endif
balt ~/.vim/plugged/vim-completion/plugin/completion.vim
let s:l = 451 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 451
normal! 0
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
balt ~/Desktop/refactor.md
let s:l = 45 - ((24 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 45
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-vim/autoload/vim/refactor/substitute.vim") | buffer ~/.vim/plugged/vim-vim/autoload/vim/refactor/substitute.vim | else | edit ~/.vim/plugged/vim-vim/autoload/vim/refactor/substitute.vim | endif
balt ~/Desktop/refactor.md
let s:l = 81 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 81
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-vim/test/refactor/substitute.vim") | buffer ~/.vim/plugged/vim-vim/test/refactor/substitute.vim | else | edit ~/.vim/plugged/vim-vim/test/refactor/substitute.vim | endif
balt ~/Desktop/refactor.md
let s:l = 2 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 2
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/.vim/plugged/vim-quickhl/autoload/quickhl.vim
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
balt ~/.vim/plugged/vim-quickhl/autoload/quickhl.vim
let s:l = 72 - ((71 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 72
normal! 0
lcd ~/.vim/plugged/vim-quickhl
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
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
argglobal
balt ~/wiki/vim/sign.md
let s:l = 78 - ((77 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 78
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/popup.md") | buffer ~/wiki/vim/popup.md | else | edit ~/wiki/vim/popup.md | endif
balt ~/wiki/vim/sign.md
let s:l = 453 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 453
normal! 0
lcd ~/wiki/vim
wincmd w
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/Vcs/zsh/Misc/vcs_info-examples
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
balt ~/Vcs/zsh/Misc/vcs_info-examples
let s:l = 155 - ((8 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 155
normal! 0
lcd ~/Vcs/zsh
wincmd w
argglobal
if bufexists("~/Desktop/git-prompt.md") | buffer ~/Desktop/git-prompt.md | else | edit ~/Desktop/git-prompt.md | endif
balt ~/Vcs/zsh/Misc/vcs_info-examples
let s:l = 128 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 128
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/bin/prompt.zsh") | buffer ~/bin/prompt.zsh | else | edit ~/bin/prompt.zsh | endif
balt ~/Vcs/zsh/Misc/vcs_info-examples
let s:l = 1 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/wiki/vim/mapping.md
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
balt ~/wiki/vim/mapping.md
let s:l = 2670 - ((23 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 2670
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/vimscript.md") | buffer ~/wiki/vim/vimscript.md | else | edit ~/wiki/vim/vimscript.md | endif
balt ~/wiki/vim/mapping.md
let s:l = 312 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 312
normal! 0
lcd ~/wiki/vim
wincmd w
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/wiki/bug/vim.md
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
balt ~/wiki/bug/vim.md
let s:l = 45 - ((24 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 45
normal! 0
lcd ~/wiki/bug
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-fuzzy/autoload/fuzzy.vim") | buffer ~/.vim/plugged/vim-fuzzy/autoload/fuzzy.vim | else | edit ~/.vim/plugged/vim-fuzzy/autoload/fuzzy.vim | endif
balt ~/wiki/bug/vim.md
let s:l = 1362 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1362
normal! 0
lcd ~/.vim/plugged/vim-fuzzy
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-lg-lib/import/lg.vim") | buffer ~/.vim/plugged/vim-lg-lib/import/lg.vim | else | edit ~/.vim/plugged/vim-lg-lib/import/lg.vim | endif
balt ~/wiki/bug/vim.md
let s:l = 277 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 277
normal! 0
lcd ~/.vim/plugged/vim-lg-lib
wincmd w
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/wiki/vim/todo/todo.md
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
balt ~/wiki/vim/todo/todo.md
let s:l = 3 - ((2 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 3
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/Desktop/filez") | buffer ~/Desktop/filez | else | edit ~/Desktop/filez | endif
balt ~/wiki/vim/todo/todo.md
let s:l = 1 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-movesel/autoload/movesel.vim") | buffer ~/.vim/plugged/vim-movesel/autoload/movesel.vim | else | edit ~/.vim/plugged/vim-movesel/autoload/movesel.vim | endif
balt /tmp/t1.vim
let s:l = 407 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 407
normal! 0
lcd ~/.vim/plugged/vim-movesel
wincmd w
exe '1resize ' . ((&lines * 28 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
tabnext
edit ~/.vim/plugged/vim-lg-lib/import/lg.vim
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
let s:l = 187 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 187
normal! 0
lcd ~/.vim/plugged/vim-lg-lib
wincmd w
argglobal
if bufexists("~/.vim/autoload/myfuncs.vim") | buffer ~/.vim/autoload/myfuncs.vim | else | edit ~/.vim/autoload/myfuncs.vim | endif
balt ~/.vim/plugged/vim-lg-lib/import/lg.vim
let s:l = 54 - ((53 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 54
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext
edit ~/wiki/bug/vim.md
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
balt ~/.vim/plugged/vim-session
let s:l = 536 - ((60 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 536
normal! 0
lcd ~/wiki/bug
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-readline/autoload/readline.vim") | buffer ~/.vim/plugged/vim-readline/autoload/readline.vim | else | edit ~/.vim/plugged/vim-readline/autoload/readline.vim | endif
balt ~/wiki/bug/vim.md
let s:l = 267 - ((223 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 267
normal! 01|
lcd ~/.vim/plugged/vim-readline
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 29 + 16) / 33)
tabnext 17
badd +1 ~/wiki/awk/sed.md
badd +1 ~/.vim/plugged/vim-cheat/ftplugin/cheat.vim
badd +1 ~/Desktop/ask.md
badd +1 ~/.vim/plugged/vim-vim/after/ftplugin/vim.vim
badd +1 ~/.vim/plugin/README/matchup.md
badd +1 ~/Desktop/cwd.md
badd +75 ~/.vim/plugged/vim-unix/autoload/unix.vim
badd +1 ~/.vim/plugged/vim-completion/plugin/completion.vim
badd +1 ~/Desktop/refactor.md
badd +134 ~/.vim/plugged/vim-quickhl/autoload/quickhl.vim
badd +1 ~/wiki/vim/sign.md
badd +1 ~/Vcs/zsh/Misc/vcs_info-examples
badd +4299 ~/wiki/vim/mapping.md
badd +534 ~/wiki/bug/vim.md
badd +1 ~/wiki/vim/todo/todo.md
badd +1694 ~/wiki/vim/config.md
badd +11 ~/wiki/vim/complete.md
badd +69 ~/Desktop/vim.vim
badd +105 ~/.vim/plugin/matchup.vim
badd +38 ~/.vim/plugged/vim-fex/ftplugin/fex.vim
badd +119 ~/wiki/vim/shell.md
badd +28 ~/.vim/plugged/vim-completion/autoload/completion.vim
badd +10 ~/.vim/plugged/vim-completion/autoload/completion/util.vim
badd +28 ~/.vim/plugged/vim-vim/autoload/vim/refactor/substitute.vim
badd +8 ~/.vim/plugged/vim-vim/test/refactor/substitute.vim
badd +453 ~/wiki/vim/popup.md
badd +128 ~/Desktop/git-prompt.md
badd +3 ~/bin/prompt.zsh
badd +306 ~/wiki/vim/vimscript.md
badd +426 ~/.vim/plugged/vim-fuzzy/autoload/fuzzy.vim
badd +184 ~/.vim/plugged/vim-lg-lib/import/lg.vim
badd +1 ~/Desktop/filez
badd +369 ~/.vim/plugged/vim-movesel/autoload/movesel.vim
badd +104 ~/.vim/autoload/myfuncs.vim
badd +243 ~/.vim/plugged/vim-readline/autoload/readline.vim
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
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
