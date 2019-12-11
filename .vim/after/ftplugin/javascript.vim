" Options "{{{

" `js-beautify` is a formatting tool for js, html, css.{{{
"
" Installation:
"
"     $ sudo npm -g install js-beautify
"
" Documentation:
" https://github.com/beautify-web/js-beautify
"
" The tool has  many options; you can  use the ones you find  interesting in the
" value of `'fp'`.
"}}}
setl fp=js-beautify

" when hitting K, search for the word under the cursor in a search engine
setl kp=:DD

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ ..'| set fp< kp<'

