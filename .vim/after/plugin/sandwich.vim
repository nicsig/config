if !exists('g:loaded_sandwich')
    finish
endif

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
"           IMHO, it's the best solution.
"           We should have a minimum of global recipes.
"           And add relevant recipes for some filetypes via `b:sandwich_recipes`.
"           For example, a tag recipe is not very useful in a vim file.
"           But it's certainly useful in an html file.
"
"           Bottom Line:
"
"               - Better understand how to define/customize a recipe.
"               - Define a minimum of recipes.
"               - Make them relevant to the current filetype.
"
"         • let the recipes in, and disable the problematic operators:
"
"                 nno srb <nop>
"                 xno sr  <nop>
"}}}

fu! s:set_recipes() abort
    " Don't we need `deepcopy()`?{{{
    "
    " If we executed this simple assignment:
    "
    "     let g:sandwich#recipes = g:sandwich#default_recipes
    "
    " ... then, yes, `deepcopy()` would probably be needed.
    " Because, `g:sandwich#recipes` and `g:sandwich#default_recipes` would share
    " the same reference.
    " So, when we  would try to modify  the first one, we would  also modify the
    " second one, which is not possible because it's locked.
    "
    " However, the  rhs of our  assignment not a  simple variable name,  it's an
    " expression using the `+` operator.
    " Thus,  Vim has  to create  a  new reference  to  store the  result of  the
    " expression
    "}}}
    " Why the recipe for ['`', "'"]?{{{
    "
    " It's often used to quote some word in man pages.
    " See here for more info:
    "     https://english.stackexchange.com/q/17695/313834
    "     https://www.cl.cam.ac.uk/~mgk25/ucs/quotes.html
    "}}}
    " Why the input 'g'?{{{
    "
    " 'g' for Grave accent.
    "}}}
    " FIXME: We  need  to repeat  the  last  recipe  twice, otherwise  it's  not
    " included in `g:sandwich#recipes`.
    let g:sandwich#recipes = g:sandwich#default_recipes
                         \ + [{'buns': ['`', "'"], 'input': ['g']}]
                         \ + [{'buns': ['“', '”'], 'input': ['u"']}]
                         \ + [{'buns': ['‘', '’'], 'input': ["u'"]}]
                         \ + [{'buns': ['<kbd>', '</kbd>'], 'input': ['k']}]
                         \ + [{'buns': ['<kbd>', '</kbd>'], 'input': ['k']}]

    " TODO:
    " Instead of removing some problematic  recipes, we should add recipes which
    " we know not to cause any issue.
    " IOW, a whitelist is more reliable than a blacklist.
    let problematic_recipes = [
        \ {'noremap':     0,
        \  'expr_filter': ['operator#sandwich#kind() is# "replace"'],
        \  'kind':        ['replace', 'textobj'],
        \  'external':    ["\<plug>(textobj-sandwich-tagname-i)", "\<plug>(textobj-sandwich-tagname-a)"],
        \  'input':       ['t'],
        \  'synchro':     1},
        \ ]

    for recipe in problematic_recipes
        let idx = index(g:sandwich#recipes, recipe)
        call remove(g:sandwich#recipes, idx)
    endfor
endfu
call s:set_recipes()

