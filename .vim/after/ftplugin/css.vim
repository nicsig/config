" Options "{{{1

setl fp=js-beautify\ --css

" google style guide
setl sw=2

" Variables {{{1

let b:mc_chain =<< trim END
    file
    omni
    keyn
    ulti
    abbr
    c-n
    dict
END

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ .. '| set fp< sw< | unlet! b:mc_chain'

