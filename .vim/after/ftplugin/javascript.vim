" Options "{{{

setl fp=js-beautify

" When hitting K, search for the word under the cursor in a search engine.
setl kp=:DD

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ . "
    \ | set fp< kp<
    \ "

