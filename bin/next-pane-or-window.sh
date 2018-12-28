#!/bin/bash

OLD_ID="$(tmux display-message -p '#{pane_id}')"
#                                 │
#                                 └ I think we need the quotes to prevent the shell
#                                 from interpreting the number sign as the beginning
#                                 of a hexcode ...

tmux select-pane -R
NEW_ID="$(tmux display-message -p '#{pane_id}')"

if [[ "${OLD_ID}" == "${NEW_ID}" ]]; then
  tmux next-window
fi
