" break lines beyond 80 characters
setl tw=80

" Options {{{1

augroup my_tmux
    au! *            <buffer>
    au  BufWinEnter  <buffer>  setl fdm=marker
                           \ | setl fdt=fold#fdt#get()
                           \ | setl cocu=nc
                           \ | setl cole=3
augroup END

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
    \ . (empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
    \ . "
    \   setl cocu< cole< fdm< fdt< tw<
    \ | exe 'au! my_tmux * <buffer>'
    \ "

