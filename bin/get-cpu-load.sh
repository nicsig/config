#!/bin/bash

# TODO: The tmux faq uses another command:{{{
#
#     $ uptime|awk '{split(substr($0, index($0, "load")), a, ":"); print a[2]}'
#
# https://github.com/tmux/tmux/wiki/FAQ#what-is-the-best-way-to-display-the-load-average-why-no-l
#
# Is it faster?
# Update: yes it is 3-4 times faster.
#
#     $ time zsh -c 'repeat 100 ~/bin/get-cpu-load.sh'
#     $ time zsh -c "repeat 100 uptime|awk '{split(substr($0, index($0, \"load\")), a, \":\"); print a[2]}'"
#
# ---
#
# I have had several issues where tmux crashed/hanged.
# Whenever that happened, it seemed there was an issue with this script.
# There was some weird message in tmux status line `<... sth not ready ...>`.
#
# Next time  the message appears, wait  for tmux to crash,  to get a core  and a
# backtrace.
#
# If tmux hangs, run:
#
#     $ gdb -q /path/to/running/tmux PID
#     (gdb) set logging on
#     (gdb) bt full
#     (gdb) quit
#
# The output of `bt full` should be in `gdb.txt`.
#
# I'm not sure but  `$ lscpu` may be the cause, because  once, it crashed, right
# after we faced the issue.
#}}}
ncore=$(lscpu | grep -i 'cpu(s)' | head -n1 | awk '{ print $2 }')

avg1=$(cut -d' ' -f1 /proc/loadavg)
avg1=$(bc <<< "100*${avg1}/${ncore}")
printf -- '%s' "${avg1}"
