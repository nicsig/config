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
