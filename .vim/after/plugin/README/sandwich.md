# Design
## What are the two main parts making up `vim-sandwich`?

        • operator-sandwich
        • textobj-sandwich

## Can they cooperate?   Can they be used independently?

Yes and yes.

IOW:

        • any object   provided by `textobj-sandwich`  can be composed with any operator
        • any operator provided by `operator-sandwich` can be composed with any object

##
## In which variables can any kind of recipe be stored? (from the highest priority to the lowest)   (3)

        • b:sandwich_recipes
        • g:sandwich#recipes
        • g:sandwich#default_recipes

## In which variables can a recipe implementing an operator be stored?   (3)

        • b:operator_sandwich_recipes
        • g:operator#sandwich#recipes
        • g:operator#sandwich#default_recipes

## In which variables can a recipe implementing an object be stored?   (3)

        • b:textobj_sandwich_recipes
        • g:textobj#sandwich#recipes
        • g:textobj#sandwich#default_recipes

##
## What's a magiccharacter?

When  the plugin  requests the  user  to input  keys  to determine  the text  to
add/delete, usually they are not interpreted.

But there are some exceptions.
For example, `sdf`  doesn't try to delete two surrounding  `f` characters, but a
surrounding function name.

##
# Operators
## What are the three operators provided by the plugin?

        ┌─────┬─────────────────────────────────────────┐
        │ lhs │ rhs                                     │
        ├─────┼─────────────────────────────────────────┤
        │ sa  │ <plug>(operator-sandwich-add)           │
        ├─────┼─────────────────────────────────────────┤
        │ sd  │ <plug>(operator-sandwich-delete)        │
        │     │ <plug>(operator-sandwich-release-count) │
        │     │ <plug>(textobj-sandwich-query-a)        │
        ├─────┼─────────────────────────────────────────┤
        │ sr  │ <plug>(operator-sandwich-replace)       │
        │     │ <plug>(operator-sandwich-release-count) │
        │     │ <plug>(textobj-sandwich-query-a)        │
        └─────┴─────────────────────────────────────────┘

## On what condition do they work?

`sa` work unconditionally.

However, for  `v_sd` and  `v_sr` to work,  the first and  last character  of the
selection must be identical, or they must be stored in a recipe (`buns` key).

##
## What are the key sequences to which the following operators are mapped?   (2 answers each time)
### the operator adding surroundings

        sa
        <plug>(operator-sandwich-add)

It works in normal and visual modes.

### the operator deleting surroundings

        sd
        <plug>(operator-sandwich-delete)

It works in visual mode if the ends  of the selected region are identical, or if
they're included in the set of registered surroundings.

### the operator replacing surroundings

        sr
        <plug>(operator-sandwich-replace)

It works in visual mode if the ends  of the selected region are identical, or if
they're included in the set of registered surroundings.


        [bar(foo)baz]   --->   bar(foo)baz

##
# Objects
## What are the four objects provided by the plugin?

                            ┌ look for the surrounding characters automatically
                            │    ┌ but don't include them in the object
                            │    │
    <plug>(textobj-sandwich-auto-i)      bound to `ib` by default
    <plug>(textobj-sandwich-auto-a)      "        `ab` "
    <plug>(textobj-sandwich-query-i)     "        `is` "
    <plug>(textobj-sandwich-query-a)     "        `as` "
                            │     │
                            │     └ and include it in the object
                            └ ask the user what's the surrounding character

## What are the key sequences to which the following objects are mapped?   (2 answers each time)
### the object selecting, automatically, a sandwiched text

        <plug>(textobj-sandwich-auto-i)
        <plug>(textobj-sandwich-auto-a)

They are mapped to the key sequences `ib` and `ab`.
They are valid in both operator-pending mode and visual mode.
`ib` selects the text INSIDE the surroundings.
`ab` selects the text INCLUDING surroundings.

### the object selecting, depending on user input, a sandwiched text

        <plug>(textobj-sandwich-query-i)
        <plug>(textobj-sandwich-query-a)

They are mapped to the key sequences `is` and `as`.
They are valid in both operator-pending mode and visual mode.
`is` selects the text INSIDE the surroundings.
`as` selects the text INCLUDING surroundings.

