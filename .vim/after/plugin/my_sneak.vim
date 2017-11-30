" Vim-sneak default mappings are too inconsistent to be memorized.
" They also conflict with `vim-sandwich`.


" Command to  find the  mappings installed  by vim-sneak  in normal  mode,
" whose {lhs} can be typed by the user, ignoring  fFtT,;
" We ignore the latter because, contrary to s, S, z, Z, they ARE consistent.
"
"     put =filter(split(execute('nno'), '\n'), { k,v -> v =~? 'sneak' && v !~? '^n\s\+\%([ft,;]\\|<plug>\)' })
sil! nunmap s
sil! nunmap S

"     put =filter(split(execute('xno'), '\n'), { k,v -> v =~? 'sneak' && v !~? '^x\s\+\%([ft,;]\\|<plug>\)' })
sil! xunmap s
sil! xunmap Z

"     put =filter(split(execute('ono'), '\n'), { k,v -> v =~? 'sneak' && v !~? '^o\s\+\%([ft,;]\\|<plug>\)' })
sil! ounmap z
sil! ounmap Z
