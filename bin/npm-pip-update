#!/bin/bash

# FIXME: Don't use sudo with `pip` (it will only cause issues later).
# Same thing for `npm`?

sudo npm update -g npm peerflix

# L'option -H passée à sudo permet de set la variable d'environnement HOME comme étant celle de l'utilisateur,
# au nom duquel on lance la commande (en l'occurrence ici, on lance au nom de root).
# Ça permet d'éviter un message d'avertissement de la part de pip nous disant que ~/.cache/pip/http ne nous appartient pas.

sudo -H pip install --upgrade livestreamer subliminal

# La mise à jour d'une dépendance d'un paquet pip peut temporairement casser un pgm.
# Exemple : subliminal dépend de click, et la version 1.0.1 de subliminal est cassée par la version 5.0 de click.
# Solution : forcer temporairement l'installation d'une vieille version de la dépendance.
# pip uninstall click ; pip install click==4.1

# TODO: modifier le script pour qu'il mette à jour tous les paquets npm / pip installés.
# https://gist.github.com/othiym23/4ac31155da23962afd0e
# https://stackoverflow.com/questions/2720014/upgrading-all-packages-with-pip/5839291#5839291
