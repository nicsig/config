" We need to remove an item from `g:sandwich#default_recipes`:{{{
"
"         { 'noremap':     0,
"         \ 'expr_filter': ['operator#sandwich#kind() is# "replace"'],
"         \ 'kind':        ['replace', 'textobj'],
"         \ 'external':    ["\<plug>(textobj-sandwich-tagname-i)", "\<plug>(textobj-sandwich-tagname-a)"],
"         \ 'input':       ['t'],
"         \ 'synchro':     1 }
"
" Otherwise,  sometimes, when  we press  `srb` from  normal mode,  or `sr`  from
" visual mode, Vim doesn't respond anymore  for several seconds, and it consumes
" a lot of cpu.
"
" This is because, sometimes, when the plugin must find what are the surrounding
" characters itself, it WRONGLY finds a tag.
"
"         <plug>(textobj-sandwich-tagname-a)
"
"         sandwich#magicchar#t#a()
"         ~/.vim/plugged/vim-sandwich/autoload/sandwich/magicchar/t.vim
"
"         call s:prototype('a')
"                 execute printf('normal! v%dat', v:count1)
"
"                 v1at
"                     → E65: Illegal back reference
"}}}
" Removing this item may make us lose the tag object.{{{
"
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
"}}}

fu! s:fix_sandwich_recipes() abort
    let item = { 'noremap':     0,
    \ 'expr_filter': ['operator#sandwich#kind() is# "replace"'],
    \ 'kind':        ['replace', 'textobj'],
    \ 'external':    ["\<plug>(textobj-sandwich-tagname-i)", "\<plug>(textobj-sandwich-tagname-a)"],
    \ 'input':       ['t'],
    \ 'synchro':     1 }

    let idx = index(g:sandwich#default_recipes, item)
    let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
    call remove(g:sandwich#recipes, idx)
endfu
call s:fix_sandwich_recipes()

let g:sandwich#recipes += [ {'buns': ['“', '”'],   'input': ['u"'] } ]
\                       + [ {'buns': ['‘', '’'],   'input': ["u'"] } ]
"                                      │
"                                      └ used in man pages (ex: `man tmux`)

