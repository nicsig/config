#!/bin/bash

for plugin in $*; do
  cd "$HOME/.vim/plugged/${plugin}"
  # Alternative:{{{
  #
  # unstaged changes?
  #     git diff --exit-code
  # staged but not committed?
  #     git diff --cached --exit-code
  #
  # Source:
  #     https://stackoverflow.com/a/5139672/8243465
  #
  #}}}
  # Source:
  #     https://stackoverflow.com/a/8182309/9780968
  ( [[ -z "$(git status -s)" ]] && [[ -z "$(git diff @{u}..)" ]]) \
    || (printf -- '%s\n    modified/untracked\n\n' "${plugin}")
done

