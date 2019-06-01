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

# Should we copy some of the next statements in `~/.bashrc`?{{{
#
# No.
# When you start a bash shell, it's always from a zsh shell.
# So the bash shell will inherit all the environment of the zsh shell.
#}}}

# bat {{{1

# Where can I download `$ bat`?{{{
#
#     https://github.com/sharkdp/bat/releases
#}}}
# What does `BAT_STYLE` control?{{{
#
# The information  which will  be printed  by `$  bat file`  in addition  to the
# contents of the file.
#}}}
# What values can I include in it?{{{
#
#    ┌─────────┬───────────────────────────────────────────────────┐
#    │ changes │ indicators about lines added/removed              │
#    │         │ in a modified file in a git repo                  │
#    ├─────────┼───────────────────────────────────────────────────┤
#    │ grid    │ lines separating the text from the header/numbers │
#    ├─────────┼───────────────────────────────────────────────────┤
#    │ header  │ filename                                          │
#    ├─────────┼───────────────────────────────────────────────────┤
#    │ numbers │ lines addresses                                   │
#    └─────────┴───────────────────────────────────────────────────┘
#
# There're other values (like auto, full, plain), see `man $bat`.
#}}}
export BAT_STYLE=changes,grid,header
# What are the other possible themes, and how to (pre)view them?{{{
#
# This command will print a default sample file for each theme:
#
#     $ bat --list-themes
#
# This command will print a preview of `/path/to/file` for each theme:
#
#     $ bat --list-themes | fzf --preview="bat --theme={} --color=always /path/to/file"
#}}}
export BAT_THEME='GitHub'

# editor {{{1

export EDITOR='vim'

# fzf {{{1

# https://github.com/junegunn/fzf#environment-variables
# https://github.com/junegunn/fzf#respecting-gitignore
export FZF_DEFAULT_COMMAND='fd --hidden --follow --type f'
export FZF_ALT_C_COMMAND='fd --hidden --follow --type d'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

export FZF_DEFAULT_OPTS='--exact --inline-info --bind change:top,alt-j:preview-page-down,alt-k:preview-page-up'
# https://github.com/andrewferrier/fzf-z/blob/c36f93f89f7e78308bce1056e9672cad77dd8993/fzfz#L15
export FZF_ALT_C_OPTS="${FZF_DEFAULT_OPTS} --preview='tree -C -L 2 -x --noreport --dirsfirst {} | head -\$LINES'"
export FZF_CTRL_R_OPTS=$FZF_DEFAULT_OPTS
export FZF_CTRL_T_OPTS=$FZF_DEFAULT_OPTS

# controls the number of lines occupied by fzf when we press sth like `M-j`
export FZF_TMUX_HEIGHT=40%

# history {{{1

# infinite history
# https://unix.stackexchange.com/a/273929/289772
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=999999999
export SAVEHIST=$HISTSIZE

# locale {{{1

# to get the name of the day/month in english
export LC_TIME=en_US.UTF-8

# less {{{1

# What does this variable do?{{{
#
# It passes options automatically to `$ less`.
#}}}
# What does `i` mean?{{{
#
# It's a Less option which makes a search case-insensitive.
#
# Note that  if your search  pattern contains  an uppercase character,  the case
# WILL still be taken into account.
#
# It's like 'ignorecase' and 'smartcase' in Vim.
#}}}
# What does `M` mean?{{{
#
# It's a Less option which makes the prompt more verbose.
# At  the bottom  of  the screen,  it  prints  info about  our  position with  a
# percentage, and line numbers.
#}}}
# What does `R` mean?{{{
#
# It's  an option  which prevents  Less from  displaying the  caret notation  of
# control characters used in ANSI color escape sequences.
# Instead, they're sent in raw form to the terminal which will interpret them to
# set the colors of the text appropriately.
#
# This is useful for commands such as `$ git log`.
# Without, you would see things like `ESC[33m ... ESC[m`.
#
# If you still see control characters, you can use `r` instead of `R`.
# However, from `$ man less`:
#
# > Warning: when the  -r option is used,  less cannot keep track  of the actual
# > appearance of the  screen (since this depends on how  the screen responds to
# > each type of control character).
# >  Thus, various display  problems may result, such as long  lines being split
# >  in the wrong place.
#}}}
# What does `S` mean?{{{
#
# It's a `$ less` option which prevents long lines from being wrapped.
#}}}
# What does `+G` mean?{{{
#
# It's a `$ less` option which makes the cursor jump at the bottom of the screen
# on startup.
#}}}
export LESS=iMRS+G

