" We need to remove some recipes.{{{
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
" Removing these recipes may make us lose the tag object.{{{
"
" We could:
"
"         • submit a bug report:
"
"                 The plugin detection of surrounding characters should be improved.
"                 If it can't, when `E65` occurs, the plugin should stop and show it to us.
"                 Why doesn't that happen?
"
"         • try and tweak the definition of these recipes
"
"         • let the recipes in, and disable the problematic operators:
"
"                 nno srb <nop>
"                 xno sr  <nop>
"}}}

fu! s:set_default_recipes() abort
    let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
                         \ + [ {'buns': ['“', '”'],   'input': ['u"'] } ]
                         \ + [ {'buns': ['‘', '’'],   'input': ["u'"] } ]
                         "                │
                         "                └ used in man pages (ex: `man tmux`)

    let problematic_recipes = [
    \ { 'noremap':     0,
    \ 'expr_filter': ['operator#sandwich#kind() is# "replace"'],
    \ 'kind':        ['replace', 'textobj'],
    \ 'external':    ["\<plug>(textobj-sandwich-tagname-i)", "\<plug>(textobj-sandwich-tagname-a)"],
    \ 'input':       ['t'],
    \ 'synchro':     1 },
    \
    \ {'noremap':    0,
    \ 'expr_filter': ['operator#sandwich#kind() ==# "replace"'],
    \ 'kind':        ['replace', 'query'],
    \ 'external':    ["\<plug>(textobj-sandwich-tag-i)", "\<plug>(textobj-sandwich-tag-a)"],
    \ 'input':       ['T'],
    \ 'synchro':     1},
    \
    \ {'noremap':    0,
    \ 'expr_filter': ['operator#sandwich#kind() ==# "replace"'],
    \ 'kind':        ['replace', 'textobj'],
    \ 'external':    ["\<plug>(textobj-sandwich-tagname-i)", "\<plug>(textobj-sandwich-tagname-a)"],
    \ 'input':       ['t'],
    \ 'synchro':     1},
    \ ]

    for recipe in problematic_recipes
        let idx = index(g:sandwich#recipes, recipe)
        call remove(g:sandwich#recipes, idx)
    endfor
endfu
call s:set_default_recipes()

