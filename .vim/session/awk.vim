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
let s:l = 936 - ((19 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
936
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
argglobal
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/wiki/man
wincmd w
argglobal
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
argglobal
let s:l = 166 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
166
normal! 0
lcd ~/.vim/plugged/vim-cmdline
wincmd w
argglobal
if bufexists("~/Dropbox/vim_plugins/vimrc_grepper.vim") | buffer ~/Dropbox/vim_plugins/vimrc_grepper.vim | else | edit ~/Dropbox/vim_plugins/vimrc_grepper.vim | endif
let s:l = 153 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
153
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/vim/async.md") | buffer ~/wiki/vim/async.md | else | edit ~/wiki/vim/async.md | endif
let s:l = 104 - ((18 * winheight(0) + 13) / 27)
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
argglobal
let s:l = 46 - ((7 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
46
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
argglobal
let s:l = 2 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.config/st/patches/01_custom_config.diff") | buffer ~/.config/st/patches/01_custom_config.diff | else | edit ~/.config/st/patches/01_custom_config.diff | endif
let s:l = 33 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
33
normal! 0
lcd ~/.vim
wincmd w
argglobal
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
argglobal
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/vim/install.md") | buffer ~/wiki/vim/install.md | else | edit ~/wiki/vim/install.md | endif
let s:l = 408 - ((81 * winheight(0) + 14) / 28)
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
argglobal
let s:l = 853 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
853
normal! 0
lcd ~/wiki/tmux
wincmd w
argglobal
if bufexists("~/wiki/tmux/format.md") | buffer ~/wiki/tmux/format.md | else | edit ~/wiki/tmux/format.md | endif
let s:l = 1280 - ((50 * winheight(0) + 14) / 28)
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
argglobal
let s:l = 1 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.Xresources") | buffer ~/.Xresources | else | edit ~/.Xresources | endif
let s:l = 293 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
293
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/terminal/capabilities.md") | buffer ~/wiki/terminal/capabilities.md | else | edit ~/wiki/terminal/capabilities.md | endif
let s:l = 613 - ((18 * winheight(0) + 13) / 27)
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
argglobal
let s:l = 2 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/terminal/glossary.md") | buffer ~/wiki/terminal/glossary.md | else | edit ~/wiki/terminal/glossary.md | endif
let s:l = 149 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
149
normal! 0
lcd ~/wiki/terminal
wincmd w
argglobal
if bufexists("~/wiki/admin/process.md") | buffer ~/wiki/admin/process.md | else | edit ~/wiki/admin/process.md | endif
let s:l = 653 - ((13 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
653
normal! 0
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
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 1 + 16) / 33)
exe '4resize ' . ((&lines * 26 + 16) / 33)
argglobal
let s:l = 484 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
484
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/vim/config.md") | buffer ~/wiki/vim/config.md | else | edit ~/wiki/vim/config.md | endif
let s:l = 1542 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1542
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/wiki/vim/complete.md") | buffer ~/wiki/vim/complete.md | else | edit ~/wiki/vim/complete.md | endif
let s:l = 166 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
166
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-lg-lib/autoload/lg/window.vim") | buffer ~/.vim/plugged/vim-lg-lib/autoload/lg/window.vim | else | edit ~/.vim/plugged/vim-lg-lib/autoload/lg/window.vim | endif
let s:l = 60 - ((59 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
60
normal! 0
lcd ~/.vim/plugged/vim-lg-lib
wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 1 + 16) / 33)
exe '4resize ' . ((&lines * 26 + 16) / 33)
tabnext
edit ~/Desktop/vim.vim
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
let s:l = 32 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
32
normal! 018|
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/Desktop/answer.md") | buffer ~/Desktop/answer.md | else | edit ~/Desktop/answer.md | endif
let s:l = 194 - ((12 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
194
normal! 023|
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
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
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
argglobal
let s:l = 8957 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
8957
normal! 07|
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/.vim/plugged/vim-search/plugin/search.vim") | buffer ~/.vim/plugged/vim-search/plugin/search.vim | else | edit ~/.vim/plugged/vim-search/plugin/search.vim | endif
let s:l = 322 - ((13 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
322
normal! 0
lcd ~/.vim/plugged/vim-search
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext
edit /tmp/file
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
argglobal
let s:l = 1 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("/tmp/dict") | buffer /tmp/dict | else | edit /tmp/dict | endif
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/Desktop/bug.md") | buffer ~/Desktop/bug.md | else | edit ~/Desktop/bug.md | endif
let s:l = 3 - ((2 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
3
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 0 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 27 + 16) / 33)
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
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
argglobal
let s:l = 4162 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4162
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists("~/wiki/vim/mapping.md") | buffer ~/wiki/vim/mapping.md | else | edit ~/wiki/vim/mapping.md | endif
let s:l = 1 - ((0 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/wiki/vim
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext 15
set stal=1
" badd +936 ~/wiki/awk/sed.md
" badd +1 ~/wiki/man/examples/pathfind.1
" badd +1 ~/.vim/plugged/vim-cmdline/autoload/cmdline/cycle/vimgrep.vim
" badd +1 ~/wiki/st.md
" badd +1 ~/.config/st/patches/README.md
" badd +287 ~/bin/upp.sh
" badd +1 ~/wiki/tmux/command.md
" badd +1 ~/bin/yank
" badd +1 ~/Desktop/session.md
" badd +1 ~/.vim/plugged/vim-cheat/ftplugin/cheat.vim
" badd +1 ~/Desktop/ask.md
" badd +1 ~/Desktop/vim.vim
" badd +4162 ~/.vim/vimrc
" badd +1 ~/wiki/man/man.md
" badd +1 ~/Dropbox/vim_plugins/vimrc_grepper.vim
" badd +1 ~/wiki/vim/async.md
" badd +1 ~/.config/st/patches/01_custom_config.diff
" badd +1 ~/.Xresources
" badd +1 ~/wiki/vim/install.md
" badd +1 ~/wiki/tmux/format.md
" badd +1 ~/wiki/terminal/capabilities.md
" badd +1 ~/wiki/terminal/glossary.md
" badd +1 ~/wiki/admin/process.md
" badd +1 ~/wiki/vim/config.md
" badd +1 ~/wiki/vim/complete.md
" badd +1 ~/.vim/plugged/vim-lg-lib/autoload/lg/window.vim
" badd +1 ~/Desktop/answer.md
" badd +1 ~/Desktop/bug.md
" badd +322 ~/.vim/plugged/vim-search/plugin/search.vim
" badd +0 /tmp/file
" badd +0 /tmp/dict
" badd +0 ~/wiki/vim/mapping.md
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
let g:my_session = v:this_session
let g:my_session = v:this_session
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
