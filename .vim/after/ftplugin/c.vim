" Why not `/*%s*/`?{{{
"
" It would add too much complexity  in our syntax comment customizations, and in
" `vim-comment`; not worth the effort.
"}}}
setl cms=//\ %s

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ .. '| set cms<'

