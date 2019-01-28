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
badd +26 ~/.vim/plugged/asyncmake/autoload/asyncmake.vim
badd +762 ~/wiki/vim/highlighting.md
badd +1103 ~/wiki/vim/qf.md
badd +1850 ~/wiki/vim/syntax_hl.md
badd +149 ~/wiki/vim/async.md
badd +761 ~/wiki/vim/funcref.md
badd +505 ~/.vim/plugged/vim-lg-lib/autoload/lg/styled_comment.vim
badd +590 ~/.vim/plugged/vim-markdown/syntax/markdown.vim
badd +8 ~/.vim/plugged/vim-vim/after/syntax/vim.vim
badd +15 ~/wiki/git.md
badd +1 ~/Desktop/test.vim
badd +47 /usr/local/share/vim/vim81/colors/README.txt
badd +158 ~/.vim/plugged/vim-fex/autoload/fex/tree.vim
badd +0 ~/.vim/plugged/vim-man/autoload/man.vim
argglobal
%argdel
set stal=2
tabnew
tabnew
tabnew
tabnew
tabnew
tabnew
tabrewind
edit ~/wiki/git.md
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
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
let s:l = 15 - ((14 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
15
normal! 0
lcd ~/wiki
tabnext
edit ~/.vim/plugged/vim-vim/after/syntax/vim.vim
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
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 8 - ((6 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
8
normal! 0
lcd ~/.vim/plugged/vim-vim
wincmd w
argglobal
if bufexists('~/Desktop/test.vim') | buffer ~/Desktop/test.vim | else | edit ~/Desktop/test.vim | endif
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
argglobal
if bufexists('~/.vim/plugged/vim-lg-lib/autoload/lg/styled_comment.vim') | buffer ~/.vim/plugged/vim-lg-lib/autoload/lg/styled_comment.vim | else | edit ~/.vim/plugged/vim-lg-lib/autoload/lg/styled_comment.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
69
normal! zo
110
normal! zo
313
normal! zo
let s:l = 505 - ((183 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
505
normal! 0
lcd ~/.vim/plugged/vim-lg-lib
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
tabnext
edit ~/wiki/vim/syntax_hl.md
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
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 1850 - ((12 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1850
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-markdown/syntax/markdown.vim') | buffer ~/.vim/plugged/vim-markdown/syntax/markdown.vim | else | edit ~/.vim/plugged/vim-markdown/syntax/markdown.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 590 - ((24 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
590
normal! 0
lcd ~/.vim/plugged/vim-markdown
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext
edit /usr/local/share/vim/vim81/colors/README.txt
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
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 47 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
47
normal! 0
lcd ~/.vim
wincmd w
argglobal
if bufexists('~/wiki/vim/highlighting.md') | buffer ~/wiki/vim/highlighting.md | else | edit ~/wiki/vim/highlighting.md | endif
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 762 - ((341 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
762
normal! 0
lcd ~/wiki/vim
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext
edit ~/wiki/vim/async.md
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
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 1 + 16) / 33)
exe '4resize ' . ((&lines * 24 + 16) / 33)
argglobal
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 149 - ((22 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
149
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists('~/wiki/vim/funcref.md') | buffer ~/wiki/vim/funcref.md | else | edit ~/wiki/vim/funcref.md | endif
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 761 - ((7 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
761
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists('~/wiki/vim/qf.md') | buffer ~/wiki/vim/qf.md | else | edit ~/wiki/vim/qf.md | endif
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
1651
normal! zo
let s:l = 1103 - ((2 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1103
normal! 0
lcd ~/wiki/vim
wincmd w
argglobal
if bufexists('~/.vim/plugged/asyncmake/autoload/asyncmake.vim') | buffer ~/.vim/plugged/asyncmake/autoload/asyncmake.vim | else | edit ~/.vim/plugged/asyncmake/autoload/asyncmake.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
10
normal! zo
let s:l = 40 - ((8 * winheight(0) + 12) / 24)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
40
normal! 0
lcd ~/.vim/plugged/asyncmake
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 1 + 16) / 33)
exe '4resize ' . ((&lines * 24 + 16) / 33)
tabnext
edit ~/.vim/plugged/vim-man/autoload/man.vim
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
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
19
normal! zo
19
normal! zc
let s:l = 19 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
19
normal! 0
lcd ~/.vim/plugged/vim-man
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-fex/autoload/fex/tree.vim') | buffer ~/.vim/plugged/vim-fex/autoload/fex/tree.vim | else | edit ~/.vim/plugged/vim-fex/autoload/fex/tree.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
158
normal! zo
186
normal! zo
let s:l = 187 - ((29 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
187
normal! 0
lcd ~/.vim/plugged/vim-fex
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
tabnext 7
set stal=1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=1 shortmess=filnxtToOacFIsW
set winminheight=1 winminwidth=1
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
