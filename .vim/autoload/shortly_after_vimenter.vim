call plug#load('vim-fugitive', 'vim-schlepp')

" Highlighting in the delete operator is often distracting.
sil! call operator#sandwich#set('delete', 'all', 'highlight', 0)
" Why here instead of `~/.vim/after/plugin/sandwich.vim`?{{{
"
" It causes several autoload/ files to be sourced. Too slow.
"}}}
" Why silently?{{{
"
" There's an error if we temporarily disable the plugin. Happens when debugging.
"}}}
" Why not test the existence of the function?{{{
"
" It's an autoloaded function. It doesn't exist prior to its first invocation.
"}}}

sil! let g:sandwich#recipes =  deepcopy(g:sandwich#default_recipes)
\                             + [ {'buns': ['“', '”'], 'input': ['u"'] } ]
\                             + [ {'buns': ['‘', '’'], 'input': ["u'"] } ]
"                                            │
"                                            └ used in man pages (ex: `man tmux`, search for ‘=’)

" `vim-sandwich` installs the following mappings:
"
"         ono  is  <plug>(textobj-sandwich-query-i)
"         ono  as  <plug>(textobj-sandwich-query-a)
"
" They  shadow  the  built-in  sentences  objects. But I  use  the  latter  less
" frequently than  the sandwich objects. So,  I won't remove  the mappings. But,
" instead, to restore the sentences objects, we install these mappings:

ono  iS  is
ono  aS  as
