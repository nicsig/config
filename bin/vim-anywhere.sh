#!/bin/bash

# Source:
# https://www.reddit.com/r/vim/comments/82178l/use_vim_to_edit_text_anywhere/

setclip() {
  xclip -selection c
}

getclip() {
  xclip -selection clipboard -o
}

file=$(mktemp)
urxvt -e vim "${file}"

cat "${file}" | setclip
rm "${file}"

# FIXME:
# It should paste the clipboard automatically.
# Doesn't work.
# I have to press C-v myself.
xdotool key ctrl+v



# Alternative:

#@ file=$(mktemp)
#@ xclip -o > "${file}"

#@ urxvt -e vim "${file}"

#@ head -c -1 "${file}" | xdotool type --clearmodifiers --delay 0 --file -
#@ rm "${file}"
