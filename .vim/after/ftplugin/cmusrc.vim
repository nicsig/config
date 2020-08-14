" Options "{{{1

" By default the 'commentstring' option is set to `/*%s*/`.
" But for a `cmusrc` file, it should be `#%s`.
" I suppose the reason is because there's no ftplugin in $VIMRUNTIME/ftplugin/
" for `cmusrc` files.

" We need the correct value for the `gq` operator to work properly.
setl cms=#\ %s

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ .. '| set cms<'
