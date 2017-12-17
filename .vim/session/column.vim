let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +1 ~/.vim/plugged/vim-column-object/autoload/column_object.vim
badd +8 ~/.vim/plugged/vim-column-object/plugin/column_object.vim
badd +79 ~/.vim/plugged/vim-debug/plugin/debug.vim
badd +329 ~/.vim/plugged/vim-debug/autoload/debug.vim
badd +178 ~/.vim/plugged/vim-cmdline/plugin/cmdline.vim
badd +201 ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim
badd +523 ~/.vim/plugged/vim-readline/autoload/readline.vim
badd +76 ~/.vim/plugged/vim-readline/plugin/readline.vim
badd +109 ~/Dropbox/vim_plugins/vim-qf/autoload/qf/filter.vim
badd +213 ~/.vim/plugged/vim-qf/autoload/qf.vim
badd +64 ~/Dropbox/vim_plugins/vim-qf/autoload/qf.vim
badd +374 ~/.vim/vimrc
badd +71 ~/Dropbox/conf/cheat/l2l
argglobal
silent! argdel *
set stal=2
edit ~/.vim/plugged/vim-column-object/autoload/column_object.vim
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
100
normal! zo
let s:l = 46 - ((3 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
46
normal! 0
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-column-object/plugin/column_object.vim') | buffer ~/.vim/plugged/vim-column-object/plugin/column_object.vim | else | edit ~/.vim/plugged/vim-column-object/plugin/column_object.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 1 - ((0 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabedit ~/.vim/plugged/vim-debug/plugin/debug.vim
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
62
normal! zo
79
normal! zo
79
normal! zc
let s:l = 75 - ((62 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
75
normal! 0
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-debug/autoload/debug.vim') | buffer ~/.vim/plugged/vim-debug/autoload/debug.vim | else | edit ~/.vim/plugged/vim-debug/autoload/debug.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
131
normal! zo
131
normal! zc
316
normal! zo
let s:l = 327 - ((62 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
327
normal! 026|
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabedit ~/.vim/plugged/vim-cmdline/plugin/cmdline.vim
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
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 1 + 16) / 33)
exe '4resize ' . ((&lines * 24 + 16) / 33)
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
6
normal! zo
7
normal! zo
50
normal! zo
128
normal! zo
let s:l = 178 - ((3 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
178
normal! 0
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-cmdline/autoload/cmdline.vim') | buffer ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim | else | edit ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
1
normal! zo
148
normal! zo
211
normal! zo
330
normal! zo
370
normal! zo
let s:l = 201 - ((200 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
201
normal! 069|
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-readline/autoload/readline.vim') | buffer ~/.vim/plugged/vim-readline/autoload/readline.vim | else | edit ~/.vim/plugged/vim-readline/autoload/readline.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
1
normal! zo
1
normal! zc
227
normal! zo
let s:l = 523 - ((522 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
523
normal! 0
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-readline/plugin/readline.vim') | buffer ~/.vim/plugged/vim-readline/plugin/readline.vim | else | edit ~/.vim/plugged/vim-readline/plugin/readline.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
87
normal! zo
88
normal! zo
87
normal! zc
305
normal! zo
305
normal! zc
let s:l = 76 - ((75 * winheight(0) + 12) / 24)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
76
normal! 0
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 1 + 16) / 33)
exe '4resize ' . ((&lines * 24 + 16) / 33)
tabedit ~/Dropbox/vim_plugins/vim-qf/autoload/qf/filter.vim
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
35
normal! zo
103
normal! zo
112
normal! zo
let s:l = 108 - ((3 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
108
normal! 05|
wincmd w
argglobal
if bufexists('~/Dropbox/vim_plugins/vim-qf/autoload/qf.vim') | buffer ~/Dropbox/vim_plugins/vim-qf/autoload/qf.vim | else | edit ~/Dropbox/vim_plugins/vim-qf/autoload/qf.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
80
normal! zo
let s:l = 64 - ((63 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
64
normal! 0
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabedit ~/.vim/plugged/vim-qf/autoload/qf.vim
set splitbelow splitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
196
normal! zo
197
normal! zo
202
normal! zo
259
normal! zo
let s:l = 213 - ((3 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
213
normal! 0
tabedit ~/Dropbox/conf/cheat/l2l
set splitbelow splitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=expr
setlocal fde=markdown#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=1
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 74 - ((17 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
74
normal! 048|
tabedit ~/.vim/vimrc
set splitbelow splitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
27
normal! zo
65
normal! zo
let s:l = 1 - ((0 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
tabnext 7
set stal=1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=1 shortmess=filnxtToOcFIsW
set winminheight=1 winminwidth=1
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
let g:my_session = v:this_session
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
