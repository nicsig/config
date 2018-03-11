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
#
#     https://unix.stackexchange.com/a/88266/232487
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


# Should we source `~/.profile`?{{{
#
# No. Forget about it completely.
# It could source  `~/.bashrc`, and we've just done it. We  don't want to source
# `bashrc` twice.
#}}}


# Should we set `$PATH` from `~/.bashrc`?{{{
#
# No.
# It could  fail to  affect programs  which are  started from  a non-interactive
# shell.
#
# We source `bashrc` only in interactive shells, but maybe some programs are NOT
# started from  an interactive shell  and still rely  on `$PATH` to  be properly
# set. Maybe some which are started by the display manager?
#
#     https://unix.stackexchange.com/a/88266/232487
#
# Quote:
#
#     Many distributions,  display managers and desktop  environments arrange to
#     run ~/.profile, either by explicitly  sourcing it from the startup scripts
#     or by running a login shell.
#}}}
# Does `$PATH` get its value only from here? #{{{
#
# No.
#
# Ubuntu sets  `PATH` in `/etc/environment` or  `/etc/login.defs`. This explains
# why when we disable all our  config files, `$PATH` still contains some values,
# including `$HOME/bin` and `$HOME/.local/bin`.
#
# See `man login` for more info, or:
#
#     http://unix.stackexchange.com/a/228167
#}}}
# What do you put in `$PATH` and why?{{{
#
# We  prepend our  private `bin`  directories  to `$PATH`,  because that's  what
# `~/.profile` did last time I checked.
#}}}
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
