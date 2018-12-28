#!/bin/bash

#TODO empêcher APT de mettre les paquets en cache :
# http://lehollandaisvolant.net/linux/checklist/#aptitude-cache

#TODO configuration des programmes se lançant automatiquement au démarrage

#TODO ajout des PPAs

#TODO suppression des fichiers / dossiers  avant leur remplacement par des liens
# symboliques # car l'option -n de ln ne semble pas fonctionner

# TODO: restore system files backed up in:
#
#     ~/.config/etc

# System files {{{1

# allow all SysRq functions to be invoked from command keys
echo 'kernel.sysrq = 1' >>/etc/sysctl.conf

# turn on the Numlock key in a X session, as soon as lightdm starts
aptitude install numlockx
echo 'greeter-setup-script=/usr/bin/numlockx on' >>/etc/lightdm/lightdm.conf

# customize `sudo`
mkdir -p /tmp/sudoers.d/
cat <<EOF >/etc/sudoers.d/my_modifications
Defaults    pwfeedback
Defaults    timestamp_timeout=30

${USER} ${HOSTNAME}=(root)NOPASSWD:/usr/bin/aptitude update,/usr/bin/aptitude upgrade
${USER} ${HOSTNAME}=(root)NOPASSWD:/usr/bin/aptitude install *,/usr/bin/aptitude purge *
${USER} ${HOSTNAME}=(root)NOPASSWD:/usr/bin/aptitude safe-upgrade
${USER} ${HOSTNAME}=(root)NOPASSWD:/usr/bin/systemctl
%admin ${HOSTNAME}=(root)NOEXEC:/usr/local/bin/vim
EOF

# When we press `M-SysRq-e`, we don't want systemd to restart the display manager.
sed -in 's/^Restart=always/# Restart=always/' /etc/systemd/system/display-manager.service

mkdir -p /etc/systemd/system/getty@.service.d/

cat <<EOF >/etc/systemd/system/getty@.service.d/activate-numlock.conf
[Service]
StandardInput=/dev/%I
ExecStartPre=setleds -D +num
EOF

cat <<EOF >/etc/systemd/system/getty@.service.d/keyboard-layout.conf
[Service]
ExecStartPre=/usr/bin/loadkeys /home/${USER}/.config/keyboard/vc.conf
EOF

cat <<EOF >/etc/systemd/system/getty@.service.d/activate-numlock.conf
[Service]
StandardOutput=/dev/%I
ExecStartPre=/usr/bin/setterm -background white -foreground black -store
#                             │{{{
#                             └ we could also use `--`,
#                               but `man setterm` recommends to use `-` in a script
#                               (section `COMPATIBILITY`)
#}}}
ExecStartPre=/usr/bin/clear
EOF

# Removal of some deb packages {{{1

# Note that removing `update-notifier` will cause `aptitude` to remove `xubuntu-desktop`.{{{
#
# Which is ok.
# From `aptitude show xubuntu-desktop`:
#
#     It is safe to remove this package if some of the desktop system packages are not desired.
#}}}
aptitude purge whoopsie update-notifier

# Installation of some deb packages {{{1
aptitude install aptitude \
  checkinstall \
  conky-all \
  curl \
  gdebi \
  git \
  highlight \
  keepassx \
  libreoffice \
  mpv \
  nodejs \
  nodejs-legacy \
  npm \
  par \
  p7zip-full \
  sudo \
  synaptic \
  trash-cli \
  wmctrl \
  xdg-utils \
  xsel

# TODO: Add more.
# Have a look at all the packages that you have manuall installed:
#
#     $ comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)
#     $ comm -23 <(aptitude search '~i !~M' -F '%p' | sed "s/ *$//" | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)
#
# https://askubuntu.com/a/492343/867754

# Installation of some git repos {{{1

mkdir "${HOME}/GitRepos"

printf -- '\nInstalling ranger\n'

git clone git://git.savannah.nongnu.org/ranger.git "${HOME}/GitRepos/ranger"
cd ranger
git checkout stable
git pull
ranger --copy-config=all

printf -- '\nInstalling fasd\n'

git clone https://github.com/clvv/fasd "${HOME}/GitRepos/fasd"
cd "${HOME}/GitRepos/fasd" && checkinstall

