#!/bin/bash

OLD_ID=$(tmux display-message -p '#{pane_id}')
tmux select-pane -L
NEW_ID=$(tmux display-message -p '#{pane_id}')

if [[ $OLD_ID == "$NEW_ID" ]]; then
  tmux previous-window
fi

