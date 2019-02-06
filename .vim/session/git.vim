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
badd +53 ~/.vim/plugged/vim-lg-lib/autoload/lg/styled_comment.vim
badd +17 ~/.vim/plugged/asyncmake/autoload/asyncmake.vim
badd +762 ~/wiki/vim/highlighting.md
badd +1393 ~/wiki/vim/qf.md
badd +816 ~/wiki/vim/syntax_hl.md
badd +60 ~/wiki/vim/async.md
badd +761 ~/wiki/vim/funcref.md
badd +750 ~/.vim/plugged/vim-markdown/syntax/markdown.vim
badd +8 ~/.vim/plugged/vim-vim/after/syntax/vim.vim
badd +15 ~/wiki/git.md
badd +1 ~/Desktop/test.vim
badd +47 /usr/local/share/vim/vim81/colors/README.txt
badd +143 ~/wiki/awk/awk.md
badd +360 ~/.vim/autoload/colorscheme.vim
badd +0 ~/.vim/plugged/vim-markdown/.git/index
badd +0 ~/.vim/plugged/vim-markdown/.git/COMMIT_EDITMSG
argglobal
%argdel
set stal=2
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
let s:l = 15 - ((6 * winheight(0) + 15) / 30)
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
47
normal! zo
48
normal! zo
59
normal! zo
69
normal! zo
110
normal! zo
313
normal! zo
let s:l = 53 - ((3 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
53
normal! 054|
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
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 816 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
816
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
198
normal! zo
239
normal! zo
729
normal! zo
let s:l = 750 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
750
normal! 053|
lcd ~/.vim/plugged/vim-markdown
wincmd w
argglobal
if bufexists('~/.vim/autoload/colorscheme.vim') | buffer ~/.vim/autoload/colorscheme.vim | else | edit ~/.vim/autoload/colorscheme.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
137
normal! zo
245
normal! zo
let s:l = 304 - ((3 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
304
normal! 047|
lcd ~/.vim
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 26 + 16) / 33)
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
let s:l = 762 - ((226 * winheight(0) + 14) / 28)
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
let s:l = 140 - ((2 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
140
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
10
normal! zc
let s:l = 17 - ((7 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
17
normal! 0
lcd ~/.vim/plugged/asyncmake
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
let s:l = 1393 - ((187 * winheight(0) + 12) / 24)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1393
normal! 0
lcd ~/wiki/vim
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe '3resize ' . ((&lines * 1 + 16) / 33)
exe '4resize ' . ((&lines * 24 + 16) / 33)
tabnext
edit ~/wiki/awk/awk.md
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
wincmd =
argglobal
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
143
normal! zo
let s:l = 145 - ((35 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
145
normal! 022|
lcd ~/wiki/awk
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-markdown/.git/index') | buffer ~/.vim/plugged/vim-markdown/.git/index | else | edit ~/.vim/plugged/vim-markdown/.git/index | endif
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=1
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 5 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
5
normal! 0
lcd ~/.vim/plugged/vim-markdown
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-markdown/.git/COMMIT_EDITMSG') | buffer ~/.vim/plugged/vim-markdown/.git/COMMIT_EDITMSG | else | edit ~/.vim/plugged/vim-markdown/.git/COMMIT_EDITMSG | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 1 - ((0 * winheight(0) + 11) / 22)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.vim/plugged/vim-markdown/.git
wincmd w
3wincmd w
wincmd =
tabnext 6
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
