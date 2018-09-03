" Options {{{1

setl cms=!%s

augroup my_xdefaults
    au! *            <buffer>
    au  BufWinEnter  <buffer>  setl fdm=marker
                           \ | setl fdt=fold#text()
                           \ | setl cocu=nc
                           \ | setl cole=3
augroup END

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
                    \ .(empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
                    \ ."
                    \   setl cms< cocu< cole< fdm< fdt<
                    \ | exe 'au!  my_xdefaults * <buffer>'
                    \  "