# Make `less` able to read archives and pdfs.
# How does it work?{{{
#
# `lesspipe` is a utility which, without argument, outputs 2 `export` statements:
#
#     export LESSOPEN="| /usr/bin/lesspipe %s";
#     export LESSCLOSE="/usr/bin/lesspipe %s %s";
#
# We execute them with `eval`.
# As a result, when we try to  open an archive file, `lesspipe` will pre-process
# it and write its uncompressed text on a pipe which `less` will read.
#
# For more information, see `$ man lesspipe` or `$ man lessopen`.
#}}}
# Why the guard?{{{
#
# The `$ eval` has a big impact on performance.
# You can measure it with this command:
#
#     $ time zsh -c 'repeat 1000 source ~/.zshenv'
#}}}
if [[ -z "${LESSOPEN}" ]]; then
  eval "$(lesspipe)"
fi

# ls {{{1

# Ask `$  dircolors` to  read its  config from `~/.dircolors`,  so that  it sets
# `$LS_COLORS`.
# The latter controls the colors in the output of `$ ls --color`.
if [[ -z "${LS_COLORS}" ]]; then
  eval "$(dircolors "${HOME}/.dircolors")"
fi

# man {{{1

# use Neovim as default man pager
# Why don't you use Vim like before?{{{
#
# Yeah, in the past, we used this:
#
#     export MANPAGER='/bin/sh -c "col -bx | vim --not-a-term -"'
#                     ├─────────┘  ├────┘│         │
#                     │            │     │         └ don't display  “Vim: Reading from stdin...”
#                     │            │     │
#                     │            │     └ replace tabs with spaces
#                     │            │
#                     │            └ remove some control characters like ^H
#                     │
#                     └ wrap the whole command in `/bin/sh -c`
#                       because the value of $MANPAGER can't use a pipe directly
#
# But, currently, the Neovim man plugin is better than our own plugin.
# The  latter only  works in  Vim and,  contrary to  the Neovim  plugin, doesn't
# support some attributes such as bold/underlined.
#
# Btw, if later you decide to use Vim again, read `:h manpager.vim`.
# It recommends this command instead:
#
#     export MANPAGER="vim -M +MANPAGER -"
#}}}
export MANPAGER='nvim +Man!'

# Purpose:{{{
#
# Write the word `printf` in a markdown buffer, then press `K`.
# `$ man` will give to Vim the `printf` page from the section 1.
#
# But what if you prefer to give the priority to the section 3?
# That's where `$MANSECT` comes in.
# It allows you to change the priority of the man sections.
# Here, I export the default value given in:
#
#     /etc/manpath.config
#
# Use this `export` statement to change the priority of the sections.
#
# Note that pressing `3K`  or executing `$ man 3 printf` will  give you the page
# from the section 3, no matter what `$MANSECT` contains.
# This variable is only useful for when you don't provide the section number.
#
# See `$ man 1 man` for more info.
#}}}
export MANSECT=1:n:l:8:3:2:3posix:3pm:3perl:5:4:9:6:7
# See `~/wiki/shell/environment.md` for an explanation as to why we do that.
export MYMANSECT="${MANSECT}"

export MANWIDTH=80

# par {{{1

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

# PATH {{{1

