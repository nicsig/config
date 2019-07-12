setl sw=2

" teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ . "
    \ | setl sw<
    \ "

