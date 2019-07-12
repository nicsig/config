setl cms=#\ %s

" teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ . "
    \ | setl cms<
    \ "

