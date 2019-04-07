setl cms=.\\\"\ %s
" necessary to make Vim auto-insert the comment leader when we open a new line
setl com=:.\\\"

" teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
    \ . (empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
    \ . "
    \   setl cms< com<
    \ "