printf -- '\nInstalling pathogen: https://github.com/tpope/vim-pathogen#installation\n'

mkdir -p "${HOME}/.vim/autoload" "${HOME}/.vim/bundle" && \
curl -LSso "${HOME}/.vim/autoload/pathogen.vim" https://tpo.pe/pathogen.vim

printf -- '\nInstalling vim-instant-markdown\n'
cd "${HOME}" && npm -g install instant-markdown-d
git clone https://github.com/suan/vim-instant-markdown "${HOME}/.vim/bundle/vim-instant-markdown"

printf -- '\nInstalling tmux plugin manager\n'
mkdir -p "${HOME}/.tmux/plugins/tpm" &&
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"

printf -- '\nCreate the directory ~/.zsh/completion\n' &&
  mkdir "${HOME}/.zsh/completion"

printf -- '\nInstalilng zsh-syntax-highlighting\n'
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/GitRepos/zsh-syntax-highlighting"

# Dropbox {{{1

printf -- '\nInstalling dropbox: https://www.dropbox.com/install?os=lnx\n'

# download dropbox
#     https://www.dropbox.com/install
cd "${HOME}" && wget -O - 'https://www.dropbox.com/download?plat=lnx.x86_64' | tar xzf -
# start the daemon
"${HOME}/.dropbox-dist/dropboxd"

# si dropbox ne tourne pas le script s'arrête
# parce qu'on va créer des liens symboliques pointant vers dropbox
[[ ! "$(pidof dropbox)" ]] && exit 1

# Symlinks creation {{{1

printf -- "\nCreating symlinks pointing to config files in the Dropbox directory.\n"

cd "${HOME}"
dpath="${HOME}/Dropbox/conf"

ln -sfn "${dpath}/bin" bin  # l'option -f force la création du lien symbolique même si un élément de même nom existe déjà
        # -n : dans le cas où la cible est un dossier, si un élément de même nom que le lien existe déjà,
        #      on se retrouve avec un lien symbolique à l'intérieur du dossier
        #      -n = --no-dereference   empêche ce comportement
        # malheureusement ne semble pas fonctionner... Pk ?

ln -sfn "${dpath}/bash_aliases" .bash_aliases
ln -sfn "${dpath}/cheat" .cheat
ln -sfn "${dpath}/conky" .conky
ln -sfn "${dpath}/guake" "${HOME}/.gconf/apps/guake"
ln -sfn "${dpath}/gvimrc" .gvimrc
ln -sfn "${dpath}/icons" .icons

# Contrairement aux  autres fichiers, .inputrc et .profile sont  des fichiers de
# conf' système préexistants.
# Faudra  faire  gaffe dans  le  temps,  à ce  qu'ils  ne  cassent pas  de  futurs
# installations.

ln -sfn "${dpath}/inputrc" .inputrc
ln -sfn "${dpath}/profile" .profile

ln -sfn "${dpath}/mpv" .mpv

ln -sfn "${dpath}/ranger" .config/ranger
ln -sfn "${dpath}/shrc" .shrc
ln -sfn "${dpath}/tmux/" .tmux
ln -sfn "${dpath}/tmux.conf" .tmux.conf
ln -sfn "${dpath}/Trolltech.conf" .config/Trolltech.conf
ln -sfn "${dpath}/vim" .vim
ln -sfn "${dpath}/vimperator" .vimperator
ln -sfn "${dpath}/vimperatorrc" .vimperatorrc
ln -sfn "${dpath}/vimrc" .vimrc
ln -sfn "${dpath}/weechat" .weechat
ln -sfn "${dpath}/xfce4-keyboard-shortcuts.xml" .config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
ln -sfn "${dpath}/zim" .config/zim
ln -sfn "${dpath}/zsh_aliases" .zsh_aliases
ln -sfn "${dpath}/zshrc" .zshrc
ln -sfn "${dpath}/zsh_aliases" .zsh_aliases
ln -sfn "${dpath}/zsh/" .zsh/

cd "${HOME}"/.mozilla/firefox/*.default
# si le dossier chrome n'existe pas on le crée
[[ ! -d 'chrome' ]] && mkdir chrome
ln -sfn "$dpath"/userContent.css ./chrome/userContent.css

