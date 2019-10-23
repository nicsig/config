#!/bin/bash

# Ce script s'appuie essentiellement sur livestreamer.
# Livestreamer est un un script python qui permet de rediriger un flux vidéo en live vers un lecteur tq VLC.
# Il gère plusieurs services (YT, Twitch, Dailymotion...).
# Son intérêt est d'éviter les plugins flash bugués et gourmands en cpu.
# Documentation : http://docs.livestreamer.io/cli.html

# Syntaxe d'utilisation:
#     livestreamer [OPTIONS] [URL] [STREAM]
# Obtenir les noms des différents flux dispo:
#     livestreamer twitch.tv/nom_du_streamer
# Lire un flux:
#     livestreamer --player {mpv | mplayer | vlc ...} twitch.tv/nom_du_streamer STREAM

# Installer python-pip, optionnel : requests[security], et zenity.
# Installer livestreamer : sudo pip install livestreamer
# En cas de message d'erreur à propos de SSL : sudo pip install requests[security]

# Pour suivre les commentaires d'une  chaîne twitch, installer chatty (dispo via
# le dépôt getdeb, ou téléchargeable manuellement depuis www.ubuntuupdates.org).
# On peut aussi les suivre sur irc via xchat.
# irc  par rapport  au webchat  :  les emojis  sont  convertis en  texte et  les
# messages supprimés par la modération restent affichés.
#   serveur = irc.twitch.tv:6667
#   pseudo = pseudo twitch
#   mdp = token généré depuis http://www.twitchapps.com/tmi
#   channel = pseudo du streamer

# Génération d'un log pour le script.

exec 3>&1 4>&2
[[ -d "${HOME}/log" ]] || mkdir "${HOME}/log"
exec 1>"${HOME}/log/$(basename "$0" .sh).log" 2>&1


# ~/.twitch_last_channel stocke le nom de la dernière chaîne regardée ; on teste
# si le  fichier existe (-e)  ou pas s'il  existe la variable  placeholder prend
# comme valeur le contenu du fichier  sinon elle vaut la chaîne vide placeholder
# sera utilisé par zenity pour afficher un texte par défaut (--entry-text)

if [[ -e ~/.twitch_last_channel ]]; then
  placeholder="$(cat ~/.twitch_last_channel)"
else
  placeholder=
fi

name=$(zenity --entry \
              --text 'Tape le nom du streamer dont tu veux suivre le live.' \
              --entry-text="${placeholder}") && \
  printf -- '%s\n' "${name}" >~/.twitch_last_channel && \
  livestreamer --player 'mpv --autofit-larger=90%x80%' twitch.tv/"${name}" best || \
  exit 1

# l'option autofit-larger de mpv permet d'empêcher la fenêtre de dépasser 90% de
# la largeur et 80% de la hauteur de l'écran

# Pour lancer le script dans un  terminal (utile pour debug), lancer la commande
# précédente via x-terminal-emulator -e <commande>.
