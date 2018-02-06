let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +1 /tmp/file.dot
badd +584 ~/.vim/plugged/vim-toggle-settings/autoload/toggle_settings.vim
badd +450 ~/.vim/plugged/vim-readline/plugin/readline.vim
badd +98 ~/Dropbox/conf/cheat/graphviz
badd +1153 ~/.vim/plugged/vim-graph/autoload/graph.vim
badd +6501 ~/.vim/vimrc
badd +26 ~/.vim/plugged/vim-tmux-focus-events/plugin/tmux_focus_events.vim
badd +1 ~/.vim/plugged/vim-cmdline/plugin/cmdline.vim
badd +8 ~/.vim/plugged/vim-column-object/plugin/column_object.vim
badd +116 ~/.vim/plugged/vim-cursor/plugin/cursor.vim
badd +49 ~/.vim/plugged/vim-hydra/plugin/hydra.vim
badd +26 ~/.vim/plugged/vim-graph/after/ftplugin/dot.vim
badd +17 ~/.vim/after/ftplugin/help.vim
badd +211 ~/.vim/plugged/vim-cmdline/autoload/cmdline.vim
badd +43 ~/.vim/UltiSnips/vim.snippets
badd +118 ~/.vim/plugged/vim-hydra/autoload/hydra.vim
badd +1 ~/Desktop/show_toc_help.vim
badd +1 ~/.vim/plugged/vim-column-object/autoload/column_object.vim
badd +1 ~/Dropbox/vim_plugins/vim-qf/autoload/qf/filter.vim
badd +95 ~/Dropbox/vim_plugins/vim-qf/autoload/qf.vim
badd +9 ~/Dropbox/vim_plugins/vim-yankring/autoload/yankring.vim
badd +1 /run/user/1000/hydra/head18.vim
badd +4 ~/Desktop/result
badd +49 ~/Desktop/final_analysis.hydra
badd +1 ~/Dropbox/vim_plugins/vim-yankring/plugin/yankring.vim
badd +1 ~/Dropbox/vim_plugins/fastfold.vim
badd +43 ~/.vim/UltiSnips/markdown.snippets
badd +1 /tmp/md.md
badd +53 ~/.vim/UltiSnips/help.snippets
badd +434 ~/.vim/UltiSnips/README.md
badd +1 /tmp/vim.vim
badd +36 ~/Dropbox/conf/cheat/terminal
badd +16 ~/Dropbox/conf/bin/auto-refresh.sh
badd +68 ~/Desktop/compiler.md
badd +1 ~/.vim/plugged/vim-graph/after/compiler/dot.vim
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
let s:l = 5 - ((4 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
5
normal! 0
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabedit ~/.vim/plugged/vim-cmdline/plugin/cmdline.vim
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
let s:l = 211 - ((12 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
211
normal! 070|
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
22
normal! zo
87
normal! zo
94
normal! zo
190
normal! zo
let s:l = 32 - ((14 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
32
normal! 040|
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
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
let s:l = 95 - ((15 * winheight(0) + 14) / 28)
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
let s:l = 65 - ((18 * winheight(0) + 15) / 30)
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
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
silent! normal! zE
let s:l = 323 - ((3 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
323
normal! 0
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
29
normal! zo
let s:l = 63 - ((62 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
63
normal! 023|
wincmd w
argglobal
if bufexists('~/.vim/UltiSnips/markdown.snippets') | buffer ~/.vim/UltiSnips/markdown.snippets | else | edit ~/.vim/UltiSnips/markdown.snippets | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
51
normal! zo
let s:l = 68 - ((67 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
68
normal! 02|
wincmd w
argglobal
if bufexists('/tmp/md.md') | buffer /tmp/md.md | else | edit /tmp/md.md | endif
setlocal fdm=expr
setlocal fde=fold#md#stacked()
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
tabedit ~/.vim/UltiSnips/README.md
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
setlocal fdm=expr
setlocal fde=fold#md#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
170
normal! zo
332
normal! zo
568
normal! zo
let s:l = 450 - ((12 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
450
normal! 0
wincmd w
argglobal
if bufexists('~/.vim/UltiSnips/vim.snippets') | buffer ~/.vim/UltiSnips/vim.snippets | else | edit ~/.vim/UltiSnips/vim.snippets | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
86
normal! zo
201
normal! zo
288
normal! zo
let s:l = 9 - ((8 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
9
normal! 09|
wincmd w
argglobal
if bufexists('/tmp/vim.vim') | buffer /tmp/vim.vim | else | edit /tmp/vim.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 1 - ((0 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
tabedit ~/.vim/vimrc
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
27
normal! zo
65
normal! zo
77
normal! zo
93
normal! zo
109
normal! zo
148
normal! zo
159
normal! zo
161
normal! zo
263
normal! zo
267
normal! zo
277
normal! zo
307
normal! zo
358
normal! zo
407
normal! zo
431
normal! zo
445
normal! zo
493
normal! zo
507
normal! zo
526
normal! zo
545
normal! zo
546
normal! zo
547
normal! zo
575
normal! zo
663
normal! zo
669
normal! zo
680
normal! zo
695
normal! zo
715
normal! zo
717
normal! zo
735
normal! zo
749
normal! zo
780
normal! zo
806
normal! zo
847
normal! zo
899
normal! zo
928
normal! zo
949
normal! zo
954
normal! zo
965
normal! zo
971
normal! zo
980
normal! zo
992
normal! zo
1002
normal! zo
1082
normal! zo
1126
normal! zo
1132
normal! zo
1137
normal! zo
1148
normal! zo
1156
normal! zo
1207
normal! zo
1230
normal! zo
1235
normal! zo
1240
normal! zo
1241
normal! zo
1247
normal! zo
1257
normal! zo
1265
normal! zo
1276
normal! zo
1302
normal! zo
1309
normal! zo
1321
normal! zo
1327
normal! zo
1335
normal! zo
1351
normal! zo
1363
normal! zo
1403
normal! zo
1415
normal! zo
1426
normal! zo
1427
normal! zo
1433
normal! zo
1441
normal! zo
1446
normal! zo
1468
normal! zo
1491
normal! zo
1500
normal! zo
1509
normal! zo
1557
normal! zo
1627
normal! zo
1638
normal! zo
1691
normal! zo
1710
normal! zo
1771
normal! zo
1809
normal! zo
1822
normal! zo
1832
normal! zo
1875
normal! zo
1898
normal! zo
1905
normal! zo
1931
normal! zo
1932
normal! zo
1989
normal! zo
2038
normal! zo
2058
normal! zo
2059
normal! zo
2063
normal! zo
2067
normal! zo
2091
normal! zo
2113
normal! zo
2119
normal! zo
2120
normal! zo
2146
normal! zo
2189
normal! zo
2193
normal! zo
2200
normal! zo
2225
normal! zo
2233
normal! zo
2234
normal! zo
2247
normal! zo
2253
normal! zo
2290
normal! zo
2320
normal! zo
2340
normal! zo
2354
normal! zo
2368
normal! zo
2392
normal! zo
2393
normal! zo
2394
normal! zo
2429
normal! zo
2450
normal! zo
2462
normal! zo
2508
normal! zo
2587
normal! zo
2597
normal! zo
2607
normal! zo
2611
normal! zo
2616
normal! zo
2617
normal! zo
2631
normal! zo
2644
normal! zo
2645
normal! zo
2650
normal! zo
2658
normal! zo
2666
normal! zo
2667
normal! zo
2711
normal! zo
2712
normal! zo
2717
normal! zo
2722
normal! zo
2729
normal! zo
2751
normal! zo
2759
normal! zo
2767
normal! zo
2783
normal! zo
2791
normal! zo
2833
normal! zo
2860
normal! zo
2890
normal! zo
2894
normal! zo
2908
normal! zo
2909
normal! zo
2935
normal! zo
2940
normal! zo
2985
normal! zo
2986
normal! zo
3003
normal! zo
3008
normal! zo
3025
normal! zo
3059
normal! zo
3064
normal! zo
3065
normal! zo
3075
normal! zo
3088
normal! zo
3120
normal! zo
3125
normal! zo
3126
normal! zo
3137
normal! zo
3150
normal! zo
3154
normal! zo
3159
normal! zo
3163
normal! zo
3164
normal! zo
3170
normal! zo
3185
normal! zo
3186
normal! zo
3211
normal! zo
3236
normal! zo
3248
normal! zo
3266
normal! zo
3310
normal! zo
3314
normal! zo
3319
normal! zo
3332
normal! zo
3337
normal! zo
3342
normal! zo
3355
normal! zo
3375
normal! zo
3393
normal! zo
3398
normal! zo
3404
normal! zo
3411
normal! zo
3454
normal! zo
3463
normal! zo
3481
normal! zo
3496
normal! zo
3516
normal! zo
3582
normal! zo
3589
normal! zo
3604
normal! zo
3620
normal! zo
3648
normal! zo
3649
normal! zo
3651
normal! zo
3668
normal! zo
3673
normal! zo
3692
normal! zo
3732
normal! zo
3741
normal! zo
3766
normal! zo
3786
normal! zo
3797
normal! zo
3817
normal! zo
3829
normal! zo
3830
normal! zo
3842
normal! zo
3847
normal! zo
3874
normal! zo
3931
normal! zo
3945
normal! zo
3950
normal! zo
3958
normal! zo
3965
normal! zo
3992
normal! zo
4175
normal! zo
4175
normal! zc
4262
normal! zo
4262
normal! zc
4305
normal! zo
4305
normal! zc
3992
normal! zc
4555
normal! zo
4710
normal! zo
4710
normal! zc
4762
normal! zo
4762
normal! zc
4964
normal! zo
4964
normal! zc
4555
normal! zc
5221
normal! zo
5221
normal! zc
let s:l = 73 - ((3 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
73
normal! 025|
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-cursor/plugin/cursor.vim') | buffer ~/.vim/plugged/vim-cursor/plugin/cursor.vim | else | edit ~/.vim/plugged/vim-cursor/plugin/cursor.vim | endif
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
100
normal! zc
let s:l = 2 - ((1 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
normal! 07|
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-tmux-focus-events/plugin/tmux_focus_events.vim') | buffer ~/.vim/plugged/vim-tmux-focus-events/plugin/tmux_focus_events.vim | else | edit ~/.vim/plugged/vim-tmux-focus-events/plugin/tmux_focus_events.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 16 - ((15 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
16
normal! 05|
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
tabedit ~/.vim/plugged/vim-toggle-settings/autoload/toggle_settings.vim
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
496
normal! zo
529
normal! zo
let s:l = 530 - ((526 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
530
normal! 0
wincmd w
argglobal
if bufexists('~/Dropbox/conf/cheat/terminal') | buffer ~/Dropbox/conf/cheat/terminal | else | edit ~/Dropbox/conf/cheat/terminal | endif
setlocal fdm=expr
setlocal fde=fold#md#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
1
normal! zo
let s:l = 36 - ((27 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
36
normal! 020|
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabedit ~/Dropbox/conf/bin/auto-refresh.sh
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
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 12 - ((11 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
12
normal! 030|
wincmd w
argglobal
if bufexists('/tmp/file.dot') | buffer /tmp/file.dot | else | edit /tmp/file.dot | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 1 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
argglobal
if bufexists('~/Dropbox/conf/cheat/graphviz') | buffer ~/Dropbox/conf/cheat/graphviz | else | edit ~/Dropbox/conf/cheat/graphviz | endif
setlocal fdm=expr
setlocal fde=fold#md#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
83
normal! zo
let s:l = 98 - ((97 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
98
normal! 0
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
tabedit ~/.vim/plugged/vim-graph/after/ftplugin/dot.vim
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
exe '2resize ' . ((&lines * 26 + 16) / 33)
exe '3resize ' . ((&lines * 1 + 16) / 33)
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
15
normal! zo
let s:l = 26 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
26
normal! 0
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-graph/after/compiler/dot.vim') | buffer ~/.vim/plugged/vim-graph/after/compiler/dot.vim | else | edit ~/.vim/plugged/vim-graph/after/compiler/dot.vim | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 1 - ((0 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-graph/autoload/graph.vim') | buffer ~/.vim/plugged/vim-graph/autoload/graph.vim | else | edit ~/.vim/plugged/vim-graph/autoload/graph.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
1143
normal! zo
let s:l = 1153 - ((31 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1153
normal! 025|
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 26 + 16) / 33)
exe '3resize ' . ((&lines * 1 + 16) / 33)
tabedit ~/Desktop/compiler.md
set splitbelow splitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=expr
setlocal fde=fold#md#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 66 - ((14 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
66
normal! 0
tabnext 13
set stal=1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=1 shortmess=filnxtToOAacFIsW
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
