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
" Highlighting in the delete operator is often distracting.
sil! call operator#sandwich#set('delete', 'all', 'highlight', 0)

" We need to remove this item from `g:sandwich#default_recipes`:
"
"         { 'noremap':     0,
"         \ 'expr_filter': ['operator#sandwich#kind() is# "replace"'],
"         \ 'kind':        ['replace', 'textobj'],
"         \ 'external':    ["\<plug>(textobj-sandwich-tagname-i)", "\<plug>(textobj-sandwich-tagname-a)"],
"         \ 'input':       ['t'],
"         \ 'synchro':     1 }
"
" Otherwise, we have the bug `srb`, `v_sr`.
"
"         <plug>(textobj-sandwich-tagname-a)
"
"         sandwich#magicchar#t#a()
"         ~/.vim/plugged/vim-sandwich/autoload/sandwich/magicchar/t.vim
"
"         call s:prototype('a')
"                 execute printf('normal! v%dat', v:count1)
"
"                 ⇔ v1at → E65: Illegal back reference
"                          E65: Illegal back reference
"
" Sometimes,  when the  plugin must  find  what are  the surrounding  characters
" itself, it WRONGLY finds a tag.
"
" Removing this item may make us lose the tag object.
" We could:
"
"         • submit a bug report:
"
"                 The plugin detection of surrounding characters should be improved.
"                 If it can't, when `E65` occurs, the plugin should stop and show it to us.
"                 Why doesn't that happen?
"
"         • try and tweak the definition of this recipe
"
"         • let the recipe in, and disable the problematic operators:
"
"                 nno srb <nop>
"                 xno sr  <nop>

let g:sandwich#default_recipes = [
\       {'buns': ['\s\+', '\s\+'], 'regex': 1, 'kind': ['delete', 'replace', 'query'], 'input': [' ']},
\       {'buns': ['', ''], 'action': ['add'], 'motionwise': ['line'], 'linewise': 1, 'input': ["\<CR>"]},
\       {'buns': ['^$', '^$'], 'regex': 1, 'linewise': 1, 'input': ["\<CR>"]},
\       {'buns': ['<', '>'], 'expand_range': 0, 'match_syntax': 1},
\       {'buns': ['"', '"'], 'quoteescape': 1, 'expand_range': 0, 'nesting': 0, 'linewise': 0, 'match_syntax': 1},
\       {'buns': ["'", "'"], 'quoteescape': 1, 'expand_range': 0, 'nesting': 0, 'linewise': 0, 'match_syntax': 1},
\       {'buns': ['{', '}'], 'nesting': 1, 'match_syntax': 1, 'skip_break': 1},
\       {'buns': ['[', ']'], 'nesting': 1, 'match_syntax': 1},
\       {'buns': ['(', ')'], 'nesting': 1, 'match_syntax': 1},
\       {'buns': 'sandwich#magicchar#t#tag()', 'listexpr': 1, 'kind': ['add'], 'action': ['add'], 'input': ['t']},
\       {'buns': 'sandwich#magicchar#t#tag()', 'listexpr': 1, 'kind': ['replace'], 'action': ['add'], 'input': ['T']},
\       {'buns': 'sandwich#magicchar#t#tagname()', 'listexpr': 1, 'kind': ['replace'], 'action': ['add'], 'input': ['t']},
\       {'external': ["\<Plug>(textobj-sandwich-tag-i)", "\<Plug>(textobj-sandwich-tag-a)"], 'noremap' : 0, 'kind' : ['delete', 'textobj'], 'expr_filter': ['operator#sandwich#kind() isnot# "replace"'], 'synchro': 1, 'linewise': 1, 'input': ['t', 'T']},
\       {'external': ["\<Plug>(textobj-sandwich-tag-i)", "\<Plug>(textobj-sandwich-tag-a)"], 'noremap' : 0, 'kind' : ['replace', 'query'], 'expr_filter': ['operator#sandwich#kind() is# "replace"'], 'synchro': 1, 'input': ['T']},
\       {'buns': ['sandwich#magicchar#f#fname()', '")"'], 'kind': ['add', 'replace'], 'action': ['add'], 'expr': 1, 'input': ['f']},
\       {'external': ["\<Plug>(textobj-sandwich-function-ip)", "\<Plug>(textobj-sandwich-function-i)"], 'noremap': 0, 'kind': ['delete', 'replace', 'query'], 'input': ['f']},
\       {'external': ["\<Plug>(textobj-sandwich-function-ap)", "\<Plug>(textobj-sandwich-function-a)"], 'noremap': 0, 'kind': ['delete', 'replace', 'query'], 'input': ['F']},
\       {'buns': 'sandwich#magicchar#i#input("operator")', 'kind': ['add', 'replace'], 'action': ['add'], 'listexpr': 1, 'input': ['i']},
\       {'buns': 'sandwich#magicchar#i#input("textobj", 1)', 'kind': ['delete', 'replace', 'query'], 'listexpr': 1, 'regex': 1, 'synchro': 1, 'input': ['i']},
\       {'buns': 'sandwich#magicchar#i#lastinput("operator", 1)', 'kind': ['add', 'replace'], 'action': ['add'], 'listexpr': 1, 'input': ['I']},
\       {'buns': 'sandwich#magicchar#i#lastinput("textobj")', 'kind': ['delete', 'replace', 'query'], 'listexpr': 1, 'regex': 1, 'synchro': 1, 'input': ['I']},
\ ]

let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
\                      + [ {'buns': ['“', '”'],   'input': ['u"'] } ]
\                      + [ {'buns': ['‘', '’'],   'input': ["u'"] } ]
"                                     │
"                                     └ used in man pages (ex: `man tmux`, search for ‘=’)

