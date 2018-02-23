# NOTE: We could change the location of our `zsh` config files:{{{
#     export ZDOTDIR=~/.config/zsh
#
# However, I'm afraid that some of them will be hard to move:
#
#     .zshenv (this file; to change its location we would probably need to edit a system file)
#     .fasd-init-zsh
#     .fzf.zsh
#
# So, for the moment, I keep all of them in `$HOME`.
# }}}
# NOTE: What's the benefit of using this file over `zshrc` or `zprofile`?{{{
#
# Those are only sourced if the shell has the right type.
# `zshenv` is always sourced, no matter the type of the shell:
# login, non-login, interactive, non-interactive
#
# So, it's useful for settings we need in any type of shell, and we don't want
# to repeat them in both `zshrc` and `zprofile`.
# Maybe sth like `EDITOR`, `PAGER`, `PATH`, `ZDOTDIR` …
# }}}
# NOTE: Which commands should we include in this file?{{{
#
# Probably, only `export` commands and maybe `.` (to source a `*profile` file
# for example).
# }}}
# NOTE: Are there some dangers using it?{{{
#
# Yes, we must make sure it doesn't export environment variables which have
# already been set. Otherwise, it could lead to problems, if we append/prepend
# a value to a variable:
#
#     https://www.zsh.org/mla/users/2012/msg00784.html
#
# For example, if we append a value to `$PATH`, it will grow bigger every time
# `$SHLVL` is incremented. That is every time, we start a subshell.
#
# So, we need a guard:    MY_ENVIRONMENT_HAS_BEEN_SET
# }}}

if [[ -z $MY_ENVIRONMENT_HAS_BEEN_SET ]]; then
  export MY_ENVIRONMENT_HAS_BEEN_SET=yes
  export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
  export GOPATH=$HOME/go
fi
