let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +224 ~/.vim/plugged/vim-submode/autoload/submode.vim
badd +18 ~/.vim/plugged/vim-schlepp/plugin/schlepp.vim
badd +10 ~/.vim/plugged/vim-schlepp/autoload/schlepp.vim
argglobal
silent! argdel *
set stal=2
edit ~/.vim/plugged/vim-submode/autoload/submode.vim
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
86
normal! zo
115
normal! zo
let s:l = 224 - ((121 * winheight(0) + 6) / 13)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
224
normal! 0
tabedit ~/.vim/plugged/vim-schlepp/plugin/schlepp.vim
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe '1resize ' . ((&lines * 1 + 8) / 16)
exe '2resize ' . ((&lines * 11 + 8) / 16)
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
31
normal! zo
let s:l = 6 - ((3 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
6
normal! 086|
wincmd w
argglobal
if bufexists('~/.vim/plugged/vim-schlepp/autoload/schlepp.vim') | buffer ~/.vim/plugged/vim-schlepp/autoload/schlepp.vim | else | edit ~/.vim/plugged/vim-schlepp/autoload/schlepp.vim | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 15 - ((7 * winheight(0) + 5) / 11)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
15
normal! 0
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 1 + 8) / 16)
exe '2resize ' . ((&lines * 11 + 8) / 16)
tabnext 2
set stal=1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOcFIsW
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
