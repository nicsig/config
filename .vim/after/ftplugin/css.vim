" Options "{{{1

setl fp=js-beautify\ --css

" When hitting K, search for the word under the cursor in a search engine.
setl kp=:DD

" google style guide
setl sw=2

" Variables {{{1

const b:mc_chain =<< trim END
    file
    omni
    keyn
    dict
    ulti
    abbr
    c-n
END

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ . "
    \ | setl sw<
    \ | set fp< kp<
    \ | unlet! b:mc_chain
    \ "