# Why don't you set `CDPATH`?{{{
#
# In the past, we assigned it this value:
#
#     export CDPATH=:${HOME}:${HOME}/Downloads:${HOME}/GitRepos:${HOME}/wiki:/run/user/${UID}
#
# But I don't like the fact that it makes `cd` somewhat unpredictable.
# Besides, the `j` alias (provided by the fasd plugin) serves a similar purpose,
# but does it in a much more powerful way.
#}}}
# https://www.tug.org/texlive/doc/texlive-en/texlive-en.html#x1-310003.4.1
export INFOPATH=${HOME}/texlive/2018/texmf-dist/doc/info:${INFOPATH}
# add man pages for `texlive` and `dasht`
# What's the default value of `$MANPATH`?{{{
#
# It's empty on my system atm.
#}}}
# Why do you put a colon at the end?{{{
#
# When `$MANPATH` contains  an empty component, for every  `<path>/bin` which is
# in your `$PATH`, `$ man` will also look for manpages in `<path>/share/man`:
#
#     https://askubuntu.com/a/633924/867754
#
# This means that since  we have `~/bin` in our `$PATH`, `$  man` will look into
# `~/share/man`; IOW, this allows us to install manpages locally (!= system-wide
# in `/usr/share/man`).
#}}}
export MANPATH=${HOME}/texlive/2018/texmf-dist/doc/man:${HOME}/GitRepos/dasht/man:${MANPATH}:
# add the `texlive` and `dasht` binaries to our path
# Aren't `~/bin` and `~/.local/bin` already in `$PATH` by default?{{{
#
# Yes they are.
#}}}
#     How to find the first ancestor of my shell whose `$PATH` contains them?{{{
#
# Run this:
#
#     $ pstree -s -p $$
#     systemd(1)───lightdm(934)───lightdm(997)───upstart(1006)───tmux: server(1642)───zsh(9687)───pstree(9733)~
#
# Then run:
#
#     $ tr '\0' '\n' < /proc/PID/environ | grep ^PATH
#                            ^^^
#                            pid of an ancestor process
#
# You'll notice that the first process whose `$PATH` contains those directories is upstart.
#}}}
#     What put them there?{{{
#
# If you inspect `/proc/UPSTART_PID/cmdline`, you'll read:
#
#     $ cat /proc/1006/cmdline
#     /sbin/upstart --user~
#
# From `$ man upstart /--user`:
#
# > --user Starts  in user mode, as used for user sessions. Upstart will be
# >        run as an unprivileged user, reading  configuration  files  from
# >        configuration locations as per roughly XDG Base Directory Speci‐
# >        fication. See init(5) for further details.
#
# I think that because of `--user`, the upstart process reads `~/.profile` which contains:
#
#     # set PATH so it includes user's private bin directories
#     PATH="$HOME/bin:$HOME/.local/bin:$PATH"
#
# `~/.profile` is – probably – initially copied from:
#
#     /etc/skel/.profile
#}}}
#     But if they're already there by default, why add them here again?{{{
#
# They would be missing when zsh is started as a login shell in a virtual console.
# Indeed, in that case:
#
#     $ pstree -s -p $$
#     systemd(1)---login(8518)---zsh(8579)---pstree(8900)~
#
# The shell  has only 2 ancestors,  none of which has a  PATH containing `~/bin`
# nor `~/.local/bin`.
#}}}
export PATH=${HOME}/bin:${HOME}/.local/bin:${HOME}/texlive/2018/bin/x86_64-linux:${PATH}:${HOME}/GitRepos/dasht/bin

# What is the purpose of this block? {{{
#
# Adding the path to the ruby gems installed in our home via `--user-install`.
#
# As an example of a locally installed gem:
#
#     $ gem install --user-install heytmux
# }}}
# What does this `.ruby_user_dir_cache` contain? {{{
#
# A `PATH=` assignment, such as:
#
#     PATH=${PATH}:/home/user/.gem/ruby/2.3.0/bin
# }}}
#   Why do you use a cache? {{{
#
# Because to get the path to the ruby gems programmatically, we need to run a
# `$ ruby` command, which is slow.
# We don't want the shell startup time to be impacted.
# }}}
# What's `-s` in `[[ -s file ]]`? {{{
#
# It asserts that the file exists and that its size is not 0.
# Btw, that's similar to how fasd lazy-loads some of its code:
#
#     if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
#                                                      ^^
#
# https://github.com/clvv/fasd#install
# }}}
if [[ ! -s "${HOME}/.ruby_user_dir_cache" ]]; then
  printf -- "PATH=\${PATH}:$(ruby -e 'puts Gem.user_dir')/bin" >"${HOME}/.ruby_user_dir_cache"
  # Where did you find the `ruby -e '...'` command? {{{
  #
  # https://wiki.archlinux.org/index.php/ruby#Setup
  # }}}
  #   What is `-e`? {{{
  #
  # It specifies  the script  from the  command-line while  telling Ruby  not to
  # search the rest of the arguments for a script file name.
  # See `$ man ruby /^\C\s*-e\>`.
  # }}}
  #     `puts`? {{{
  #
  # A command similar to `$ printf`.
  # }}}
  #     `Gem.user_dir`? {{{
  # The path for gems in the user's home directory.
  # https://www.rubydoc.info/github/rubygems/rubygems/Gem.user_dir
  # }}}
fi
. "${HOME}/.ruby_user_dir_cache"

# pdf {{{1

# Choose which program should be used to open pdf documents.
# Useful for `texdoc`.
export PDFVIEWER=zathura

# REPORTTIME {{{1

# When a command take more than a few seconds, print some timing statistics at
# the end of it, so that we can know how much it took exactly.
# The report can be formatted with `TIMEFMT` (man zshparam).
export REPORTTIME=15

