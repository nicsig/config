setl cms=#\ %s

setl mp=desktop-file-validate

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ ..'| setl cms< | set mp<'

