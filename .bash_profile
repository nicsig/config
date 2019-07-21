# Why this file and why the next line?{{{
#
# By default, when bash is started as a login shell, it reads the first of any
# file among the 3 following ones:
#
#     ~/.bash_profile
#     ~/.bash_login
#     ~/.profile
#
# Also, it doesn't read `~/.bashrc` as a login shell even if it's interactive.
#
# These quirks are annoying because hard to remember.
#
# We create this file to never have to remember them again.
# https://unix.stackexchange.com/a/88266/232487
#
# Now,  bash  will  always  read  this   file  as  a  login  shell,  and  ignore
# `~/.bash_login` or `~/.profile` if they exist,  simply because this file has a
# higher priority.
#
# Besides, as an interactive shell, bash will always read `~/.bashrc`,
# because of the next line.
#
# This way, the behavior of bash is easier to understand.
# It's similar to zsh (with `.zshrc` and `.zprofile`).
#}}}
case "$-" in *i*) . ~/.bashrc;; esac

# Why don't you export your environment variables directly from this file?  Why using `~/.bashenv`?{{{
#
# We also want them to be sourced when we start an interactive bash shell.
# So, we would need to source `~/.bash_profile` from `~/.bashrc`.
# But that would create a loop, because we source our bashrc from `~/.bash_profile`.
# So,  instead, we  dedicate a  new file  for the  sole purpose  of setting  and
# exporting environment variables.
# Note that it also makes bash more  consistent with zsh; the latter also uses a
# dedicated file for environment variables (`~.zshenv`).
#}}}
# Why don't you also source `~/.profile`?{{{
#
# Forget about it completely.
# It could source `~/.bashrc`, and we've just done it.
# We don't want to source `bashrc` twice.
#}}}
. ~/.bashenv

