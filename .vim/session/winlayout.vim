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
" badd +1 ~/.bashrc
" badd +61 ~/.shrc
" badd +1812 ~/.zshrc
" badd +1 ~/.config/tmux/tmux.conf
" badd +53 ~/Desktop/ask.md
" badd +1 /tmp/vimrc
" badd +0 ~/Desktop/winlayout.md
argglobal
silent! argdel *
set stal=2
tabnew
tabnext -1
edit ~/.bashrc
set splitbelow splitright
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
3wincmd h
wincmd w
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd w
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 29 + 59) / 119)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 2resize ' . ((&columns * 29 + 59) / 119)
exe '3resize ' . ((&lines * 28 + 16) / 33)
exe 'vert 3resize ' . ((&columns * 29 + 59) / 119)
exe '4resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 4resize ' . ((&columns * 29 + 59) / 119)
exe '5resize ' . ((&lines * 28 + 16) / 33)
exe 'vert 5resize ' . ((&columns * 29 + 59) / 119)
exe 'vert 6resize ' . ((&columns * 29 + 59) / 119)
arglocal
silent! argdel *
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 59 - ((18 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
59
normal! 0
wincmd w
arglocal
silent! argdel *
if bufexists('~/.shrc') | buffer ~/.shrc | else | edit ~/.shrc | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 61 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
61
normal! 018|
wincmd w
arglocal
silent! argdel *
if bufexists('~/.zshrc') | buffer ~/.zshrc | else | edit ~/.zshrc | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
1899
normal! zo
2347
normal! zo
2435
normal! zo
let s:l = 2437 - ((50 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2437
normal! 02|
wincmd w
arglocal
silent! argdel *
if bufexists('~/.config/tmux/tmux.conf') | buffer ~/.config/tmux/tmux.conf | else | edit ~/.config/tmux/tmux.conf | endif
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
wincmd w
arglocal
silent! argdel *
if bufexists('~/Desktop/ask.md') | buffer ~/Desktop/ask.md | else | edit ~/Desktop/ask.md | endif
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 53 - ((52 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
53
normal! 0
wincmd w
arglocal
silent! argdel *
if bufexists('/tmp/vimrc') | buffer /tmp/vimrc | else | edit /tmp/vimrc | endif
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 1 - ((0 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
exe 'vert 1resize ' . ((&columns * 29 + 59) / 119)
exe '2resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 2resize ' . ((&columns * 29 + 59) / 119)
exe '3resize ' . ((&lines * 28 + 16) / 33)
exe 'vert 3resize ' . ((&columns * 29 + 59) / 119)
exe '4resize ' . ((&lines * 1 + 16) / 33)
exe 'vert 4resize ' . ((&columns * 29 + 59) / 119)
exe '5resize ' . ((&lines * 28 + 16) / 33)
exe 'vert 5resize ' . ((&columns * 29 + 59) / 119)
exe 'vert 6resize ' . ((&columns * 29 + 59) / 119)
tabnext
edit ~/Desktop/winlayout.md
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
arglocal
silent! argdel *
setlocal fdm=expr
setlocal fde=fold#md#fde#stacked()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=0
setlocal fdn=20
setlocal fen
let s:l = 78 - ((77 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
78
normal! 01|
tabnext 2
set stal=1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
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
let g:my_session = v:this_session
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
