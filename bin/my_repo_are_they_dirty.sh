#!/bin/bash

# https://stackoverflow.com/a/2659808/9780968
for dir in "$@"; do
  cd "${HOME}/.vim/plugged/${dir}" || exit
  # git ls-files --others --error-unmatch . >/dev/null 2>&1; ec=$?
  git diff-index --quiet --cached HEAD -- && git diff-files --quiet >/dev/null 2>&1; ec=$?
  if test "$ec" = 1; then
    echo "$dir" "some untracked files"
  elif test "$ec" != 0; then
    echo "$dir" "error from ls-files"
  fi
done

