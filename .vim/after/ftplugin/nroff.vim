setl cms=.\\\"\ %s
" necessary to make Vim auto-insert the comment leader when we open a new line
setl com=:.\\\"

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ .. '| setl cms< com<'

