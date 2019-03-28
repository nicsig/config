#!/bin/bash

# Script à placer dans /usr/local/bin.

# Il ne devrait être exécutable que par root (chmod go-x).

# Il reste à terminer. On pourra entre autres s'inspirer de ce thread :
# https://www.debian-fr.org/aptitude-gestion-des-dependances-et-orphelins-t35575.html

# On vérifie que le script est bien lancé par root.
# Pour ce  faire on utilise la  variable d'environnement EUID, qui  stocke l'ID de
# l'utilisateur au nom duquel est lancé le script.
# On pourrait aussi y accéder via la commande : id -u

if [[ "${EUID}" -ne 0 ]]; then
  printf -- '%s: restart as root.\n' "$(basename "$0")" >&2
  # 77 = not sufficient permission
  exit 77
fi

cd /tmp
> /tmp/orphans_ignored
> /tmp/orphans_list

# La  prochaine boucle  while  est  exécutée tant  que  la  chaîne contenant  le
# résultat de la commande deborphan est non vide.

orphan=$(deborphan -a --ignore-suggests --no-show-section| head -n1)
# `-a` permet d'aller  chercher dans toutes les sections de  paquets, et non pas
# seulement dans la section libs.
# `--ignore-suggests` permet de considérer un  paquet comme orphelin même s'il est
# juste suggéré par un autre.

while [[ -n "${orphan}" ]]; do

  clear

  cat <<EOF
Some orphan packages are present.
The next orphan package is:
    ${orphan}

EOF

  printf -- "\n'%s' paquet est installé pour la raison suivante :\n" "${orphan}"
  aptitude why "${orphan}"
  printf -- "\nInformations détaillées sur '%s' :\n" "${orphan}"
  aptitude show "${orphan}"

  answer=
  while [[ "${answer}" != 'p' ]] && [[ "${answer}" != 'l' ]] && [[ "${answer}" != 'n' ]]; do
    printf -- '\n'
    read -n1 -r -p \
        "Souhaitez-vous le purger (p), le mettre en liste blanche (l) ou ne rien faire (n) ? (p/l/n) " \
        answer
  done

  printf -- '\n'

  case "${answer}" in
    "p")
      printf -- '\nSuppression du paquet '%s'...\n' "${orphan}"
      aptitude purge "${orphan}"
      ;;
    "l")
      printf -- '\n%s ne sera pas supprimé et ajouté à la liste blanche deborphan.\n' "${orphan}"
      deborphan -A "${orphan}"
      ;;
    "n")
      printf -- '\n%s ne sera ni supprimé ni ajouté à la liste blanche de deborphan.\n' "${orphan}"

      printf -- '%s\n' "${orphan}">> orphans_ignored

      # TODO Dans ce cas il va falloir créer une liste des paquets non supprimés
      # et  non mis  en liste  blanche puis  comparer ce  fichier à  la sortie  de
      # deborphan.
      # Les lignes présentes dans la sortie  de deborphan mais pas dans ce fichier
      # devront être traitées...
      # Début de solution pour faire cette comparaison :
      #
      #     http://stackoverflow.com/questions/4780203/deleting-lines-from-one-file-which-are-in-another-file/4780240#4780240

      # À noter qu'en +, la  suppression d'un paquet peut entraîner l'apparition
      # de nouveaux paquets orphelins.

      # Et la mise en liste blanche d'un paquet peut-elle produire le même effet
      # ?
      # Genre, j'ai un  paquet orphelin A (et  un paquet B qui  n'est pas orphelin
      # car A dépend de B).
      # Si je mets  A en liste blanche,  B devient-il orphelin (a  priori je dirai
      # non, mais à vérifier...).

      ;;
  esac

  deborphan -a --ignore-suggests --no-show-section >orphans_list
  orphan="$(sort -u orphans_list orphans_ignored | head -n1)"

done

printf -- '\nPurge des fichiers de configuration laissés par des paquets supprimés...\n'
aptitude purge '~c'
printf -- "\nNettoyage du cache d'aptitude...\n"
aptitude clean
printf -- '\nNettoyage du cache des paquets ne pouvant plus être téléchargés...\n'
aptitude autoclean

