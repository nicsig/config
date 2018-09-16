# We could change the location of our `zsh` config files:{{{
#
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
# What's the benefit of using this file over `zshrc` or `zprofile`?{{{
#
# Those are only sourced if the shell has the right type.
# `zshenv` is always sourced, no matter the type of the shell:
# login, non-login, interactive, non-interactive
#
# So, it's useful for settings we need in any type of shell, and we don't want
# to repeat them in both `zshrc` and `zprofile`.
# Maybe sth like `EDITOR`, `PAGER`, `PATH`, `ZDOTDIR` …
# }}}
# Which commands should we include in this file?{{{
#
# Probably only `export` commands and maybe `.` (to source a `*profile` file
# for example).
# }}}
# Are there some dangers using it?{{{
#
# Yes, we must make sure it doesn't export environment variables which have
# already been set.
# Otherwise,  it could  lead to  problems,  if we  append/prepend a  value to  a
# variable:
#
#     https://www.zsh.org/mla/users/2012/msg00784.html
#
# For example, if we append a value to `$PATH`, it will grow bigger every time
# `$SHLVL` is incremented. That is every time, we start a subshell.
#
# So, we need a guard:    MY_ENVIRONMENT_HAS_BEEN_SET
# }}}

if [[ -z "${MY_ENVIRONMENT_HAS_BEEN_SET}" ]]; then
  export MY_ENVIRONMENT_HAS_BEEN_SET=yes

  export EDITOR='vim'

  # to get the name of the day/month in english
  export LC_TIME=en_US.UTF-8

  # $LS_COLORS
  eval "$(dircolors "${HOME}/.dircolors")"
  # if [ -x /usr/bin/dircolors ]; then
  #     test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

  # use Vim as default man pager
  export MANPAGER='/bin/sh -c "col -bx | vim --not-a-term -"'
  #               ├─────────┘  ├────┘│         │ {{{
  #               │            │     │         └ don't display  “Vim: Reading from stdin...”
  #               │            │     │
  #               │            │     └ replace tabs with spaces
  #               │            │
  #               │            └ remove some control characters like ^H
  #               │
  #               └ wrap the whole command in `/bin/sh -c`
  #                 because the value of $MANPAGER can't use a pipe directly
  #
  # }}}

  # Why this value?{{{
  #
  # It's recommended in `man par`.
  #
  # It's useful to prevent the following kind of wrong formatting:
  #
  #     par <<< 'The quick brown fox jumps over the lazy dog.
  #     The quick brown fox jumps over the lazy dog foo bar baz.'
  #
  #         The quick brown fox jumps over the lazy dog.
  #         The quick brown fox jumps over the lazy dog foo bar baz                .    ✘
  #
  # With the right value for `PARINIT`:
  #
  #         The quick brown fox jumps over the lazy dog.  The quick brown fox jumps
  #         over the lazy dog foo bar baz.                                              ✔
  #}}}
  # TODO: Finish explaining the value (meaning of options, body/quote characters).
  export PARINIT='rTbgqR B=.,?_A_a Q=_s>|'
  #               ├────┘ │ │││├┘├┘ │ ├┘││{{{
  #               │      │ ││││ │  │ │ │└ literal `|` (for diagrams)
  #               │      │ ││││ │  │ │ └ literal `>` (for quotes in markdown)
  #               │      │ ││││ │  │ │
  #               │      │ ││││ │  │ └ whitespace
  #               │      │ ││││ │  │
  #               │      │ ││││ │  └ set of quote characters
  #               │      │ ││││ │
  #               │      │ ││││ └ [a-z]
  #               │      │ │││└ [A-Z]
  #               │      │ │││
  #               │      │ ││└ literal `?`
  #               │      │ │└ literal `,`
  #               │      │ └ literal `.`
  #               │      │
  #               │      └ set of body characters
  #               │
  #               └ boolean and numerics options (probably)
  #}}}

  export CDPATH=:${HOME}:/tmp
  # https://www.tug.org/texlive/doc/texlive-en/texlive-en.html#x1-310003.4.1
  export INFOPATH=$HOME/texlive/2018/texmf-dist/doc/info:$INFOPATH
  # add man pages for `texlive` and `dasht`
  export MANPATH=$HOME/texlive/2018/texmf-dist/doc/man:$HOME/GitRepos/dasht/man:$MANPATH
  # add the `texlive` and `dasht` binaries to our path
  export PATH=$HOME/texlive/2018/bin/x86_64-linux:$PATH:$HOME/GitRepos/dasht/bin

  # Choose which program should be used to open pdf documents.
  # Useful for `texdoc`.
  export PDFVIEWER=zathura

  # When a command take more than a few seconds, print some timing statistics at
  # the end of it, so that we can know how much it took exactly.
  # The report can be formatted with `TIMEFMT` (man zshparam).
  export REPORTTIME=15

  # What's `$TERM` inside a terminal, by default?{{{
  #
  # In many terminals, including xfce-terminal, guake, konsole:
  #
  #   $TERM = xterm
  #
  # Yeah, they lie about their identity to the programs they run.
  #
  # In urxvt:
  #
  #   $TERM = rxvt-unicode-256color
  #
  # urxvt tells the truth.
  #}}}
  # Where is the configuration file for a terminal?{{{
  #
  # xfce-terminal and guake don't seem to have one.
  # However, you may find a way to  configure how they advertise themselves to the
  # programs they run, like this:
  #
  #     1. right-click
  #     2. preferences
  #     3. compatibility
  #
  # urxvt use ~/.Xresources.
  #}}}
  # Why do we, on some conditions, reassign `xterm-256color` to `$TERM`?{{{
  #
  # For the  colorschemes of programs to  be displayed correctly in  the terminal,
  # `$TERM`  must contain  '-256color'. Otherwise,  the programs  will assume  the
  # terminal is only  able to interpret a limited amount  of escape sequences used
  # to encode 8 colors, and they will restrict themselves to a limited palette.
  #}}}
  # Ok, but why do it in this file?{{{
  #
  # The configuration  of `$TERM` should  happen only in a  terminal configuration
  # file. But for xfce4-terminal, I haven't found  one.  So, we must try to detect
  # the identity of the terminal from here.
  #}}}
  # How to detect we're in an xfce terminal?{{{
  #
  # If you look at  the output of `env` and search for  'terminal' or 'xfce4', you
  # should find `COLORTERM`  whose value is set to  'xfce4-terminal'.  We're going
  # to use it to detect an xfce4 terminal.
  #}}}
  # Is it enough?{{{
  #
  # No, watch this:
  #
  #   1. start xfce4-terminal
  #   2. $ tmux (start server)
  #   3. $ echo $TERM  →  tmux-256color  ✔
  #
  #   4. start another xfce4-terminal
  #   5. $ tmux (connect to running server)
  #   6. $ echo $TERM  →  xterm-256color  ✘
  #
  # We must NOT  reset `$TERM` when the  terminal is connecting to  a running tmux
  # server. Because the  latter will already  have set `$TERM`  to 'tmux-256color'
  # (thanks to the  option 'default-terminal' in `~/.tmux.conf`), which  is one of
  # the few valid value ({screen|tmux}[-256color]).
  #
  # One way to be sure that we're not connected to Tmux , is to check that `$TERM`
  # is set to 'xterm'.  That's the default value set by xfce4-terminal.
  #}}}
  # Alternative to support Gnome terminal, Terminator, and XFCE4 terminal:{{{
  #
  #     if [[ "${TERM}" == "xterm" ]]; then
  #         if [[ -n "${COLORTERM}" ]]; then
  #             if [[ "${COLORTERM}" == "gnome-terminal" || "${COLORTERM}" == "xfce-terminal" ]]; then
  #                 TERM=xterm-256color
  #             fi
  #         elif [[ -n "${VTE_VERSION}" ]]; then
  #             TERM=xterm-256color
  #         fi
  #     fi
  #
  # Source:
  # https://github.com/romainl/Apprentice/wiki/256-colors-and-you
  #}}}
  if [[ "${TERM}" == "xterm" ]]; then
    if [[ "${COLORTERM}" == "xfce4-terminal" || -n "${KONSOLE_PROFILE_NAME}" ]]; then
    #                                           ├──────────────────────────┘{{{
    #                                           └ to also detect the Konsole terminal}}}
      export TERM=xterm-256color
    fi
  fi

  # directories relative  to which various kinds of user-specific  files should be
  # written
  # For more info, see:{{{
  #
  #     https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
  #}}}
  # The link talks about data files. What are they?{{{
  #
  #     • trash
  #     • icons
  #     • viminfo
  #     • swap files
  #     • .desktop files
  #     • .keyring files
  #     • ...
  #}}}

  export XDG_DATA_HOME=$HOME/.local/share

  # configuration files
  export XDG_CONFIG_HOME=$HOME/.config

  # non-essential (cached) data
  export XDG_CACHE_HOME=$HOME/.cache

  # runtime files and other file objects
  # (temporary files created by processes owned by the logged user)
  export XDG_RUNTIME_DIR=/run/user/$UID
  #                      ├────────┘{{{
  #                      └ should exist on any OS using systemd
  #                        not sure about the others
  #}}}
fi

