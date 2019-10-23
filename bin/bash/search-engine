#!/bin/bash

# Why?{{{
#
# We make sure  that the locale used by  the shell, in which the  script will be
# executed, is `fr_FR.UTF-8`.
#
# Otherwise, if the  locale currently used doesn't  support accented characters,
# we won't be able to insert the latter when typing our search.
#}}}
# What should I do if the `fr_FR.UTF-8` locale has not yet been generated on my machine?{{{
#
# Execute this command:
#         sudo dpkg-reconfigure locales
#
# Or:
#         sudo locale-gen fr_FR.UTF-8
#         sudo update-locale
#
# To see which locales have already been generated on the system:
#         locale -a
#}}}
LC_ALL=fr_FR.UTF-8

clear
printf -- '\n'

# Is there an alternative?{{{
#
# Yes.
#
# We could pass the `-e` flag to the `read` builtin like so:
#
#               ┌ if the standard input is coming from a terminal,
#               │ `readline` is used to obtain the line
#               │
#         read -ep 'Enter your search: ' mysearch
#                │
#                └ display prompt on standard error, without a trailing newline,
#                  before attempting to read any input
#}}}
# Why don't you use it?{{{
#
# We also want to be able to recall last searches.
# So, we  use `rlwrap` instead,  because according  to `man rlwrap`,  the latter
# provides persistent history + line editing:
#
#     rlwrap runs  the specified  command, intercepting user  input in  order to
#     provide readline's line editing, persistent history and completion.
#}}}
mysearch="$(rlwrap bash -c 'read -p "Enter your search: " search; printf -- "%s" "${search}"')"
#                  │{{{
#                  └ `rlwrap` expects an external command,
#                    not a builtin shell command like `read`;
#                    so we need to wrap `read` inside a `bash` subshell;
#                    it works because `bash` is an external command
#}}}

# Why the redirections?{{{
#
# Without, we could have spurious bugs.
# Sometimes the script fails to open a link, because "firefox is already
# running".
#}}}
sr "$1" ${mysearch} >/dev/null 2>&1
# FIXME: Currently, I don't quote `${mysearch}`,{{{
# because when our query contains several keywords separated by spaces, it would
# send it with double quotes around it.
#
# As  a consequence,  the search  engine would  limit the  results to  the pages
# containing the exact  sequence of keywords we queried, instead  of any webpage
# containing one or more of our keywords in any particular order.
#
# But if it contains a glob (like `*`), it will be expanded.
# How to protect them without quoting `mysearch`?
#
# Try to search `grep -E vs egrep`.
# It doesn't work.
# Probably linked to this.
#
# Update:
# The same issue exists when the search contains a hyphen.
#}}}

# Why `sleep`?{{{
#
# Without no webpage is opened.
#}}}
sleep .5 && tmux kill-pane

