" Options {{{1

setl cms=!\ %s

setl fdm=marker
setl fdt=fold#fdt#get()
setl cocu=nc
setl cole=3

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ ..'
    \ | setl cms< cocu< cole< fdm< fdt<
    \ '

