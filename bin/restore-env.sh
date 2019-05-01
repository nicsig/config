#!/bin/bash

# TODO: make sure rg is re-installed (ripgrep)

# TODO: install terminal descriptions in our home
#             ┌ (--location) if the page has moved to a different location,
#             │              redo the request on the new place
#             │
#             │┌ write output to a local file named like the remote file we get
#             ││
#     $ curl -LO http://invisible-island.net/datafiles/current/terminfo.src.gz
#     $ gunzip terminfo.src.gz
#     $ tic -x terminfo.src
#
# Or maybe we should rely on `up.sh` to do that?
# Or maybe we should version control `~/.terminfo/` (`$ config` would restore them)?

# TODO: Finish reading this: https://www.atlassian.com/git/tutorials/dotfiles
#
# Understand the commands which are given to restore our config on a new machine:
#
#     $ echo ".cfg" >> .gitignore
#     $ git clone --bare https://github.com/lacygoill/config/ $HOME/.cfg
#     $ alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
#     $ config checkout
#
#     # The previous command will probably have failed because of conflicts
#     # between some files in the repo and some pre-installed files.
#     # The next command moves the problematic pre-installed files in a backup directory.
#     # Unfortunately, it will probably also fail.
#     # You'll need to create one or two directories inside the backup directory,
#     # to reproduce the path of some files...
#     # Then, the command will succeed.
#     $ mkdir -p .config-backup && \
#       config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
#       xargs -I{} mv {} .config-backup/{}
#
#     # this time it should work
#     $ config checkout
#
#     $ config config --local status.showUntrackedFiles no

# TODO: If you use a dark theme, some input fields in firefox are unreadable.
#
# In the past, we used a custom `userContent.css` file in `~/.mozilla/firefox/xxxxxxxx.default/chrome/`.
# I've found a better solution.
# Enter `about:config` in the url bar.
# Right-click anywhere, and select the entries `new`, then `String`.
# Give the name `widget.content.gtk-theme-override` to the new string.
# Assign it the value `Adwaita`, or any installed light gtk3 theme name.
# For more info, see:
#
#     https://askubuntu.com/a/1037112/867754
#     https://bugzilla.mozilla.org/show_bug.cgi?id=1283086
#
# Find a way to automate this setting from a shell command.

# TODO: empêcher APT de mettre les paquets en cache :
# http://lehollandaisvolant.net/linux/checklist/#aptitude-cache

# TODO: configuration des programmes se lançant automatiquement au démarrage

# TODO: add PPAs (or better yet, get rid of all PPAs in your current installation)

# TODO:  suppression des  fichiers /  dossiers avant  leur remplacement  par des
# liens symboliques, car l'option `-n` de `$ ln` ne semble pas fonctionner

# TODO: restore system files backed up in:
#
#     ~/.config/etc

# TODO: disable  automatic updates  (they're especially annoying  in a  VM; they
# must be equally annoying in a live OS)
#
# https://askubuntu.com/a/1057463/867754
#
#     $ sudo systemctl disable --now apt-daily{,-upgrade}.{timer,service}
#     $ sudo dpkg-reconfigure -plow unattended-upgrades

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
sed -i.bak 's/^Restart=always/# Restart=always/' /etc/systemd/system/display-manager.service

mkdir -p /etc/systemd/system/getty@.service.d/

# turn on the Numlock key by default in a console
cat <<EOF >/etc/systemd/system/getty@.service.d/activate-numlock.conf
[Service]
StandardInput=/dev/%I
ExecStartPre=setleds -D +num
EOF

# customize the keyboard layout in a console
cat <<EOF >/etc/systemd/system/getty@.service.d/keyboard-layout.conf
[Service]
ExecStartPre=/usr/bin/loadkeys /home/${USER}/.config/keyboard/vc.conf
EOF

# make the background color of a console white immediately (before a successful login)
cat <<EOF >/etc/systemd/system/getty@.service.d/white-background.conf
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

# Installation of some deb packages {{{1

apt-get install aptitude

aptitude install \
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
  xclip \
  xdg-utils \
  xsel \
  xvkbd

# TODO: Add more.
# Have a look at all the packages that you have manuall installed:
#
#     $ comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)
#     $ comm -23 <(aptitude search '~i !~M' -F '%p' | sed "s/ *$//" | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)
#
# https://askubuntu.com/a/492343/867754
# Also,  read the  book  “The Debian  Administrator's  Handbook”, section  6.2.2
# Installing and Removing.
# It  contains a  tip entitled  “TIP Installing the  same selection  of packages
# several times”, which does exactly what we want.

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

printf -- '\nInstalling zsh-syntax-highlighting\n'
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/GitRepos/zsh-syntax-highlighting"

# Removal of some deb packages {{{1

# Note that removing `update-notifier` will cause `aptitude` to remove `xubuntu-desktop`.{{{
#
# Which is ok.
# From `$ aptitude show xubuntu-desktop`:
#
#     It is safe to remove this package if some of the desktop system packages are not desired.~
#}}}
aptitude purge whoopsie update-notifier

# Set default applications {{{1

# How to set the default application to open a particular type of file?{{{
#
#     # get the mime type of the file
#     $ xdg-mime query filetype some_file.mp4
#     video/mp4~
#
#     # get the current default application used to handle this mime type
#     $ xdg-mime query default <previous mime type>
#     parole.desktop~
#
#     # if you want mpv to be the new default, first make sure it has a .desktop file
#     $ locate -r '.*mpv.*.desktop'
#
#     # use it to set mpv as the new default application to open mp4 files
#     $ xdg-mime default mpv.desktop video/mp4 ...
#                                              ├─┘
#                                              └ you can write several mime types
#}}}
xdg-mime default mpv.desktop video/mp4

# Symlinks creation {{{1

cd "${HOME}"/.mozilla/firefox/*.default
[[ ! -d 'chrome' ]] && mkdir chrome
cp ~/.config/home/user/.mozilla/firefox/xxx.default/chrome/userContent.css ~/.mozilla/firefox/*.default/chrome/userContent.css

printf -- "\nCreating symlinks pointing to config files in the Dropbox directory.\n"

cd "${HOME}"
dpath="${HOME}/Dropbox/conf"

ln -sfn "${dpath}/bin" bin
# l'option -f force la création du lien symbolique même si un élément de même nom existe déjà
# -n : dans le cas où la cible est un dossier, si un élément de même nom que le lien existe déjà,
#on se retrouve avec un lien symbolique à l'intérieur du dossier
#-n = --no-dereference   empêche ce comportement
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

