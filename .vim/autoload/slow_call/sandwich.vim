" Why not moving the code from here to `~/.vim/after/plugin/sandwich.vim`?{{{
"
" It causes several `autoload/` files to be sourced. Too slow.
"}}}

if stridx(&rtp, 'vim-sandwich') ==# -1
    finish
endif

" Highlighting in the delete operator is often distracting.
call operator#sandwich#set('delete', 'all', 'highlight', 0)

