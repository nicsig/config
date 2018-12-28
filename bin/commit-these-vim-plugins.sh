#!/bin/bash

plugins=( \
  'asyncmake' \
  'goyo.vim' \
  'limelight.vim' \
  'potion' \
  'vim-abolish' \
  'vim-awk' \
  'vim-brackets' \
  'vim-breakdown' \
  'vim-bullet-list' \
  'vim-capslock' \
  'vim-cmdline' \
  'vim-column-object' \
  'vim-comment' \
  'vim-completion' \
  'vim-conf' \
  'vim-cwd' \
  'vim-debug' \
  'vim-draw' \
  'vim-exchange' \
  'vim-fex' \
  'vim-fold' \
  'vim-freekeys' \
  'vim-gitcommit' \
  'vim-graph' \
  'vim-gx' \
  'vim-help' \
  'vim-hydra' \
  'vim-iabbrev' \
  'vim-interactive-lists' \
  'vim-latex' \
  'vim-lg-lib' \
  'vim-logevents' \
  'vim-lua' \
  'vim-man' \
  'vim-markdown' \
  'vim-matchit' \
  'vim-math' \
  'vim-par' \
  'vim-python' \
  'vim-qf' \
  'vim-quickhl' \
  'vim-readline' \
  'vim-reorder' \
  'vim-repeat' \
  'vim-save' \
  'vim-schlepp' \
  'vim-search' \
  'vim-selection-ring' \
  'vim-session' \
  'vim-sh' \
  'vim-snippets' \
  'vim-source' \
  'vim-stacktrace' \
  'vim-statusline' \
  'vim-submode' \
  'vim-term' \
  'vim-titlecase' \
  'vim-tmuxify' \
  'vim-toggle-settings' \
  'vim-unix' \
  'vim-vim' \
  'vim-window' \
  )

for plugin in "${plugins[@]}"; do
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

