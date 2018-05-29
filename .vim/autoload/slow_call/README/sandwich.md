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

