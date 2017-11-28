" Mappings "{{{1

if exists(':EmmetInstall') == 2
    EmmetInstall
endif

" Options "{{{1

setl fp=js-beautify\ --css

" When hitting K, search for the word under the cursor in a search engine.
setl kp=:DD

" Teardown {{{1

let b:undo_ftplugin =         get(b:, 'undo_ftplugin', '')
                    \ .(empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
                    \ ."
                    \   setl fp< kp<
                    \  "
