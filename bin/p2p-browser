#!/bin/bash

# Dépendances : npm, nodejs, nodejs-legacy (semble résoudre un bug), peerflix, zenity

# Documentation sur node.js : 	 https://docs.npmjs.com/
#				 https://docs.npmjs.com/getting-started/installing-node

# Mettre à jour npm : 		sudo npm update -g npm
# Vérifier la version de npm : 	npm -v

# Installer peerflix : 		sudo npm install -g peerflix
# Mettre à jour peerflix : 	sudo npm update -g peerflix

# Pour lire le flux vidéo avec vlc, lui donner l'adresse du flux : http://192.168.1.x:8888/

# Penser à configurer transmission pour qu'il supprime automatiquement les fichiers .torrent
# et qu'il télécharge par défaut dans un dossier judicieux.


# Génération d'un log pour le script.

exec 3>&1 4>&2
[[ -d "${HOME}/log" ]] || mkdir "${HOME}/log"
exec 1>"${HOME}/log/$(basename "$0" .sh).log" 2>&1

prog=$(zenity --list --radiolist --height=300 --text "Choisis le programme pour ouvrir ce lien." --column "Sélection" --column "Programme" TRUE "Peerflix" FALSE "Transmission") || exit 1

case $prog in
	"Peerflix")
			dest=$(zenity --file-selection --directory --title "Choisis la destination de sauvegarde.") && x-terminal-emulator -e peerflix "$1" --mpv --path "$dest" || exit 1
		;;
	*)
			transmission-gtk "$1"
esac

