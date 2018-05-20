" To prevent unintended operation, the following setting is strongly
" recommended to add to your vimrc.
nmap  <unique>  s  <nop>
xmap  <unique>  s  <nop>

" I also disable `s Esc`, to prevent Vim from deleting a character when I cancel `s`.
nno  <unique>  s<esc>  <nop>
xno  <unique>  s<esc>  <esc>


