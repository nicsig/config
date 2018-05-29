# ???

Document this:

    saio(
    surround column text-object with parentheses
    (works even if the lines have different lengths)

# ???

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

# ???

Try to configure the plugin so that `sdb` can delete a pair of backticks.

# ???

Debug this:

        let a = Func(b)
        call Func(b)
        " press sdf on `Func()` in both cases,
        " it should be removed, but it's not

However, this works as expected:

        let ab = Func(ab)

# ???

Debug this:

Write the following line in a markdown buffer:

        “hello world”
              ^
              move your cursor here;
              press `yisu"` to yank the text inside the quotes
              doesn't work; it should

##
##
##
# sandwich

Ce plugin est décomposé en 2 parties:

        • operator-sandwich
        • textobj-sandwich

Elles peuvent coopérer, mais aussi être utilisée indépendamment l'une de l'autre.
IOW:

        • tout objet     fourni par le plugin peut être composé avec n'importe quel opérateur
        • tout opérateur "                                                          objet


operator-sandwich fournit 3 opérateurs:

    <plug>(operator-sandwich-add)        utilisé au début du mapping  `sa`  par défaut
    <plug>(operator-sandwich-delete)     "                            `sd`  "
    <plug>(operator-sandwich-replace)    "                            `sr`  "


textobj-sandwich fournit 4 objets:

                            ┌ recherche du caractère entourant automatique
                            │    ┌ intérieur du sandwich
                            │    │
    <plug>(textobj-sandwich-auto-i)      associé à  ib  par défaut
    <plug>(textobj-sandwich-auto-a)      "          ab  "
    <plug>(textobj-sandwich-query-i)     "          is  "
    <plug>(textobj-sandwich-query-a)     "          as  "
                            │     │
                            │     └ autour du sandwich
                            └ demande à l'utilisateur quel est le caractère entourant


           Normal mode: ↣ saiw( ↢

    foo    ---->    (foo)

           Visual mode: ↣ viwsa( ↢


               ↣ sd( ↢

    (foo)    ---->    foo

               ↣ va(sd ↢


            Plus généralement,  à chaque  fois qu'on  doit fournir  un caractère
            entourant à `sa`, `sd`, `sr`, on  peut utiliser `b` pour demander au
            plugin de le chercher lui-même.
            Mais fournir  explicitement le  caractère semble  rendre l'opération
            plus rapide.

            `sd` et `sr` fonctionnent:

                    • en mode normal, peu importe le caractère entourant

                    • en mode visuel, à condition que le 1er et dernier
                      caractère de la sélection soient identiques, ou bien
                      enregistrés dans l'une des variables:

                            - b:sandwich_recipes
                            - g:sandwich#recipes
                            - g:sandwich#default_recipes


               ↣ sr(" ↢

    (foo)    ---->    "foo"

               ↣ va(sr" ↢


                       ↣ 2sdb ↢

    [bar(foo)baz]    ---->    bar(foo)baz
          ^


               ↣ saiwffunc CR ↢

    arg      ---->     func(arg)

            Qd  un opérateur  attend un  caractère  pour savoir  quoi insérer  /
            supprimer, si  on tape `f`, le  plugin nous permet de  saisir le nom
            d'une fonction.
            Comme  `f`  n'est  pas  traité littéralement,  la  documentation  le
            qualifie de “caractère magique”.


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


                                               FIXME:

            '  et  "  ne  semblent  pas  fonctionner  au  milieu  d'un  sandwich
            multi-lignes.
            Tape `vis"` le curseur étant sur le pipe:

                    " foo
                      b|ar
                    " baz

            Update:
            This is because of this recipe inside `g:sandwich#default_recipes`:

                    { 'buns': ['"', '"']
                    \ 'quoteescape': 1,
                    \ 'expand_range': 0,
                    \ 'nesting': 0,
                    \ 'linewise': 0,
                    \ 'match_syntax': 1 }

            If you assign the value `1` to the `linewise` key, everything works.
            But I don't know whether that's a good idea to change the default.
            Let's learn more about this key before doing anything...

##
##
##
# What are the key sequences to which the following operators/objects are mapped?   (2 answers each time)
## the operator adding surroundings

        sa
        <plug>(operator-sandwich-add)

It works in normal and visual modes.

## the operator deleting surroundings

        sd
        <plug>(operator-sandwich-delete)

It works in visual mode if the ends  of the selected region are identical, or if
they're included in the set of registered surroundings.

## the operator replacing surroundings

        sr
        <plug>(operator-sandwich-replace)

It works in visual mode if the ends  of the selected region are identical, or if
they're included in the set of registered surroundings.


        [bar(foo)baz]   --->   bar(foo)baz

## the object selecting, automatically, a sandwiched text

        <plug>(textobj-sandwich-auto-i)
        <plug>(textobj-sandwich-auto-a)

They are mapped to the key sequences `ib` and `ab`.
They are valid in both operator-pending mode and visual mode.
`ib` selects the text INSIDE the surroundings.
`ab` selects the text INCLUDING surroundings.

## the object selecting, depending on user input, a sandwiched text

        <plug>(textobj-sandwich-query-i)
        <plug>(textobj-sandwich-query-a)

They are mapped to the key sequences `is` and `as`.
They are valid in both operator-pending mode and visual mode.
`is` selects the text INSIDE the surroundings.
`as` selects the text INCLUDING surroundings.

