#!/bin/bash

df -h \
  | grep -v 'Use' \
  | awk '{print $5" : "$6}' \
  | sed 's/%//g' \
  >/tmp/disk_percent

# Don't use a `for` loop to iterate over the lines in the output of a shell command!{{{
#
#       ✘
#     $ for i in $(cut -d: -f1 /tmp/disk_percent); do
#
# For example, if one of the line contains  a star, it will be expanded into the
# filenames of the cwd.
#
# Source:
#
#     http://mywiki.wooledge.org/DontReadLinesWithFor
#     https://github.com/koalaman/shellcheck/wiki/SC2013
#}}}
while IFS= read -r i; do
#     ├──┘      ├┘{{{
#     │         └ Don't interpret a backslash as an escape character.
#     │           It must be considered to be part of the line.
#     │           In particular, a backslash-newline pair must not be interpreted
#     │           as a line continuation.
#     │
#     └ Don't iterate over the words in a line; iterate over the lines themselves
#       (by default, `$IFS` contains a space).
#
#       By emptying `$IFS` we disable word splitting.
#}}}
	if [[ "$i" -ge 90 ]]; then
    # Why do I need to quote `$i` in the following command?{{{
    #
    #     $ printf -- "The partition $(grep "$i" /tmp/disk_percent | cut -d: -f2) is full up to $i%%.\n"
    #                                       ^  ^
    #
    # Theory:
    # An expansion can contain special characters.
    # If it's passed as  an argument to a command, the  shell may interpret them
    # wrongly (!= literally).
    # So, here, you need to quote `$i` to protect its expansion from `grep`.
    # And you need to quote `$(grep ...)` to protect its expansion from `printf`.
    #
    # `$(grep  ...)` is already protected  from `printf` by the  string in which
    # it's included.
    # But this string can only protect  an expansion from a command OUTSIDE.
    # NOT from a command INSIDE the string itself.
    # This is due to  the order in which the words are  processed (`grep $i ...`
    # is processed BEFORE the result is quoted).
    #
    # So, it does not protect `$i` from `grep`, and you need to quote `$i`.
    #
    # Rule:
    # Between a  command and an  expansion passed as  argument, there MUST  be a
    # quote somewhere.
    #
    #     $ printf -- "The partition $(grep "$i
    #                 │                     │
    #                 │                     └ there must be a quote between `grep` and `$i`
    #                 │
    #                 └ there must be a quote between `printf` and `$(grep ...)`
    #}}}
    printf -- 'The partition %s is full up to %s%%.\n' \
           "$(grep "$i" /tmp/disk_percent | cut -d: -f2)" \
           "$i" \
           >>/tmp/disk_warning
	fi
done < <(cut -d: -f1 /tmp/disk_percent)
#    │ ├──────────────────────────────┘{{{
#    │ └ replace this with a temporary file
#    │  containing the output of the `cut ...` command.
#    │
#    │   This is a PROCESS substitution (<(...)),
#    │   not a COMMAND substitution ($(...)).
#    │
#    └ connect the standard input of the while loop,
#      to the output of the process substitution.
#}}}

if [[ -e /tmp/disk_warning ]]; then
	mail -a 'Content-Type: text/plain; charset=UTF-8' \
       -s 'URGENT: not enough free space!' \
       jean@localhost \
           </tmp/disk_warning
	rm /tmp/disk_warning
fi

