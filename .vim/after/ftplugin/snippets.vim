" Mappings {{{1

nno  <buffer><nowait><silent>  q  :<c-u>call my_lib#quit()<cr>

" Options "{{{1

" We want real tabs  in a snippet file, because they have  a special meaning for
" UltiSnips (“increase the level of indentation of the line“).
setl noet sw=4 ts=4
"         └───────┤
"                 └ alternative: let &l:ts = &l:sw

augroup my_snippets
    au! *            <buffer>
    au  BufWinEnter  <buffer>  setl fdm=marker
                           \ | let &l:fdt = 'snippets#fold_text()'
                           \ | setl cocu=nc
                           \ | setl cole=3
augroup END

" Teardown {{{1

let b:undo_ftplugin =         get(b:, 'undo_ftplugin', '')
                    \ .(empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
                    \ ."
                    \   setl cocu< cole< et< fdm< fdt< sw< ts<
                    \|  exe 'au!  my_snippets * <buffer>'
                    \|  exe 'nunmap <buffer> q'
                    \  "
