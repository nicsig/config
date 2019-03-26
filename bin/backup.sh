#!/bin/bash

# TODO: Install a cron  job to automatically call this script  from time to time
# make a backup and maybe upload it to some remote machine.

# TODO:
# I don't want to version control  `~/.zsh_history` on a public site, because it
# may contain  sensitive data, like a  password which was pasted  by accident on
# the command-line.
#
# However, we can use this script to make a backup on a usb stick.
# If we do so, we need to encrypt it first.

# Possible values:
#     /media/$USER/usb-2g-blue/backup
#     /media/$USER/5d18be51-3217-4679-9c72-a54e0fc53d6b/home/pi/backup
DEST="$1"
if [[ -z "$1" ]]; then
  printf -- 'provide the destination directory\n' "$1"
  exit 65
elif [[ ! -d "$1" ]]; then
  printf -- '%s is not a directory\n' "$1"
  exit 65
fi

# miscellaneous
misc=( \
  "${HOME}/Dropbox/ebooks/Later" \
  "${HOME}/Dropbox/ebooks/Now" \
  "${HOME}/Dropbox/addons_anki" \
  "${HOME}/Dropbox/collection.apkg" \
  "${HOME}/Dropbox/Notebooks" \
  "${HOME}/Dropbox/others_vimrc" \
  "${HOME}/Dropbox/vim_plugins" \
  "${HOME}/Dropbox/ODT" \
  "${HOME}/Desktop" \
  "${HOME}/mdp.kdbx" \
  "${HOME}/wiki" \
  "${HOME}/.zsh_history" \
)
for source in "${misc[@]}"; do
  # For more info about `--exclude=`: https://unix.stackexchange.com/a/56167
  rsync -ahPuzR --delete --stats --exclude='.git*' "${source}" "${DEST}"
done

# config
git --git-dir="${HOME}/.cfg/" --work-tree="${HOME}" add -u
# We need to commit because if we've recently added new files, they won't appear
# in the output of `ls-tree`.
git --git-dir="${HOME}/.cfg/" --work-tree="${HOME}" commit -m 'update'
git --git-dir="${HOME}/.cfg" --work-tree="${HOME}" ls-tree --full-tree --name-only HEAD -r | sed "s:^:$HOME/:" | xargs -I'{}' rsync -ahPuzR --delete --stats --exclude='.git*' '{}' "${DEST}"

# Vim plugins
plugins=( \
  asyncmake \
  goyo.vim \
  limelight.vim \
  potion \
  vim-abolish \
  vim-autoread \
  vim-awk \
  vim-brackets \
  vim-breakdown \
  vim-bullet-list \
  vim-capslock \
  vim-cheat40 \
  vim-cmdline \
  vim-column-object \
  vim-comment \
  vim-completion \
  vim-cwd \
  vim-debug \
  vim-draw \
  vim-exchange \
  vim-fex \
  vim-fold \
  vim-freekeys \
  vim-gitcommit \
  vim-gitconfig \
  vim-graph \
  vim-gx \
  vim-help \
  vim-hydra \
  vim-iabbrev \
  vim-interactive-lists \
  vim-latex \
  vim-lg-lib \
  vim-logevents \
  vim-markdown \
  vim-matchit \
  vim-math \
  vim-par \
  vim-python \
  vim-qf \
  vim-quickhl \
  vim-readline \
  vim-reorder \
  vim-repeat \
  vim-save \
  vim-schlepp \
  vim-search \
  vim-selection-ring \
  vim-session \
  vim-sh \
  vim-snippets \
  vim-source \
  vim-stacktrace \
  vim-statusline \
  vim-submode \
  vim-term \
  vim-titlecase \
  vim-tmux \
  vim-tmuxify \
  vim-toggle-settings \
  vim-unix \
  vim-vim \
  vim-window \
  vim-xkb \
)
for plugin in "${plugins[@]}"; do
  rsync -ahPuzR --delete --stats --exclude='.git*' "${HOME}/.vim/plugged/${plugin}" "${DEST}"
done

