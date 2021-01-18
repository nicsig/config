" TODO: Move the `notes` and `galore` files into markdown files.

def FoldExpr(): string #{{{1
    return getline(v:lnum) =~ '^=\+$' ? '>1' : '1'
enddef

def FoldText(): string #{{{1
    return nextnonblank(v:foldstart + 1)->getline()
enddef

" options {{{1

" Leave this section below the functions definitions.

if expand('<afile>:p') =~# $HOME .. '/.vim/doc/misc/\%(notes\|galore\)'
    setl fdm=expr
    let &l:fdt = expand('<SID>') .. 'FoldText()'
    let &l:fde = expand('<SID>') .. 'FoldExpr()'
endif

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ .. '| set fde< fdm< fdt<'

