" Options "{{{1

setl fp=js-beautify\ --css

" When hitting K, search for the word under the cursor in a search engine.
setl kp=:DD

" google style guide
setl sw=2

" Variables {{{1

let b:mc_chain = [
    \ 'file',
    \ 'omni',
    \ 'keyp',
    \ 'dict',
    \ 'ulti',
    \ 'abbr',
    \ 'c-p',
    \ ]

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
    \ . (empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
    \ . "
    \   setl fp< kp< sw<
    \ | unlet! b:mc_chain
    \ "

