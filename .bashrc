# How to restore the file to its default contents?{{{
#
#     :%d_
#     :0r /etc/skel/.bashrc
#}}}
# Where can I find some completion functions or script examples?{{{
#
#     /usr/share/doc/bash/examples/
#
# If the directory does not exist, install the package `bash-doc`.
#}}}

# TODO: review this file:
#
#    - can we delete things?
#    - is everything fully understood/explained?

# TODO: review ~/.inputrc

# If not running interactively, don't do anything
# Why don't you use the single line `[[ $- = *i* ]] || return` (shorter)?{{{
#
#     1. It's not posix-compliant.
#     2. The `case` syntax seems more powerful.
#}}}
case "$-" in
  *i*) ;;
  *) return ;;
esac

# set variable identifying the chroot you work in (used in the prompt below)
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# TODO: Include exit code of last command in prompt.{{{
#
# See here for inspiration:
#
#     # https://stackoverflow.com/a/16715681/9780968
#
#     # Func to gen PS1 after CMDs
#     __prompt_command() {
#         # This needs to be first
#         local EXIT="$?"
#         PS1=""
#         local RCol='\[\e[0m\]'
#         local Red='\[\e[0;31m\]'
#         local Gre='\[\e[0;32m\]'
#         local BYel='\[\e[1;33m\]'
#         local BBlu='\[\e[1;34m\]'
#         local Pur='\[\e[0;35m\]'
#         if [ $EXIT != 0 ]; then
#             # Add red if exit code non 0
#             PS1+="${Red}\u${RCol}"
#         else
#             PS1+="${Gre}\u${RCol}"
#         fi
#         PS1+="${RCol}@${BBlu}\h ${Pur}\W${BYel}$ ${RCol}"
#     }
#     PROMPT_COMMAND=__prompt_command
#}}}
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

# Sourcing {{{1
# Warning: Don't move `Sourcing` after `Key bindings`!{{{
#
# It would give  priority to the key bindings defined  in third-party files over
# ours.
#}}}

# Why don't you export your environment variables here?{{{
#
# > You should not define environment variables in ~/.bashrc. The right place to
# > define environment variables such as  PATH is ~/.profile (or ~/.bash_profile
# > if you don't care about shells other than bash).
#
# Source: https://unix.stackexchange.com/a/26059/289772
#}}}
# Ok, but why using `~/.bashenv` and not `~/.bash_profile`?{{{
#
# It would create a loop, because we source bashrc from bash_profile.
# Also, I like the idea of a dedicated file for exporting environment variables,
# because of the symmetry with `~/.zshenv`.
#}}}
. $HOME/.bashenv

# What's the purpose of this command?{{{
#
# It  installs  programmable  completion  functions for  the  most  common  Unix
# commands.
#}}}
# Will it work on a new machine?{{{
#
# No.
#
# You need to install the `bash-completion` package.
#}}}
# What's the equivalent in zsh?{{{
#
#     % autoload -Uz compinit
#     % compinit
#}}}
# How to make sure it worked as expected?{{{
#
# Type:
#
#     $ help Tab Tab
#
# Bash should complete `:` (which is a command).
# If bash completes a filename, the completion functions were not installed.
#}}}
# Warning:{{{
#
# This breaks the Tab completion of hostnames (taken from `/etc/hosts`).
#
# The  issue seems  to be  that this  sourced file  disables the  'hostcomplete'
# option (`shopt -u`).
# But even  if you  manually re-enable  it (`shopt  -s hostcomplete`),  it still
# doesn't work.
# `M-@` (hostname-specific completion) and `C-x @` (list matches) still work though.
#}}}
. /etc/bash_completion

# Aliases {{{1

alias options='vim -O <(set -o) <(shopt -s) <(shopt -u) <(bind -v)'
#                                                         │
#                                                         └ readline variables

# Key bindings {{{1
# CTRL {{{2
# C-SPC        magic-space {{{3

# automatic history expansion (`!!`) when inserting a space
# WARNING:
# don't write this in `~/.inputrc`, it would prevent us from inserting spaces
# inside various programs (python, rlwrap) …
bind '" ": magic-space'

# C-x C-f/F    character-search {{{3

bind '"\C-x\C-f":  character-search'
bind '"\C-x\C-F":  character-search-backward'

# C-x C-s      reexecute-with-sudo {{{3

# re-execute last command with `sudo`
bind '"\C-x\C-s": "sudo -E PATH= $PATH bash -c \"!!\" \C-m"'

bind '"\C-t": transpose-chars'

# C-x C-v: read output of command inside Vim
bind '"\C-x\C-v": "\C-e | vim -R --not-a-term -\C-m"'

# C-x c        snippet-compare {{{3

bind '"\C-xc": "\C-a\C-kvimdiff <() <()\e5\C-b"'

# C-x r        snippet-rename {{{3

bind '"\C-xr": "\C-a\C-kfor f in *; do mv \"$f\" \"${f}\";done\e7\C-b"'
#          │
#          └ Rename
# }}}2
# META {{{2
# M-m       display man for the current command {{{3

bind '"\em": "\C-aman \ef\C-k\C-m"'
#             │   │   │  │
#             │   │   │  └ kill everything after, up to the end of the line
#             │   │   └ move 1 word forward
#             │   └ type `man `
#             └ go to beginning of line

# M-z       previous directory {{{3

# FIXME: how to refresh the prompt?
previous_directory() {
  # check that `$OLDPWD` is set otherwise we get an error
  [[ -z "${OLDPWD}" ]] && return
  cd -
}
bind -x '"\ez": previous_directory'

# }}}2
# CTRL-META {{{2
# C-M-b     execute the current command line silently {{{3

# NOTE:
# In emacs, we write `C-M-b`, but if we hit this key in the terminal (after
# executing `cat`), we see that the latter receives `Escape` + `C-b`.
# So, in our next key binding, the `lhs` must be `\e\C-b`, and not `\C-\eb`.
#
#           ┌ Black hole
#           │
# bind '"\e\C-b":  "\C-e >/dev/null 2>&1 &\C-m"'
#                                      │
#                                      └ execute in the background

# Update:
# I've commented the key binding because I hit it by accident too often.
# It happens when I press Escape then C-b quickly afterwards.
#}}}1
# Options {{{1

# Typing a directory name alone is enough to cd into it
shopt -s autocd

# If I try to exit bash, and a job is attached
shopt -s checkjobs

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# Used by the `select` command to determine the column length and the terminal
# width when printing selection lists.
shopt -s checkwinsize

# don't allow a `>` redirection to overwrite the contents of an existing file
# use `>|` to override the option
set -o noclobber

# Enable the pattern `**` to match match all files and zero or more directories
# and subdirectories. `**/` matches any path to a folder.
shopt -s globstar

# append to the history file, don't overwrite it
shopt -s histappend

# After a failed history expansion (e.g.: !<too big number>), don't give me an
# empty prompt. Reload it (unexpanded) into the readline editing buffer for
# correction.
shopt -s histreedit

# After a history expansion, don't execute the resulting command immediately.
# Instead,  write the expanded command into the readline editing  buffer for
# further modification.
shopt -s histverify

