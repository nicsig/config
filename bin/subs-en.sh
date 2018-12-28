#!/bin/bash

# Dépendances : python-pip.

# Installer [Mettre à jour] subliminal:
#
#     sudo pip install [--upgrade] subliminal
#
# Si subliminal bug à cause d'une version trop ancienne du paquet six :
# sudo pip install --upgrade six

# Ajouter une action personnalisée dans le menu contextuel de thunar pour utiliser subliminal automatiquement.
# Edit > Configure custom actions > Command : <chemin vers subs_fr.sh> %n %d
# %n et %d servent à passer au script en argument resp. le nom du fichier et son dossier
# Appearance Conditions : cocher Video Files

# Intégration de subliminal ou periscope dans nautilus ou nemo :
# http://www.webupd8.org/2014/09/download-subtitles-via-nautilus-nemo.html

# Pour que vlc télécharge automatiquement les sous-titres d'une vidéo installer l'addon VLsub :
# https://github.com/exebetche/vlsub
# Atm, ne marche pas avec vlc 2.1

# Génération d'un log pour le script.

exec 3>&1 4>&2
[[ -d "${HOME}/log" ]] || mkdir "${HOME}/log"
exec 1>"${HOME}/log/$(basename "$0" .sh).log" 2>&1


cd "$2"
subliminal download -l en -- "$1" && notify-send "Des sous-titres anglais ont été téléchargés" || notify-send "Aucun sous-titres anglais trouvés"
