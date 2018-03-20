nno  <buffer><nowait><silent>  q  :<c-u>close!<cr>

" teardown {{{1

let b:undo_ftplugin =         get(b:, 'undo_ftplugin', '')
\                     .(empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
\                     ."
\                        | exe 'nunmap <buffer> q'
\                      "

