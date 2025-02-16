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
tabrewind
edit ~/wiki/vim/async.md
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
let s:l = 128 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
128
normal! 06|
lcd ~/wiki/vim
wincmd w
arglocal
%argdel
if bufexists("~/.vim/plugged/asyncmake/plugin/asyncmake.vim") | buffer ~/.vim/plugged/asyncmake/plugin/asyncmake.vim | else | edit ~/.vim/plugged/asyncmake/plugin/asyncmake.vim | endif
let s:l = 8 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
8
normal! 051|
lcd ~/.vim/plugged/asyncmake
wincmd w
arglocal
%argdel
if bufexists("~/.vim/plugged/asyncmake/autoload/asyncmake.vim") | buffer ~/.vim/plugged/asyncmake/autoload/asyncmake.vim | else | edit ~/.vim/plugged/asyncmake/autoload/asyncmake.vim | endif
let s:l = 4 - ((3 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4
normal! 0
lcd ~/.vim/plugged/asyncmake
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
exe '3resize ' . ((&lines * 27 + 16) / 33)
tabnext
edit ~/.vim/plugged/vim-cmdline/autoload/cmdline/cycle/vimgrep.vim
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
let s:l = 1 - ((0 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim/plugged/vim-cmdline
wincmd w
arglocal
%argdel
if bufexists("~/Dropbox/vim_plugins/vimrc_grepper.vim") | buffer ~/Dropbox/vim_plugins/vimrc_grepper.vim | else | edit ~/Dropbox/vim_plugins/vimrc_grepper.vim | endif
let s:l = 186 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
186
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 29 + 16) / 33)
exe '2resize ' . ((&lines * 0 + 16) / 33)
tabnext 2
badd +1 ~/.vim/plugged/vim-cmdline/autoload/cmdline/cycle/vimgrep.vim
badd +1 ~/wiki/vim/async.md
badd +1 ~/.vim/plugged/asyncmake/plugin/asyncmake.vim
badd +1 ~/.vim/plugged/asyncmake/autoload/asyncmake.vim
badd +1 ~/Dropbox/vim_plugins/vimrc_grepper.vim
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
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
