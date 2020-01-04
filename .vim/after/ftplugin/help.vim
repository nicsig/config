" TODO: Move the `notes` and `galore` files into markdown files.

fu s:snr()
    return matchstr(expand('<sfile>'), '.*\zs<SNR>\d\+_')
endfu
let s:snr = get(s:, 'snr', s:snr())

if expand('%:p') =~# $HOME..'/.vim/doc/misc/\%(notes\|galore\)'
    setl fdm=expr
    let &l:fdt = s:snr..'fold_text()'
    let &l:fde = s:snr..'fold_expr()'
endif

fu s:fold_expr() abort "{{{1
    return getline(v:lnum) =~# '^=\+$' ? '>1' : '='
endfu

fu s:fold_text() abort "{{{1
    return getline(nextnonblank(v:foldstart+1))
endfu

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ ..'| setl fde< fdm< fdt<'

