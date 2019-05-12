#!/bin/bash

# TODO: The tmux faq uses another command:{{{
#
#     $ uptime|awk '{split(substr($0, index($0, "load")), a, ":"); print a[2]}'
#
# https://github.com/tmux/tmux/wiki/FAQ#what-is-the-best-way-to-display-the-load-average-why-no-l
#
# Is it faster?
#}}}
ncore=$(lscpu | grep -i 'cpu(s)' | head -n1 | awk '{ print $2 }')

avg1=$(cut -d' ' -f1 /proc/loadavg)
avg1=$(bc <<< "100*${avg1}/${ncore}")
printf -- '%s' "${avg1}"
