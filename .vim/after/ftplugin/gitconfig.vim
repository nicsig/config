augroup my_gitconfig
    au! * <buffer>
    au BufWinEnter  <buffer>  setl fdm=marker
augroup END

" teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
    \ . (empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
    \ . "
    \ setl fdm<
    \|exe 'au! my_gitconfig * <buffer>'
    \"

