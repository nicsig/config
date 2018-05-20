" Disabled by default. We'll decide for which filetypes we want emmet's
" mappings (in an autocmd).
let g:user_emmet_install_global = 0

" Only in insert and visual mode (not normal).
let g:user_emmet_mode = 'iv'

" Use C-g as a prefix key instead of C-y.
let g:user_emmet_leader_key = '<c-g>'
" To create various buffer-local mappings, `emmet` will combined this prefix with the keys:{{{
"
"         /
"         ;
"         A
"         D
"         N
"         a
"         d
"         i
"         j
"         k
"         n
"         u
"         m
"         c
"}}}
" Will there be conflicts with the following default commands?{{{
"
"     C-g j
"     C-g k
"     C-g u
"
" And what about our own custom `C-g m`?
"}}}

fu! s:emmet_set_mappings() abort
    " The default mappings are not silent, so we install them manually and silently.
    " Where did you find all the `{rhs}`?{{{
    "
    "     :h emmet-customize-key-mappings
    "}}}

    imap  <buffer><nowait><silent>  <c-g>,      <plug>(emmet-expand-abbr)
    imap  <buffer><nowait><silent>  <c-g>;      <plug>(emmet-expand-word)
    imap  <buffer><nowait><silent>  <c-g><c-u>  <plug>(emmet-update-tag)
    imap  <buffer><nowait><silent>  <c-g>d      <plug>(emmet-balance-tag-inward)
    imap  <buffer><nowait><silent>  <c-g>D      <plug>(emmet-balance-tag-outward)
    imap  <buffer><nowait><silent>  <c-g>n      <plug>(emmet-move-next)
    imap  <buffer><nowait><silent>  <c-g>N      <plug>(emmet-move-prev)
    imap  <buffer><nowait><silent>  <c-g>i      <plug>(emmet-image-size)
    imap  <buffer><nowait><silent>  <c-g>/      <plug>(emmet-toggle-comment)
    imap  <buffer><nowait><silent>  <c-g><c-j>  <plug>(emmet-split-join-tag)
    imap  <buffer><nowait><silent>  <c-g><c-k>  <plug>(emmet-remove-tag)
    imap  <buffer><nowait><silent>  <c-g>a      <plug>(emmet-anchorize-url)
    imap  <buffer><nowait><silent>  <c-g>A      <plug>(emmet-anchorize-summary)
    imap  <buffer><nowait><silent>  <c-g><c-m>  <plug>(emmet-merge-lines)
    imap  <buffer><nowait><silent>  <c-g>p      <plug>(emmet-code-pretty)

    xmap  <buffer><nowait><silent>  <c-g>,      <plug>(emmet-expand-abbr)
    xmap  <buffer><nowait><silent>  <c-g>;      <plug>(emmet-expand-word)
    xmap  <buffer><nowait><silent>  <c-g><c-u>  <plug>(emmet-update-tag)
    xmap  <buffer><nowait><silent>  <c-g>d      <plug>(emmet-balance-tag-inward)
    xmap  <buffer><nowait><silent>  <c-g>D      <plug>(emmet-balance-tag-outward)
    xmap  <buffer><nowait><silent>  <c-g>n      <plug>(emmet-move-next)
    xmap  <buffer><nowait><silent>  <c-g>N      <plug>(emmet-move-prev)
    xmap  <buffer><nowait><silent>  <c-g>i      <plug>(emmet-image-size)
    xmap  <buffer><nowait><silent>  <c-g>/      <plug>(emmet-toggle-comment)
    xmap  <buffer><nowait><silent>  <c-g><c-j>  <plug>(emmet-split-join-tag)
    xmap  <buffer><nowait><silent>  <c-g><c-k>  <plug>(emmet-remove-tag)
    xmap  <buffer><nowait><silent>  <c-g>a      <plug>(emmet-anchorize-url)
    xmap  <buffer><nowait><silent>  <c-g>A      <plug>(emmet-anchorize-summary)
    xmap  <buffer><nowait><silent>  <c-g><c-m>  <plug>(emmet-merge-lines)
    xmap  <buffer><nowait><silent>  <c-g>p      <plug>(emmet-code-pretty)

    " I haven't been able to update `b:undo_ftplugin` from here ...
endfu

augroup my_emmet
    au!
    au FileType css,html,markdown  call s:emmet_set_mappings()
augroup END


" https://github.com/mattn/emmet-vim/issues/378#issuecomment-329839244
" Warning:
" Sometimes it's useful.
" Sometimes it's annoying (write a url and press C-g a).
let g:user_emmet_settings = {
\  'html': {
\      'block_all_childless' : 1,
\  },
\}

