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
badd +1 ~/Dropbox/vim_plugins/vim-qf/autoload/qf/filter.vim
badd +8 ~/.vim/plugged/vim-column-object/plugin/column_object.vim
badd +1 ~/.vim/plugged/vim-cmdline/plugin/cmdline.vim
badd +95 ~/Dropbox/vim_plugins/vim-qf/autoload/qf.vim
badd +9 ~/Dropbox/vim_plugins/vim-yankring/autoload/yankring.vim
badd +118 ~/.vim/plugged/vim-hydra/autoload/hydra.vim
badd +1 /run/user/1000/hydra/head18.vim
badd +17 ~/.vim/after/ftplugin/help.vim
badd +302 ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim
badd +250 ~/.vim/plugged/vim-readline/autoload/readline.vim
badd +4 ~/Desktop/result
badd +49 ~/Desktop/final_analysis.hydra
badd +49 ~/.vim/plugged/vim-hydra/plugin/hydra.vim
badd +1 ~/Dropbox/vim_plugins/vim-yankring/plugin/yankring.vim
badd +1 ~/Dropbox/vim_plugins/fastfold.vim
badd +1 ~/Desktop/show_toc_help.vim
badd +1 fugitive:///home/jean/.vim/plugged/vim-cmdline/.git//047a32664392868454f4538a689c5c782b93884d/plugin/cmdline.vim
badd +55 ~/.vim/UltiSnips/help.snippets
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
let s:l = 6 - ((5 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
6
normal! 06|
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
126
normal! zo
let s:l = 176 - ((3 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
176
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
8
normal! zo
26
normal! zo
75
normal! zo
110
normal! zo
158
normal! zo
168
normal! zo
179
normal! zo
183
normal! zo
194
normal! zo
221
normal! zo
230
normal! zo
252
normal! zo
258
normal! zo
275
normal! zo
279
normal! zo
286
normal! zo
296
normal! zo
314
normal! zo
let s:l = 211 - ((11 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
211
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
6
normal! zo
6
normal! zc
232
normal! zo
let s:l = 528 - ((525 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
528
normal! 0
wincmd w
argglobal
if bufexists('fugitive:///home/jean/.vim/plugged/vim-cmdline/.git//047a32664392868454f4538a689c5c782b93884d/plugin/cmdline.vim') | buffer fugitive:///home/jean/.vim/plugged/vim-cmdline/.git//047a32664392868454f4538a689c5c782b93884d/plugin/cmdline.vim | else | edit fugitive:///home/jean/.vim/plugged/vim-cmdline/.git//047a32664392868454f4538a689c5c782b93884d/plugin/cmdline.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 1 - ((0 * winheight(0) + 12) / 24)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
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
let s:l = 39 - ((38 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
39
normal! 0
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
let s:l = 95 - ((94 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
95
normal! 0
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabedit ~/Dropbox/vim_plugins/vim-yankring/plugin/yankring.vim
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
6
normal! zo
12
normal! zo
let s:l = 22 - ((3 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
22
normal! 0
wincmd w
argglobal
if bufexists('~/Dropbox/vim_plugins/vim-yankring/autoload/yankring.vim') | buffer ~/Dropbox/vim_plugins/vim-yankring/autoload/yankring.vim | else | edit ~/Dropbox/vim_plugins/vim-yankring/autoload/yankring.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
11
normal! zo
let s:l = 1 - ((0 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabedit ~/.vim/plugged/vim-hydra/autoload/hydra.vim
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
let s:l = 244 - ((239 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
244
normal! 0
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-hydra/plugin/hydra.vim') | buffer ~/.vim/plugged/vim-hydra/plugin/hydra.vim | else | edit ~/.vim/plugged/vim-hydra/plugin/hydra.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 49 - ((48 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
49
normal! 0
wincmd w
argglobal
if bufexists('~/Dropbox/vim_plugins/fastfold.vim') | buffer ~/Dropbox/vim_plugins/fastfold.vim | else | edit ~/Dropbox/vim_plugins/fastfold.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
argglobal
if bufexists('~/Desktop/result') | buffer ~/Desktop/result | else | edit ~/Desktop/result | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 4 - ((3 * winheight(0) + 12) / 24)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4
normal! 0
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 1 + 16) / 33)
exe '4resize ' . ((&lines * 24 + 16) / 33)
tabedit /run/user/1000/hydra/head18.vim
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 89 + 59) / 119)
exe 'vert 2resize ' . ((&columns * 29 + 59) / 119)
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 1 - ((0 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
argglobal
if bufexists('~/Desktop/final_analysis.hydra') | buffer ~/Desktop/final_analysis.hydra | else | edit ~/Desktop/final_analysis.hydra | endif
setlocal fdm=expr
setlocal fde=fold#md#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
47
normal! zo
62
normal! zo
let s:l = 65 - ((28 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
65
normal! 0
wincmd w
exe 'vert 1resize ' . ((&columns * 89 + 59) / 119)
exe 'vert 2resize ' . ((&columns * 29 + 59) / 119)
tabedit ~/Desktop/show_toc_help.vim
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
let s:l = 130 - ((38 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
130
normal! 0
wincmd w
argglobal
if bufexists('~/.vim/after/ftplugin/help.vim') | buffer ~/.vim/after/ftplugin/help.vim | else | edit ~/.vim/after/ftplugin/help.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
21
normal! zo
let s:l = 19 - ((18 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
19
normal! 02|
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabedit ~/.vim/plugged/vim-lg-lib/doc/lg.txt
set splitbelow splitright
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
2wincmd k
wincmd w
wincmd w
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
silent! normal! zE
let s:l = 18 - ((12 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
18
normal! 020|
wincmd w
argglobal
if bufexists('~/.vim/UltiSnips/help.snippets') | buffer ~/.vim/UltiSnips/help.snippets | else | edit ~/.vim/UltiSnips/help.snippets | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
13
normal! zo
let s:l = 53 - ((35 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
53
normal! 0
wincmd w
argglobal
if bufexists('~/.vim/plugged/ultisnips/doc/UltiSnips.txt') | buffer ~/.vim/plugged/ultisnips/doc/UltiSnips.txt | else | edit ~/.vim/plugged/ultisnips/doc/UltiSnips.txt | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
silent! normal! zE
let s:l = 1684 - ((12 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1684
normal! 016|
wincmd w
3wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
tabnext 8
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
