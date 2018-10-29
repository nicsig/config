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
#     • can we delete things?
#     • is everything fully understood/explained?

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

PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

# Sourcing {{{1
# Warning: Don't move `Sourcing` after `Key bindings`!{{{
#
# It would give  priority to the key bindings defined  in third-party files over
# ours.
#}}}

# Why don't you export your environment variables here?{{{
#
#     You  should  not  define  environment variables  in  ~/.bashrc. The  right
#     place  to define  environment variables  such  as PATH  is ~/.profile  (or
#     ~/.bash_profile if you don't care about shells other than bash).
#
# Source:
#     https://unix.stackexchange.com/a/26059/289772
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

alias bash_options='vim -O <(set -o) <(shopt -s) <(shopt -u)'

# Key bindings {{{1
# CTRL {{{2
# C-SPC        magic-space {{{3

# automatic history expansion (`!!`) when inserting a space
# WARNING:
# don't write this in `~/.inputrc`, it would prevent us from inserting spaces
# inside various programs (python, rlwrap) …
bind '" ": magic-space'

# C-r C-h  {{{3

# The default key binding to search in the history of commands is `C-r`.
# Remove it, and re-bind the function to `C-r C-h`.
bind -r "\C-r"
# Why?{{{
#
# On Vim's command line, we can't use `C-r`, nor `C-r C-r`.
# So, we use `C-r C-h`.
# To stay consistent, we do the same in the shell.
#
# Besides, we can now use `C-r` as a prefix for various key bindings.
#}}}
# How did you find the original {rhs} of this key binding?{{{
#
# Start a bash shell without removing the `C-r` key binding,
# and execute:
#     $ bind -s | vipe
#     /fzf
#}}}
bind '"\C-r\C-h": " \C-e\C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er\e^"'

# C-x C-f/F    character-search {{{3

bind '"\C-x\C-f":  character-search'
bind '"\C-x\C-F":  character-search-backward'

# C-x C-s      reexecute-with-sudo {{{3

# re-execute last command with `sudo`
bind '"\C-x\C-s": "sudo -E PATH= $PATH bash -c \"!!\" \C-m"'

# When do I need to use `-x`?{{{
#
# When the rhs invokes a custom shell FUNCTION.
# If  the rhs  invokes a  built-in  shell COMMAND  or  a macro  (i.e. a  literal
# sequence of characters to press), do NOT use `-x`.
#
# Also note that when you use `-x`, the shell sets the READLINE_LINE variable to
# the contents of the line buffer and the READLINE_POINT variable to the current
# location of the insertion point.
#
# If your custom  shell function changes the values of  these variables, it will
# be reflected in the editing state.
#}}}
bind -x '"\C-x\C-t": fzf-file-widget'

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

# M-Z       fuzzy-select-output {{{3

# insert an entry from the output of the previous command,
# selecting it with fuzzy search
bind '"\eZ": "$(!!|fzf)"'
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

# Options {{{1

# Typing a directory name alone is enough to cd into it
shopt -s autocd

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

