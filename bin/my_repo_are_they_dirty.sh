#!/bin/bash

DIRS=( \
  potion \
  vim-awk \
  vim-brackets \
  vim-breakdown \
  vim-bullet-list \
  vim-capslock \
  vim-cmdline \
  vim-column-object \
  vim-comment \
  vim-completion \
  vim-conf \
  vim-cwd \
  vim-debug \
  vim-draw \
  vim-exchange \
  vim-fex \
  vim-fold \
  vim-freekeys \
  vim-gitcommit \
  vim-graph \
  vim-gx \
  vim-help \
  vim-hydra \
  vim-iabbrev \
  vim-interactive-lists \
  vim-latex \
  vim-lg-lib \
  vim-logevents \
  vim-lua \
  vim-man \
  vim-markdown \
  vim-matchit \
  vim-math \
  vim-par \
  vim-python \
  vim-qf \
  vim-readline \
  vim-reorder \
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
  vim-term \
  vim-titlecase \
  vim-toggle-settings \
  vim-unix \
  vim-vim \
  vim-window \
  )

# https://stackoverflow.com/a/2659808/9780968
for dir in "${DIRS[@]}"; do
  cd "${HOME}/.vim/plugged/${dir}"
  # git ls-files --others --error-unmatch . >/dev/null 2>&1; ec=$?
  git diff-index --quiet --cached HEAD -- && git diff-files --quiet >/dev/null 2>&1; ec=$?
  if test "$ec" = 1; then
    echo "$dir" "some untracked files"
  elif test "$ec" != 0; then
    echo "$dir" "error from ls-files"
  fi
done

