#!/bin/bash

# Purpose: Paste the primary selection in the terminal.
# Dependencies: xvkbd
# Limitation: You can paste the primary selection only once.
# Or twice if you're in urxvt.
# Source:
# https://askubuntu.com/a/7807/867754
# https://unix.stackexchange.com/a/11890/289772

# Add bracketed paste mode sequences{{{
#
# ... to prevent the shell from automatically processing the input buffer if the
# pasted text contains a newline.
#
# Alternatively, you could also try to  use the tmux command `paste-buffer`, and
# pass it the `-p` option.
#}}}
selection="\e[200~$(xsel)\e[201~"
printf -- "${selection}" | xvkbd -xsendevent -file - 2>/dev/null
# FIXME: Doesn't work in xterm nor in gnome-terminal. But works in st and urxvt.{{{
#
# MWE:
#
#     $ printf "test" | xvkbd -xsendevent -file -
#}}}
# FIXME: fails on multibyte characters (e.g. 'éòü'){{{
#
#     $ xvkbd -text 'éòü' 2>/dev/null
#     Ã©Ã²Ã¼~
#
# ---
#
# It may also fail on a percent character.
#
# MWE:
# Write a percent character in `/tmp/md.md`.
# Run `:Preview`.
# Select the percent character.
# Try to paste it on the shell's command-line.
#
# Result: nothing is inserted.
#
# ---
#
# Solution: Try  to get  the  primary selection,  then use  it  to populate  the
# clipboard selection, and finally run `$ xdotool` to simulate `C-S-v`.
#
#     # get the primary selection
#     text="\e[200~$(xsel)\e[201~"
#     # populate the clipboard selection with the primary selection
#     printf -- "${text}" | xsel -i --clipboard
#     # simulate a press on C-S-v
#     xdotool key 'ctrl+shift+v'
#
# The code works, except for the last `$ xdotool` command.
# The syntax seems good, since the command works when run in an interactive shell.
#
# The issue can be reproduced with just the `$ xdotool` command.
# But  only  if  we invoke  this  script  via  the  key binding  installed  from
# `~/.config/keyboard/xbindkeys.conf`.
# Btw, in the latter file, right above the key binding, we've written that `$ xdotool`
# was to avoid; I wonder whether that has something to do with our current issue.
#}}}

# `-xsendevent` {{{
#
# >     Make xvkbd to use XSendEvent() to simulate keyboard events,  as  it
# >     was  in xvkbd version 1.0.  xvkbd version 1.1 and later will try to
# >     use XTEST extension instead in the default configuration.
# >     If XTEST extension is not supported by the  X  server,  xvkbd  will
# >     automatically switch to this mode.
# >     Resource `xvkbd.xtest: false` has the same function.
#}}}
# `-file filename` {{{
# >     Send the contents of the specified file to the focused window  (see
# >     also  `-window`  option).   If `-` was specified as the filename,
# >     string to be sent will be read from the standard input (stdin).
# >     If this option is specified, xvkbd will not  open  its  window  and
# >     terminate soon after sending the string.
#}}}
