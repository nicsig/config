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
tabrewind
edit ~/wiki/awk/awk.md
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
let s:l = 1047 - ((145 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1047
normal! 0
lcd ~/wiki/awk
tabnext
edit ~/Desktop/countries
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
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
let s:l = 2 - ((1 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
normal! 0
lcd ~/.vim
tabnext
edit ~/wiki/anki/anki.md
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
let s:l = 143 - ((2 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
143
normal! 0
lcd ~/wiki/anki
wincmd w
argglobal
if bufexists("~/wiki/anki/glossary.md") | buffer ~/wiki/anki/glossary.md | else | edit ~/wiki/anki/glossary.md | endif
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
let s:l = 1 - ((0 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/wiki/anki
wincmd w
exe '1resize ' . ((&lines * 1 + 16) / 33)
exe '2resize ' . ((&lines * 28 + 16) / 33)
tabnext
edit /tmp/file
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
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
let s:l = 1 - ((0 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 017|
lcd ~/.vim
tabnext
edit ~/wiki/vim/string.md
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
arglocal
%argdel
$argadd ~/wiki/vim/abbrev.md
$argadd ~/wiki/vim/arglist.md
$argadd ~/wiki/vim/array.md
$argadd ~/wiki/vim/async.md
$argadd ~/wiki/vim/autocmd.md
$argadd ~/wiki/vim/blob.md
$argadd ~/wiki/vim/cmdline.md
$argadd ~/wiki/vim/command.md
$argadd ~/wiki/vim/compiler.md
$argadd ~/wiki/vim/complete.md
$argadd ~/wiki/vim/config.md
$argadd ~/wiki/vim/debug.md
$argadd ~/wiki/vim/design.md
$argadd ~/wiki/vim/exception.md
$argadd ~/wiki/vim/filetype_plugin.md
$argadd ~/wiki/vim/folding.md
$argadd ~/wiki/vim/funcref.md
$argadd ~/wiki/vim/highlighting.md
$argadd ~/wiki/vim/install.md
$argadd ~/wiki/vim/layout.md
$argadd ~/wiki/vim/mapping.md
$argadd ~/wiki/vim/package_rtp.md
$argadd ~/wiki/vim/plugin.md
$argadd ~/wiki/vim/qf.md
$argadd ~/wiki/vim/regex.md
$argadd ~/wiki/vim/register.md
$argadd ~/wiki/vim/string.md
$argadd ~/wiki/vim/substitution.md
$argadd ~/wiki/vim/syntax_hl.md
$argadd ~/wiki/vim/tags.md
$argadd ~/wiki/vim/utility.md
$argadd ~/wiki/vim/vim.md
$argadd ~/wiki/vim/vimL.md
if bufexists("~/wiki/vim/string.md") | buffer ~/wiki/vim/string.md | else | edit ~/wiki/vim/string.md | endif
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
654
normal! zo
let s:l = 665 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
665
normal! 034|
lcd ~/wiki/vim
wincmd w
arglocal
%argdel
$argadd ~/wiki/vim/abbrev.md
$argadd ~/wiki/vim/arglist.md
$argadd ~/wiki/vim/array.md
$argadd ~/wiki/vim/async.md
$argadd ~/wiki/vim/autocmd.md
$argadd ~/wiki/vim/blob.md
$argadd ~/wiki/vim/cmdline.md
$argadd ~/wiki/vim/command.md
$argadd ~/wiki/vim/compiler.md
$argadd ~/wiki/vim/complete.md
$argadd ~/wiki/vim/config.md
$argadd ~/wiki/vim/debug.md
$argadd ~/wiki/vim/design.md
$argadd ~/wiki/vim/exception.md
$argadd ~/wiki/vim/filetype_plugin.md
$argadd ~/wiki/vim/folding.md
$argadd ~/wiki/vim/funcref.md
$argadd ~/wiki/vim/highlighting.md
$argadd ~/wiki/vim/install.md
$argadd ~/wiki/vim/layout.md
$argadd ~/wiki/vim/mapping.md
$argadd ~/wiki/vim/package_rtp.md
$argadd ~/wiki/vim/plugin.md
$argadd ~/wiki/vim/qf.md
$argadd ~/wiki/vim/regex.md
$argadd ~/wiki/vim/register.md
$argadd ~/wiki/vim/string.md
$argadd ~/wiki/vim/substitution.md
$argadd ~/wiki/vim/syntax_hl.md
$argadd ~/wiki/vim/tags.md
$argadd ~/wiki/vim/utility.md
$argadd ~/wiki/vim/vim.md
$argadd ~/wiki/vim/vimL.md
if bufexists("~/wiki/.git/index") | buffer ~/wiki/.git/index | else | edit ~/wiki/.git/index | endif
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
lcd ~/wiki/vim
wincmd w
arglocal
%argdel
$argadd ~/wiki/vim/abbrev.md
$argadd ~/wiki/vim/arglist.md
$argadd ~/wiki/vim/array.md
$argadd ~/wiki/vim/async.md
$argadd ~/wiki/vim/autocmd.md
$argadd ~/wiki/vim/blob.md
$argadd ~/wiki/vim/cmdline.md
$argadd ~/wiki/vim/command.md
$argadd ~/wiki/vim/compiler.md
$argadd ~/wiki/vim/complete.md
$argadd ~/wiki/vim/config.md
$argadd ~/wiki/vim/debug.md
$argadd ~/wiki/vim/design.md
$argadd ~/wiki/vim/exception.md
$argadd ~/wiki/vim/filetype_plugin.md
$argadd ~/wiki/vim/folding.md
$argadd ~/wiki/vim/funcref.md
$argadd ~/wiki/vim/highlighting.md
$argadd ~/wiki/vim/install.md
$argadd ~/wiki/vim/layout.md
$argadd ~/wiki/vim/mapping.md
$argadd ~/wiki/vim/package_rtp.md
$argadd ~/wiki/vim/plugin.md
$argadd ~/wiki/vim/qf.md
$argadd ~/wiki/vim/regex.md
$argadd ~/wiki/vim/register.md
$argadd ~/wiki/vim/string.md
$argadd ~/wiki/vim/substitution.md
$argadd ~/wiki/vim/syntax_hl.md
$argadd ~/wiki/vim/tags.md
$argadd ~/wiki/vim/utility.md
$argadd ~/wiki/vim/vim.md
$argadd ~/wiki/vim/vimL.md
if bufexists("~/wiki/.git/COMMIT_EDITMSG") | buffer ~/wiki/.git/COMMIT_EDITMSG | else | edit ~/wiki/.git/COMMIT_EDITMSG | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 1 - ((0 * winheight(0) + 12) / 24)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/wiki/.git
wincmd w
3wincmd w
wincmd =
tabnext 5
set stal=1
badd +1115 ~/wiki/awk/awk.md
badd +2 ~/Desktop/countries
badd +140 ~/wiki/anki/anki.md
badd +1 /tmp/file
badd +13 ~/wiki/anki/glossary.md
badd +0 ~/wiki/vim/string.md
badd +0 ~/wiki/.git/index
badd +0 ~/wiki/.git/COMMIT_EDITMSG
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOacFIsW
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
