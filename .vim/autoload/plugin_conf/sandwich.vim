" To prevent unintended operation, the following setting is strongly
" recommended to add to your vimrc.
nmap  s  <nop>
xmap  s  <nop>

" I also disable `s Esc`, to prevent Vim from deleting a character when I cancel `s`.
nno  s<esc>  <nop>
xno  s<esc>  <esc>


