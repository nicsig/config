" Purpose:{{{
"
" Use this  file to remove a  command which you  never use and pollute  your tab
" completion suggestions.
"}}}

" TODO:{{{
" Find a way to remove the built-in command `:Print`.
" From `:h :Print`:
"
" > Just as ":print".  Was apparently added to Vi for people that keep the shift
" > key pressed too long...
"}}}

" `$VIMRUNTIME/plugin/manpager.vim:5`
if exists(':MANPAGER') == 2
    delc MANPAGER
endif

