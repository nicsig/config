" TODO: Move the `notes` and `galore` files into markdown files.

fu s:fold_expr() abort "{{{1
    return getline(v:lnum) =~# '^=\+$' ? '>1' : 1
endfu

fu s:fold_text() abort "{{{1
    return nextnonblank(v:foldstart+1)->getline()
endfu

" options {{{1

" Leave this section below the functions definitions.

if expand('<afile>:p') =~# $HOME .. '/.vim/doc/misc/\%(notes\|galore\)'
    setl fdm=expr
    let &l:fdt = expand('<SID>') .. 'fold_text()'
    let &l:fde = expand('<SID>') .. 'fold_expr()'
endif

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ .. '| set fde< fdm< fdt<'

