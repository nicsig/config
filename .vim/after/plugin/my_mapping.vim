" By default, vim-sneak binds `\` to the same function which is bound to `,`:
"
"     repeat previous `fx`, `sxy` motion
"
" It does this for normal, visual and operator-pending mode.
"
" I find this annoying, because when I hit the key by accident, the cursor jumps.
" Besides, we already have `,` so no need of a second key `\`.

if maparg('\') =~ '\csneak'
    unmap \
endif
" If we map  something to `\`, or use  it as a prefix to  build several `{lhs}`,
" `vim-sneak` won't install these mappings, so we could eliminate `unmap \`.


" We want Vim to automatically write a changed buffer before we hide it to
" open a Dirvish buffer.
nmap          --                         <plug>(my_dirvish_update)<plug>(dirvish_up)
nno <silent>  <plug>(my_dirvish_update)  :<c-u>sil! update<cr>