##
# Exercises
## 1

           normal mode: ↣ saiw( ↢

    foo    ---->    (foo)

           visual mode: ↣ viwsa( ↢

## 2

               normal mode: ↣ sd( ↢ 1st solution
                            ↣sb ↢ 2nd solution

    (foo)    ---->    foo

               visual mode: ↣ va(sd ↢

More generally, every time you have  to provide a surrounding character to `sa`,
`sd`, `sr`, you can give `b` to ask the plugin to look for it automatically.

## 3

               normal mode: ↣ sr(" ↢

    (foo)    ---->    "foo"

               visual mode: ↣ va(sr" ↢

## 4

               normal mode: ↣ 2sdb ↢

    (bar(foo)baz)    ---->    bar(foo)baz
          ^
          cursor

## 5

               ↣ saiwffunc CR ↢

    arg      ---->     func(arg)

##
# Issues
## I can't test the existence of `g:sandwich#default_recipes` from `~/.vim/after/plugin/sandwich.vim`!

Of course, it's an AUTOLOADED variable.
It doesn't exist until you ask for its value:

        echom exists('g:sandwich#default_recipes')
            → 0 ✘

        echom get(g:, 'sandwich#default_recipes', [])
            → [] ✘

        echom g:sandwich#default_recipes
            → [ ... ] ✔

When you ask for  its value, Vim will look in  all `autoload/` subdirectories of
the rtp, for  a file named `sandwich`  (because that's the path  before the last
number sign #), and then for the variable itself.

As a workaround, to be reasonably sure that the variable can exist, you can test
whether the plugin has been sourced:

        if !exists('g:loaded_sandwich')
            finish
        endif

Or use a `try` conditional before trying to use its value in an assignment.

##
# TODO
## ???

Press `vis"` while the cursor is where the bar is:

        " foo
        b|ar
        " baz

It should select the sandwich. It doesn't.
Same issue with `vis'` and:

        ' foo
        b|ar
        ' baz

## ???

Debug this:

        let a = Func(b)
        call Func(b)
        " press sdf on `Func()` in both cases,
        " it should be removed, but it's not

However, this works as expected:

        let a = Func(ab)
        call Func(ab)

## ???

Read this (taken from vim-surround note), and try to reimplement it:

    Au moment d'encadrer un text-object, on peut également interroger
    l'utilisateur via un prompt pour lui permettre d'insérer une chaîne de
    caractères arbitraire:

            let g:surround_108 = "\1Enter sth: \1 \r \1\1"

    `\r` permet de se référer au texte à remplacer (un peu comme & dans une
    substitution).
    Le prompt sera peuplé avec ’Enter sth: ’, et la chaîne saisie sera insérée
    entre chaque paire consécutive de `\1 … \1`.
    On ne peut pas se référer plusieurs fois au texte d'origine.
    IOW, on ne peut pas utiliser plusieurs fois `\r`.
    Le 1er sera bien remplacé par le text-object d'origine. Mais les autres
    seront traduits en CR littéraux.
    Il est nécessaire d'utiliser des doubles quotes.
    On peut utiliser jusqu'à 7 input différents:

            let g:surround_108 = "\1Enter sth: \1 \r \2And sth else: \2"

    Ajouter des exemples …
    https://stackoverflow.com/a/47401509/8243465



    Furthermore, one can specify a regular expression substitution to apply.

          let g:surround_108 = "\\begin{\1environment: \1}\r\\end{\1\r}.*\r\1}"
          let g:surround_108 = "\1Enter sth: \1 \r \1\r}.*\r\1"

    This will remove anything after the first } in the input when the text is
    placed within the \end{} slot.  The first \r marks where the pattern begins,
    and the second where the replacement text begins.

    Les 2 derniers `\r` sont équivalents à `\zs` et `\ze`.
    Tout ce qui se situe entre eux est supprimé.

    Here's a second  example for creating an HTML <div>.  The substitution prompts
    for an id, but only adds id="" if it is non-blank.

          let g:surround_{char2nr("d")} = "<div\1id: \r..*\r id=\"&\"\1>\r</div>"

## ???

                   ↣ sdf ↢

    func(arg)    ---->    arg


                                ↣ sdf ↢
    func1(func2(func3(arg)))  ---->   func1(func2(arg))
                 ^              ↣ 2sdf, sdF ↢
                              ---->   func1(func3(arg))
                                ↣ 3sdf, 2sdF ↢
                              ---->   func2(func3(arg))


    vis_
    vas_

            Permet de cibler  un sandwich entouré par des  underscores (exclus /
            inclus).
            Fonctionne avec  n'importe quelle  autre caractère  entourant, entre
            autres:

                    _ - . : , ; | / \ * + # %

            Y compris qd le sandwich est multi-lignes.


               ↣ saio( ↢

    a                 (a)
    bb       ---->    (bb)
    ccc               (ccc)