# sudo {{{1

# Purpose:{{{
#
# When we try to save a modified file in Neovim, we get this error:
#
#     Error detected while processing BufWriteCmd Auto commands for "...":
#     sudo: no tty present and no askpass program specified
#
# According to the message, we need to specify an askpass program.
# If you search `askpass` in `$ man sudo`, you'll find the `-A` option (which we
# use in our `vim-unix` plugin) and the `SUDO_ASKPASS` environment variable.
#}}}
# Where did you find this `/usr/lib/ssh/x11-ssh-askpass` file?{{{
#
#     $ dpkg -L ssh-askpass
#}}}
# Ok, and where did you find this package?{{{
#
#     $ aptitude search '~daskpass'
#}}}
export SUDO_ASKPASS='/usr/lib/ssh/x11-ssh-askpass'

# TERM {{{1

# Let applications running in Vim's terminal know, that our terminal supports 256 colors.{{{
#
# Without  this line,  when opening  a terminal  buffer, most  of the  time, Vim
# would  see  that  `$TERM`  doesn't begin  with  `xterm`  (e.g.  `st-256color`,
# `tmux-256color`, ...), and would set `$TERM` with `xterm` as a fallback.
#
# As a  result, the applications  running in  the terminal buffer  would wrongly
# think that our terminal doesn't support more than 8 or 16 colors.
# This would break, for example, the zsh syntax highlighting plugin; whenever we
# refer to a color beyond the 16  ANSI colors, the plugin would immediately fall
# back on black.
#
# From `:h terminal-unix`
#
# > Environment variables are used to pass information to the running job:
#
# >     TERM    the name of the terminal, from the 'term' option or
# >             $TERM in the GUI; falls back to "xterm" if it does not
# >             start with "xterm"
#}}}
if [[ -n "${VIM_TERMINAL}" ]]; then
  export TERM=xterm-256color
fi

# tldr {{{1

# Configure the colors and styles of the output of `$ tldr`.
export TLDR_HEADER='green bold'
export TLDR_QUOTE='italic'
# You can configure it further with these variables:
#     TLDR_DESCRIPTION
#     TLDR_CODE
#     TLDR_PARAM

# XDG_* {{{1

# directories relative to which various kinds of user-specific files should be written
# For more info, see:{{{
#
#     https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
#}}}
# The link talks about data files. What are they?{{{
#
#    - trash
#    - icons
#    - viminfo
#    - swap files
#    - .desktop files
#    - .keyring files
#    - ...
#}}}
# user data files
export XDG_DATA_HOME=$HOME/.local/share

# user configuration files
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

# remove duplicates in PATH &others {{{1

