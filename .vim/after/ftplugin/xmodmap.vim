" Options {{{1

augroup my_xmodmap
    au! *            <buffer>
    au  BufWinEnter  <buffer>  setl fdm=marker
augroup END

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
    \ . (empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
    \ . "
    \   setl fdm<
    \ | exe 'au! my_xmodmap * <buffer>'
    \ "

