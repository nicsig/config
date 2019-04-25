#!/bin/bash

# Purpose: Add bracketed paste mode sequences.
# Alternatively, you could also try to  use the tmux command `paste-buffer`, and
# pass it the `-p` option.

selection="\e[200~$(xsel)\e[201~"
printf -- "${selection}" | xvkbd -xsendevent -file -