# Purpose:{{{
#
# Some environment variables can contain duplicate entries.
#
# This is the case with `XDG_CONFIG_DIRS` and `XDG_DATA_DIRS`.
# It can have undesired effects.
# For example, these variables are used by Neovim to add some paths in its rtp.
# If one of them  contains a duplicate path, and we have  a Nvim filetype plugin
# in it, the filetype plugin may be sourced twice which could raise errors.
#
# This  anonymous function  makes sure  that those  variables don't  contain any
# duplicate entries.
#
# To do so, it's going to iterate over the entries of a copy of each environment
# variable.
# Every time it finds a unique entry, it will add it to the local variable `rebuild`.
# At  the end,  it assigns the  value of `rebuild`  to the  original environment
# variable.
#}}}
() {
  emulate -L zsh
  # If you have an error such as: anon: 2: no matches found{{{
  #
  # escape the brackets:
  #     [PATH]=...
  # →
  #     \[PATH\]=...
  #
  # I think the issue happens on old versions of zsh, not on recent ones.
  #}}}
  local -A vars=( \
    [PATH]="${PATH}" \
    [INFOPATH]="${INFOPATH}" \
    [MANPATH]="${MANPATH}" \
    [XDG_CONFIG_DIRS]="${XDG_CONFIG_DIRS}" \
    [XDG_DATA_DIRS]="${XDG_DATA_DIRS}" \
    )
  # iterate over the keys of `vars` (i.e. the strings 'PATH', 'XDG_...')
  local key
  # Would this work in bash?{{{
  #
  # Almost.
  # You would only have to replace `(k)` with `!`:
  #
  #     for key in "${!vars[@]}"; do
  #                   ^
  #}}}
  for key in "${(k)vars[@]}"; do
    if [[ -n "${vars[$key]}" ]]; then
      # Is the equal sign necessary?{{{
      #
      # Yes.
      #
      # To correctly reset/empty the variables after each iteration of the loop.
      # Also, to avoid  the shell printing the value of  the local variables, on
      # the terminal.
      #
      # MWE:
      #
      #     func() {
      #       local var
      #       var='val1'
      #       local var
      #       var='val2'
      #     }
      #     $ func
      #         → the 2nd `local var` statement will make zsh print the value of `var`
      #
      #     func() {
      #       local i
      #       for i in 1 2; do
      #         local var
      #         var='value'
      #       done
      #     }
      #     $ func
      #         → same thing as before
      #}}}
      local copy=
      local rebuild=
      # Why do you add a colon at the end?{{{
      #
      # The next while loop won't end until `copy` is empty.
      # And `copy`  shrinks after every iteration  because we remove one  of its
      # entries with:
      #
      #     copy="${copy#*:}"
      #
      # Now, if we don't add a colon at the end, the last entry won't be removed
      # during the last expected iteration.
      #
      #     foo:bar:baz
      #         bar:baz    ('foo:' was removed)
      #             baz    ('bar:' was removed)
      #             baz    (nothing was removed, because nothing matched `*:`)
      #             ...    (never ending loop)
      #
      # As a result, the while loop will never ends.
      # OTOH, if we add an extra colon at the end:
      #
      #     foo:bar:baz:
      #         bar:baz:   ('foo:' was removed)
      #             baz:   ('bar:' was removed)
      #                ∅   ('baz:' was removed)
      #}}}
      copy="${vars[$key]}":

      # iterate over the entries of the copy
      while [[ -n "${copy}" ]]; do
        # extract first entry from the copy
        entry="${copy%%:*}"
        # Why do you add a colon right after `rebuild`?{{{
        #
        # We're going to compare the text stored in `rebuild` with a pattern.
        # The latter contains 2 colons: one before and one after the entry we've
        # just extracted.
        # If the entry is  already present at the very end  of `rebuild`, and we
        # don't add an extra colon, it won't be matched by `*:entry:*`
        #
        # MWE:
        #     rebuild = foo:bar
        #     entry = bar
        #
        #     'foo:bar'  !~ '*:bar:*' ✘
        #     'foo:bar:' =~ '*:bar:*' ✔
        #
        # As a  result, the test  will fail, and the  algo will wrongly  add the
        # entry a second time in `rebuild`.
        #}}}
        # Why don't you add a colon right before `rebuild`?{{{
        #
        # There's no need to.
        # During  the first  iteration, `rebuild`  is  empty and  thus can't  be
        # matched by `*:entry:*`
        # During the second iteration, `rebuild`  contains sth like `:foo` (yes,
        # the previous iteration has added an  extra colon at the beginning), so
        # there's no need to add a colon.
        # During the  third iteration,  `rebuild` contains sth  like `:foo:bar`,
        # then  `:foo:bar:baz`  and  so  on. There's   always  a  colon  at  the
        # beginning.
        # }}}
        case "${rebuild}": in
          # if the entry is already in the variable, don't do anything
          # Why do you add a colon before and after the entry, in the pattern?{{{
          #
          # To be sure `entry` is indeed an entry of `rebuild`, and not merely a
          # substring of an entry.
          # For example, if we have those values:
          #
          #     entry = bar
          #     rebuild = foo:barbar:baz
          #
          # And we want to check whether  `bar` is an entry of `foo:barbar:baz`,
          # we can't compare the latter to just `*bar*`.
          # It would result  in a positive match, and `bar`  would not be added,
          # because the algo would wrongly think  that `bar` is already an entry
          # of `rebuild`.
          # In  reality, `bar`  only matches  a substring  of an  entry, and  so
          # should be added.
          #}}}
          *:"${entry}":*) ;;
          # otherwise, add the entry at the end of the variable
          *) rebuild="${rebuild}:${entry}" ;;
        esac
        # remove the  first entry, so  that the next  iteration of the  while loop
        # processes the next entry
        copy="${copy#*:}"
      done

      # Now we can assign `rebuild` to the original environment variable.
      # Why `${rebuild#:}` instead of just `${rebuild}`?{{{
      #
      # The first iteration  of the while loop has introduced  an extra colon at
      # the beginning:
      #
      #     rebuild="${rebuild}:${entry}"
      #     ⇔
      #     rebuild=":${entry}"
      #              ^
      #              because rebuild is initially empty
      #
      # We need to remove it.
      #}}}
      eval "$key=\"${rebuild#:}\""
    fi
  done
}

