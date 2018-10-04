let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +108 ~/Desktop/backup.md
badd +1 ~/.vim/doc/misc/galore
argglobal
silent! argdel *
edit ~/.vim/doc/misc/galore
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
exe '1resize ' . ((&lines * 1 + 8) / 16)
exe '2resize ' . ((&lines * 1 + 8) / 16)
exe '3resize ' . ((&lines * 10 + 8) / 16)
argglobal
setlocal fdm=expr
setlocal fde=<SNR>147_fold_expr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 166 - ((3 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
166
normal! 0
wincmd w
argglobal
if bufexists('~/Desktop/backup.md') | buffer ~/Desktop/backup.md | else | edit ~/Desktop/backup.md | endif
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 203 - ((9 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
203
normal! 0
wincmd w
argglobal
if bufexists('/usr/share/vim/vim80/doc/options.txt') | buffer /usr/share/vim/vim80/doc/options.txt | else | edit /usr/share/vim/vim80/doc/options.txt | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
silent! normal! zE
let s:l = 423 - ((5 * winheight(0) + 5) / 10)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
423
normal! 0
wincmd w
3wincmd w
exe '1resize ' . ((&lines * 1 + 8) / 16)
exe '2resize ' . ((&lines * 1 + 8) / 16)
exe '3resize ' . ((&lines * 10 + 8) / 16)
tabnext 1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOAacFIsW
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
