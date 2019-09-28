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
tabnew
tabnew
tabnew
tabnew
tabnew
tabnew
tabrewind
edit ~/Desktop/countries
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
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/wiki/awk/awk.md") | buffer ~/wiki/awk/awk.md | else | edit ~/wiki/awk/awk.md | endif
let s:l = 671 - ((270 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
671
normal! 0
lcd ~/wiki/awk
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext
edit ~/wiki/awk/sed.md
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
arglocal
%argdel
let s:l = 962 - ((45 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
962
normal! 0
lcd ~/wiki/awk
tabnext
edit ~/wiki/man/examples/pathfind.1
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
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/wiki/man
wincmd w
arglocal
%argdel
if bufexists("~/wiki/man/man.md") | buffer ~/wiki/man/man.md | else | edit ~/wiki/man/man.md | endif
let s:l = 31 - ((14 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
31
normal! 0
lcd ~/wiki/man
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext
edit ~/.vim/plugged/vim-cmdline/autoload/cmdline/cycle/vimgrep.vim
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
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 27 + 16) / 33)
arglocal
%argdel
let s:l = 172 - ((134 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
172
normal! 01|
lcd ~/.vim/plugged/vim-cmdline
wincmd w
arglocal
%argdel
if bufexists("~/Dropbox/vim_plugins/vimrc_grepper.vim") | buffer ~/Dropbox/vim_plugins/vimrc_grepper.vim | else | edit ~/Dropbox/vim_plugins/vimrc_grepper.vim | endif
let s:l = 153 - ((4 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
153
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/wiki/vim/async.md") | buffer ~/wiki/vim/async.md | else | edit ~/wiki/vim/async.md | endif
let s:l = 104 - ((84 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
104
normal! 0
lcd ~/wiki/vim
wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 27 + 16) / 33)
tabnext
edit ~/wiki/st.md
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
arglocal
%argdel
let s:l = 154 - ((115 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
154
normal! 0
lcd ~/wiki
tabnext
edit ~/.config/st/patches/README.md
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
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 27 + 16) / 33)
arglocal
%argdel
let s:l = 11 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
11
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/.config/st/patches/01_custom_config.diff") | buffer ~/.config/st/patches/01_custom_config.diff | else | edit ~/.config/st/patches/01_custom_config.diff | endif
let s:l = 33 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
33
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/.Xresources") | buffer ~/.Xresources | else | edit ~/.Xresources | endif
let s:l = 293 - ((292 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
293
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 27 + 16) / 33)
tabnext
edit ~/bin/upp.sh
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
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/wiki/vim/install.md") | buffer ~/wiki/vim/install.md | else | edit ~/wiki/vim/install.md | endif
let s:l = 408 - ((75 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
408
normal! 0
lcd ~/wiki/vim
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext
edit ~/wiki/tmux/command.md
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
let s:l = 891 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
891
normal! 0
lcd ~/wiki/tmux
wincmd w
arglocal
%argdel
if bufexists("~/wiki/tmux/format.md") | buffer ~/wiki/tmux/format.md | else | edit ~/wiki/tmux/format.md | endif
let s:l = 1280 - ((49 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1280
normal! 0
lcd ~/wiki/tmux
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext
edit ~/bin/yank
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
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 27 + 16) / 33)
arglocal
%argdel
let s:l = 1 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/.Xresources") | buffer ~/.Xresources | else | edit ~/.Xresources | endif
let s:l = 293 - ((2 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
293
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/wiki/terminal/capabilities.md") | buffer ~/wiki/terminal/capabilities.md | else | edit ~/wiki/terminal/capabilities.md | endif
let s:l = 613 - ((137 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
613
normal! 0
lcd ~/wiki/terminal
wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 27 + 16) / 33)
tabnext
edit ~/Desktop/session.md
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
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 27 + 16) / 33)
arglocal
%argdel
let s:l = 2 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/wiki/terminal/glossary.md") | buffer ~/wiki/terminal/glossary.md | else | edit ~/wiki/terminal/glossary.md | endif
let s:l = 149 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
149
normal! 0
lcd ~/wiki/terminal
wincmd w
arglocal
%argdel
if bufexists("~/wiki/admin/process.md") | buffer ~/wiki/admin/process.md | else | edit ~/wiki/admin/process.md | endif
let s:l = 653 - ((362 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
653
normal! 01|
lcd ~/wiki/admin
wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 27 + 16) / 33)
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
let s:l = 42 - ((41 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
42
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
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
exe '4resize ' . ((&lines * 1 + 16) / 33)
exe '5resize ' . ((&lines * 25 + 16) / 33)
arglocal
%argdel
let s:l = 352 - ((7 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
352
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/wiki/vim/complete.md") | buffer ~/wiki/vim/complete.md | else | edit ~/wiki/vim/complete.md | endif
let s:l = 57 - ((16 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
57
normal! 0
lcd ~/wiki/vim
wincmd w
arglocal
%argdel
if bufexists("~/wiki/vim/config.md") | buffer ~/wiki/vim/config.md | else | edit ~/wiki/vim/config.md | endif
let s:l = 1363 - ((17 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1363
normal! 01|
lcd ~/wiki/vim
wincmd w
arglocal
%argdel
if bufexists("~/.vim/plugged/vim-completion/autoload/completion/util.vim") | buffer ~/.vim/plugged/vim-completion/autoload/completion/util.vim | else | edit ~/.vim/plugged/vim-completion/autoload/completion/util.vim | endif
let s:l = 7 - ((6 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
7
normal! 01|
lcd ~/.vim/plugged/vim-completion
wincmd w
arglocal
%argdel
if bufexists("~/.vim/plugged/vim-completion/plugin/completion.vim") | buffer ~/.vim/plugged/vim-completion/plugin/completion.vim | else | edit ~/.vim/plugged/vim-completion/plugin/completion.vim | endif
let s:l = 78 - ((74 * winheight(0) + 12) / 25)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
78
normal! 0
lcd ~/.vim/plugged/vim-completion
wincmd w
5wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 0 + 16) / 33)
exe '4resize ' . ((&lines * 1 + 16) / 33)
exe '5resize ' . ((&lines * 25 + 16) / 33)
tabnext 12
set stal=1
" badd +1 ~/Desktop/countries
" badd +962 ~/wiki/awk/sed.md
" badd +1 ~/wiki/man/examples/pathfind.1
" badd +172 ~/.vim/plugged/vim-cmdline/autoload/cmdline/cycle/vimgrep.vim
" badd +154 ~/wiki/st.md
" badd +11 ~/.config/st/patches/README.md
" badd +1 ~/bin/upp.sh
" badd +891 ~/wiki/tmux/command.md
" badd +1 ~/bin/yank
" badd +2 ~/Desktop/session.md
" badd +42 ~/.vim/plugged/vim-cheat/ftplugin/cheat.vim
" badd +352 ~/Desktop/ask.md
" badd +671 ~/wiki/awk/awk.md
" badd +31 ~/wiki/man/man.md
" badd +153 ~/Dropbox/vim_plugins/vimrc_grepper.vim
" badd +104 ~/wiki/vim/async.md
" badd +33 ~/.config/st/patches/01_custom_config.diff
" badd +293 ~/.Xresources
" badd +408 ~/wiki/vim/install.md
" badd +1280 ~/wiki/tmux/format.md
" badd +613 ~/wiki/terminal/capabilities.md
" badd +149 ~/wiki/terminal/glossary.md
" badd +653 ~/wiki/admin/process.md
" badd +57 ~/wiki/vim/complete.md
" badd +1351 ~/wiki/vim/config.md
" badd +29 ~/.vim/plugged/vim-completion/autoload/completion/util.vim
" badd +78 ~/.vim/plugged/vim-completion/plugin/completion.vim
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=1 shortmess=filnxtToOSacFIsW
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
