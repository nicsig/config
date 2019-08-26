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
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
silent! normal! zE
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
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
3266
normal! zo
let s:l = 4507 - ((1184 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4507
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
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
958
normal! zo
let s:l = 963 - ((83 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
963
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
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 2 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
normal! 0
lcd ~/wiki/man
wincmd w
arglocal
%argdel
if bufexists("~/wiki/man/man.md") | buffer ~/wiki/man/man.md | else | edit ~/wiki/man/man.md | endif
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
23
normal! zo
24
normal! zo
277
normal! zo
421
normal! zo
466
normal! zo
let s:l = 31 - ((25 * winheight(0) + 14) / 28)
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
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
38
normal! zo
39
normal! zo
58
normal! zo
101
normal! zo
152
normal! zo
179
normal! zo
192
normal! zo
192
normal! zc
let s:l = 173 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
173
normal! 0
lcd ~/.vim/plugged/vim-cmdline
wincmd w
arglocal
%argdel
if bufexists("~/Dropbox/vim_plugins/vimrc_grepper.vim") | buffer ~/Dropbox/vim_plugins/vimrc_grepper.vim | else | edit ~/Dropbox/vim_plugins/vimrc_grepper.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
4
normal! zo
50
normal! zo
83
normal! zo
50
normal! zc
149
normal! zo
let s:l = 153 - ((0 * winheight(0) + 0) / 1)
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
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
71
normal! zo
197
normal! zo
let s:l = 104 - ((23 * winheight(0) + 13) / 27)
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
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 155 - ((149 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
155
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
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
6
normal! zo
let s:l = 12 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
12
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/.config/st/patches/01_custom_config.diff") | buffer ~/.config/st/patches/01_custom_config.diff | else | edit ~/.config/st/patches/01_custom_config.diff | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
silent! normal! zE
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
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
445
normal! zo
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
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
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
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 408 - ((407 * winheight(0) + 14) / 28)
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
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
892
normal! zo
let s:l = 892 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
892
normal! 0
lcd ~/wiki/tmux
wincmd w
arglocal
%argdel
if bufexists("~/wiki/tmux/format.md") | buffer ~/wiki/tmux/format.md | else | edit ~/wiki/tmux/format.md | endif
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 1280 - ((289 * winheight(0) + 14) / 28)
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
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
88
normal! zo
88
normal! zc
110
normal! zo
110
normal! zc
119
normal! zo
119
normal! zc
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
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
291
normal! zo
let s:l = 293 - ((0 * winheight(0) + 0) / 1)
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
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
581
normal! zo
let s:l = 612 - ((23 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
612
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
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
151
normal! zo
194
normal! zo
let s:l = 192 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
192
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/Desktop/ask.md") | buffer ~/Desktop/ask.md | else | edit ~/Desktop/ask.md | endif
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
1
normal! zo
let s:l = 118 - ((12 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
118
normal! 0
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext
edit ~/wiki/shell/job.md
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
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
93
normal! zo
407
normal! zo
431
normal! zo
let s:l = 171 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
171
normal! 0
lcd ~/wiki/shell
wincmd w
arglocal
%argdel
if bufexists("~/wiki/shell/process.md") | buffer ~/wiki/shell/process.md | else | edit ~/wiki/shell/process.md | endif
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
291
normal! zo
1107
normal! zo
1124
normal! zo
1170
normal! zo
1176
normal! zo
1670
normal! zo
let s:l = 1680 - ((33 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1680
normal! 0
lcd ~/wiki/shell
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
arglocal
%argdel
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
339
normal! zo
1898
normal! zo
1899
normal! zo
2876
normal! zo
3176
normal! zo
3524
normal! zo
3525
normal! zo
7169
normal! zo
let s:l = 8757 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
8757
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/.vim/autoload/myfuncs.vim") | buffer ~/.vim/autoload/myfuncs.vim | else | edit ~/.vim/autoload/myfuncs.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
870
normal! zo
979
normal! zo
let s:l = 1070 - ((13 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1070
normal! 0
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
arglocal
%argdel
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
28
normal! zo
115
normal! zo
154
normal! zo
195
normal! zo
339
normal! zo
471
normal! zo
476
normal! zo
1762
normal! zo
1898
normal! zo
1911
normal! zo
2140
normal! zo
2376
normal! zo
2388
normal! zo
2496
normal! zo
2574
normal! zo
2624
normal! zo
2778
normal! zo
let s:l = 2820 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2820
normal! 0
lcd ~/.vim
wincmd w
arglocal
%argdel
if bufexists("~/.vim/plugged/vim-readline/plugin/readline.vim") | buffer ~/.vim/plugged/vim-readline/plugin/readline.vim | else | edit ~/.vim/plugged/vim-readline/plugin/readline.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
105
normal! zo
300
normal! zo
352
normal! zo
let s:l = 373 - ((17 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
373
normal! 028|
lcd ~/.vim/plugged/vim-readline
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext 13
set stal=1
badd +1 ~/Desktop/countries
badd +963 ~/wiki/awk/sed.md
badd +2 ~/wiki/man/examples/pathfind.1
badd +173 ~/.vim/plugged/vim-cmdline/autoload/cmdline/cycle/vimgrep.vim
badd +155 ~/wiki/st.md
badd +12 ~/.config/st/patches/README.md
badd +1 ~/bin/upp.sh
badd +892 ~/wiki/tmux/command.md
badd +1 ~/bin/yank
badd +192 ~/Desktop/session.md
badd +171 ~/wiki/shell/job.md
badd +2820 ~/.vim/vimrc
badd +4507 ~/wiki/awk/awk.md
badd +31 ~/wiki/man/man.md
badd +153 ~/Dropbox/vim_plugins/vimrc_grepper.vim
badd +104 ~/wiki/vim/async.md
badd +33 ~/.config/st/patches/01_custom_config.diff
badd +293 ~/.Xresources
badd +408 ~/wiki/vim/install.md
badd +1280 ~/wiki/tmux/format.md
badd +612 ~/wiki/terminal/capabilities.md
badd +118 ~/Desktop/ask.md
badd +1680 ~/wiki/shell/process.md
badd +1070 ~/.vim/autoload/myfuncs.vim
badd +373 ~/.vim/plugged/vim-readline/plugin/readline.vim
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
