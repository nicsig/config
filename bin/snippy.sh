#!/bin/bash

# video demo at:
#
#     http://www.youtube.com/watch?v=90xoathBYfk
#
# written by "mhwombat":
#
#     https://bbs.archlinux.org/viewtopic.php?id=71938&p=2

# Dependencies:
#
#     - dmenu
#     - xsel
#     - xdotool

# To use:
#
# 1. Create directory `~/.snippy/`
#
# 2. Create a file in that directory for each snippet that you want.
#    The filename will be used as a menu item.
#
#    TIP: If you have a lot of snippets, you can organise them into
#    subdirectories under ~/.snippy.
#
# 3. Bind a convenient key combination to this script.
#
#    TIP: If you're using XMonad, add something like this to xmonad.hs
#      ((mod4Mask, xK_s), spawn "/path/to/snippy")

DIR="${HOME}/.snippy"

DMENU_ARGS='-b -fn Monospace-20:normal'
#            |  |
#            |  +-- font style and size
#            +-- dmenu appears at the bottom of the screen

XSEL_ARGS='--clipboard --input'
#            |           |
#            |           +-- read standard input into the selection
#            +-- operate on the CLIPBOARD selection

cd "${DIR}"

# Use the filenames in the snippy directory as menu entries.
# Get the menu selection from the user.
FILE=$(find . -type f | sed 's:\./::' | /usr/bin/dmenu "${DMENU_ARGS}")
#      │                │               │
#      │                │               └ ask user to choose entry in dmenu
#      │                └ remove leading `./` from path
#      └ list files in the snippy directory (recursively; any depth)

if [[ -f "${DIR}/${FILE}" ]]; then
  # Put the contents of the selected file into the paste buffer.
  xsel "${XSEL_ARGS}" < "${DIR}/${FILE}"
  # Paste into the current gui application.
  xdotool key ctrl+v
  # Paste into the current cli application.
#  xdotool key ctrl+shift+v
fi
