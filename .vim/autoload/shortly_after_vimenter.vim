call plug#load('vim-fugitive', 'vim-schlepp')

" Highlighting in the delete operator is really irritating.
call operator#sandwich#set('delete', 'all', 'highlight', 0)
" Why here instead of `~/.vim/after/plugin/sandwich.vim`?
" It causes several autoload/ files to be sourced. Too slow.

let g:sandwich#recipes =   deepcopy(g:sandwich#default_recipes)
\                        + [ {'buns': ['“', '”'], 'input': ['u\"'] } ]
