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

# Where can I download `bat(1)`?{{{
#
# https://github.com/sharkdp/bat/releases
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
# There're other values (like auto, full, plain), see `man bat`.
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

# BROWSER {{{1

# Some programs inspect this variable to determine which program to start.{{{
#
# For example, `man(1)` when we run `$ man --html man`.
# If it's not set, they fall back on some value.
# `man(1)` seems to fall back on `links(1)`.
# We don't know `links(1)` well, and we haven't configured it.
#}}}
# Do *not* use the value `w3m`!{{{
#
# It would break `urlview(1)`.
#}}}
export BROWSER='firefox'

# EDITOR {{{1

# What is the difference between `EDITOR` and `VISUAL`?{{{
#
# Historically, `EDITOR` and `VISUAL` are meant to set resp. your preferred line
# editor (e.g.  `sed(1)`), and  your preferred  TUI/GUI editor  (e.g. `vim(1)`):
# https://unix.stackexchange.com/a/334022/289772
#}}}
export VISUAL='vim'
export EDITOR="$VISUAL"

# TODO: Consider removing this `unset` once you don't use Nvim as a manpager anymore.
# Necessary to avoid many issues when starting Nvim from Vim's terminal (or Vim from Nvim's terminal).{{{
#
# In the past, `E492` was raised when running `:!man cmd` from Vim.
#
# More generally, when Nvim was started from Vim's terminal:
#
#    - the clipboard didn't work:
#
#         :echo @+
#         clipboard: No provider. Try ":checkhealth" or ":h clipboard".
#
#    - `:checkhealth` was broken (`E5009: Invalid 'runtimepath'`)
#
#    - the python interface was not enabled (`:echo has('python3')` output 0),
#      which broke plugins relying on it (like UltiSnips)
#
# We had many other subtle issues which required a lot of fixes.
# Like an  anonymous zsh function to  build a complex value  for `$MANPAGER`, to
# reset `$VIMRUNTIME` & friends.
#
# I think  we sometimes  had an issue  when pressing  `K` on a  word in  a shell
# script, when `'kp'` had its default value (`man`)...
#
# And running `$ ls | vipe` from Nvim's terminal raised:
#
#     E117: Unknown function: stdpath
#
# We tried to fix all these issues from our vimrc by checking whether we were in
# a (N)Vim terminal  and clearing the variables.  But it  didn't work; you can't
# clear these variables.
#
# We also tried to reset them from the vimrc:
#
#     if has('vim_starting')
#         if $VIM_TERMINAL != '' && v:progpath =~# '\C/nvim$'
#             let $VIMRUNTIME = '/usr/local/share/nvim/runtime'
#             let $VIM = '/usr/local/share/nvim'
#             let $MYVIMRC = $HOME..'/.config/nvim/init.vim'
#         elseif $NVIM_LISTEN_ADDRESS != '' && v:progpath =~# '\C/vim$'
#             let $VIMRUNTIME = '/usr/local/share/vim/vim82'
#             let $VIM = '/usr/local/share/vim'
#             let $MYVIMRC = $HOME..'/.vim/vimrc'
#         endif
#     endif
#
# But it seemed brittle (the path `.../vim82` is only valid while you use Vim 8.2).
#
# Anyway, the root cause of all these issues is in the shell's environment.
# So that's where we need to intervene.
# We just  make sure the environment  of a shell never  contains `$VIMRUNTIME` &
# friends; it fixes everything.
# See: https://github.com/neovim/neovim/issues/8696
#
# ---
#
# Btw, don't try to unset too many variables, like:
#
#    - `NVIM_LOG_FILE`
#    - `NVIM_LISTEN_ADDRESS`
#    - `VIM_TERMINAL`
#    - `VIM_SERVERNAME`
#
# It  could break  a program  running in  (N)Vim's terminal  and which  needs to
# communicate with the containing (N)Vim process:
# https://github.com/neovim/neovim/issues/8696#issuecomment-403125772
#
# Leave them alone; they should be harmless; for example, Vim doesn't understand
# `NVIM_LISTEN_ADDRESS`.
# The only variables which can cause issues are the ones which are understood by
# both Vim and Nvim.
#}}}
unset VIM VIMRUNTIME MYVIMRC

# For some applications, it could be useful to use full paths (e.g. `/usr/local/bin/vim`):{{{
# https://unix.stackexchange.com/questions/4859/visual-vs-editor-what-s-the-difference#comment5812_4861
#
# I don't do it, because we would need to:
#
#    1. run `$ which vim` to get the full path programmatically
#    2. build the `export` statements
#    3. save them in a cache
#    4. source the cache if it exists and is not too old
#
# Too cumbersome.
#}}}

# fzf {{{1

# https://github.com/junegunn/fzf#environment-variables
# https://github.com/junegunn/fzf#respecting-gitignore
export FZF_DEFAULT_COMMAND='fd --hidden --follow --type f'
# this command is invoked by `fzf-cd-widget`;
# look for it in your zshrc to find out which key we've bound the latter to
export FZF_ALT_C_COMMAND='fd --hidden --follow --type d'
# this command is invoked by `fzf-file-widget`
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

export FZF_DEFAULT_OPTS='--exact --info=inline --bind change:top,alt-j:preview-page-down,alt-k:preview-page-up'
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

# Let's tell our applications that our OS is configured for an english-speaking user.
# What about other locale-related variables, like `LC_TIME`?{{{
#
# `LC_ALL` has priority over those.
#
#     $ LC_ALL=en_US.UTF-8 LC_TIME=fr_FR.UTF-8 date
#     Thu Sep 12 00:40:10 CEST 2019~
#
# So setting it, is like setting all the other ones.
#}}}
# Why do we need to set this?{{{
#
# Atm, some of our locale variables are set as for a french-speaking user.
#
# I don't know why, but the shell inherits it from its ancestors.
# The first process in the ancestor which  has a locale variable set for french,
# is  the first  `lightdm(1)` (we  have 2  such processes;  the first  being the
# parent of the second).
# This process is started by `systemd(1)`, with a simple command-line (no argument):
#
#     $ cat /proc/$(pgrep lightdm|head -n1)/cmdline
#     /usr/sbin/lightdm~
#
# I don't know from where lightdm picks up those french locale values.
#
# Anyway, we want a consistent environment.
# We do everything in english (read man pages in english, take notes in english,
# comment in english, ...),  in part because when we have an  issue, we can find
# help more easily: there is more information in english on the internet.
# So, our locale  variables should reflect our choice, so  that all applications
# know it, and respect it.
#}}}
export LC_ALL=en_US.UTF-8

# less {{{1

# What does this variable do?{{{
#
# It passes options automatically to `less(1)`.
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
#   `~`?{{{
#
# Normally lines  after end of  file are displayed as  a single tilde  (~). This
# option causes lines after end of file to be displayed as blank lines.
#}}}
#   `M`?{{{
#
# It's a Less option which makes the prompt more verbose.
# At  the bottom  of  the screen,  it  prints  info about  our  position with  a
# percentage, and line numbers.
#}}}
#   `R`?{{{
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
# However, from `man less`:
#
# >     Warning: when the  -r option is used,  less cannot keep track  of the actual
# >     appearance of the  screen (since this depends on how  the screen responds to
# >     each type of control character).
# >     Thus, various display problems may result, such as long lines being split in
# >     the wrong place.
#}}}
#   `S`?{{{
#
# It's a `less(1)` option which prevents long lines from being wrapped.
#}}}
export LESS=i~MRS
# Do *not* set the `F` option.{{{
#
# `F` makes less automatically  exit if the entire file can  be displayed on the
# first screen.
#
# This can cause an issue if less is invoked by another program.
# In particular,  if less  is invoked by  ranger when you  open an  archive file
# (e.g. `.tar.gz`), and if the archive contains only a few files, less will quit
# immediately and you won't be able to  read its contents (unless you enable the
# preview feature for  archive files, but this can cause  another issue specific
# to ranger).
#}}}
# How to make the cursor jump at the bottom of the screen, on startup?{{{
#
# Use the option `+G`.
#
#     export LESS=iMRS+G
#                     ^^
#}}}

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
# For more information, see `man lesspipe` or `man lessopen`.
#}}}
# Why the guard?{{{
#
# The `eval` has a big impact on performance.
# You can measure it with this command:
#
#     $ time zsh -c 'repeat 1000 source ~/.zshenv'
#}}}
if [[ -z "${LESSOPEN}" ]]; then
  # The default debian less package installs the script lesspipe.{{{
  #
  # But if you compile it from source, the script is not included.
  # We need to download it from: https://github.com/wofr06/lesspipe
  # And in this case, its name is `lesspipe.sh`.
  #}}}
  if command -v lesspipe >/dev/null 2>&1; then
    eval "$(lesspipe)"
  else
    eval "$(lesspipe.sh)"
  fi

  # Why inside the guard?{{{
  #
  # `lesskey(1)` doesn't seem to have a  big impact on performance at the moment
  # (probably  because our  lesskey file  is very  short), but  it could  in the
  # future.
  # Besides,  its purpose  is to  compile the  config of  `less(1)` in  a binary
  # format (in `~/.less`),  and it doesn't make  sense to do that  every time we
  # open a new shell.
  #}}}
  lesskey "${HOME}/.config/lesskey"
fi

# ls {{{1

# Ask `dircolors(1)`  to read its  config from  `~/.dircolors`, so that  it sets
# `$LS_COLORS`.
# The latter controls the colors in the output of `$ ls --color`.
if [[ -z "${LS_COLORS}" ]]; then
  eval "$(dircolors "${HOME}/.dircolors")"
fi

# man {{{1

# use Neovim as default man pager
# I want to use Vim as my man pager!{{{
#
# Then write this instead:
#
#     export MANPAGER='vim -M +MANPAGER -'
#
# See: `:h manpager.vim`.
#
# ---
#
# Note that, currently, the Neovim man plugin is better than the Vim one.
# The latter doesn't support some attributes such as bold/underlined.
#}}}
export MANPAGER='nvim +Man! -u ~/.vim/mini_init.vim'

# Purpose:{{{
#
# Write the word `printf` in a markdown buffer, then press `K`.
# `man(1)` will give to Vim the `printf` page from the section 1.
#
# But what if you prefer to give the priority to the section 3?
# That's where `$MANSECT` comes in.
# It lets you change the priority of the man sections.
# Here, I export the default value given in:
#
#     /etc/manpath.config
#
# Use this `export` statement to change the priority of the sections.
#
# Note that  pressing `3K` or  executing `man 3 printf`  will give you  the page
# from the section 3, no matter what `$MANSECT` contains.
# This variable is only useful for when you don't provide the section number.
#
# See `man 1 man` for more info.
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

# PAGER {{{1

# Some scripts/programs may rely on this variable to determine which pager they should invoke.{{{
#
# If `PAGER` is not set, they may fall back on `more(1)`.
# That's the case, for example, with the zsh script `run-help` (bound to `C-x H` atm):
#
#     /usr/share/zsh/functions/Misc/run-help
#
# We don't want that, because we're not used to its key bindings, and it's too limited.
# We always want `less(1)` to be invoked.
#}}}
export PAGER=less

# PATH {{{1

# https://github.com/golang/go/wiki/SettingGOPATH#zsh
export GOPATH=$HOME/go

# Why don't you set `CDPATH`?{{{
#
# In the past, we assigned it this value:
#
#     export CDPATH=:${HOME}:${HOME}/Downloads:${HOME}/Vcs:${HOME}/wiki:/run/user/${UID}
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
# in your `$PATH`, `man(1)` will also look for manpages in `<path>/share/man`:
#
#     https://askubuntu.com/a/633924/867754
#
# This means that since we have `~/bin`  in our `$PATH`, `man(1)` will look into
# `~/share/man`; IOW, this  lets us install manpages locally  (!= system-wide in
# `/usr/share/man`).
#}}}
export MANPATH=${HOME}/texlive/2018/texmf-dist/doc/man:${HOME}/Vcs/dasht/man:${MANPATH}:

# add the `texlive` and `dasht` binaries to our path
# Aren't `~/bin` and `~/.local/bin` already in `$PATH` by default?{{{
#
# `~/bin` is there by default.
# However, `~/.local/bin` is not there by default in Ubuntu 18.04 in a VM.
#
# Besides, both  paths are missing  when zsh  is started as  a login shell  in a
# virtual console.  Indeed, in that case:
#
#     $ pstree -lsp $$
#     systemd(1)---login(8518)---zsh(8579)---pstree(8900)~
#
# The shell  has only 2 ancestors,  none of which has a  PATH containing `~/bin`
# nor `~/.local/bin`.
#}}}
#     How to find the first ancestor of my shell whose `$PATH` contains them?{{{
#
# Run this:
#
#     $ pstree -lsp $$
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
# From `man upstart /--user`:
#
# >     --user Starts  in user mode, as used for user sessions. Upstart will be
# >            run as an unprivileged user, reading  configuration  files  from
# >            configuration locations as per roughly XDG Base Directory Speci‐
# >            fication. See init(5) for further details.
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
export PATH=${HOME}/bin:${HOME}/.local/bin:${PATH}:/usr/local/go/bin:${HOME}/Vcs/dasht/bin:${HOME}/texlive/2018/bin/x86_64-linux

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
# Because to get  the path to the  ruby gems programmatically, we need  to run a
# `ruby(1)` command, which is slow.
# We don't want the shell startup time to be impacted.
# }}}
# What is `-s` in `[[ -s file ]]`? {{{
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
  # See `man ruby /^\C\s*-e\>`.
  # }}}
  #     `puts`? {{{
  #
  # A ruby command similar to `printf`.
  # }}}
  #     `Gem.user_dir`? {{{
  #
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

# ripgrep {{{1

# https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgreprc"

# sudo {{{1

# Purpose:{{{
#
#     $ nvim file_owned_by_root
#     # edit file
#     :W
#     Error detected while processing BufWriteCmd Auto commands for "...":~
#     sudo: no tty present and no askpass program specified~
#
# According to the message, we need to specify an askpass program.
# If you search `askpass`  in `man sudo`, you'll find the  `-A` option (which we
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
# When I try to `:Gpush` a commit, the askpass program prompts me for a password.  I can't paste my password in it!{{{
#
# This has nothing to do with `SUDO_ASKPASS`.
# Since the commit `adba9c6`, fugitive runs the askpass program if `executable('ssh-askpass')`
# is true.
#
# Solution 1: Make sure your first commit push is not performed with `:Gpush`.
# Solution 2: Press Escape when askpass asks for your username, and when it asks for your password.
# Each time, fugitive will fall back on asking the info via the terminal.
#
# Once  you've  given  your  credentials,   you  won't  be  asked  again  before
# some  time  (look for  'timeout'  in  `~/.config/git/config`), thanks  to  the
# `git-credential-cache(1)` agent.
#}}}
export SUDO_ASKPASS='/usr/lib/ssh/x11-ssh-askpass'

# tldr {{{1

# Configure the colors and styles of the output of `tldr`.
export TLDR_HEADER='green bold'
export TLDR_QUOTE='italic'
# You can configure it further with these variables:
#     TLDR_DESCRIPTION
#     TLDR_CODE
#     TLDR_PARAM

# TZ {{{1

# Make WeeChat use less CPU.{{{
#
# >     8.3. How can I tweak WeeChat to use less CPU?
# >     ...
# >     Set the TZ variable (for example: export TZ="Europe/Paris"), to prevent frequent access to file /etc/localtime.
#
# https://weechat.org/files/doc/devel/weechat_faq.en.html#cpu_usage
#}}}
export TZ='Europe/Paris'

# XDG_* {{{1

# directories relative to which various kinds of user-specific files should be written
# For more info, see: https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
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

# remove duplicates in PATH & similar variables {{{1

# Purpose:{{{
#
# Some environment variables can contain duplicate entries.
#
# This is the case with `XDG_CONFIG_DIRS` and `XDG_DATA_DIRS`.
# It can have undesirable effects.
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
  # Also, I don't think bash supports  anonymous functions, so you would need to
  # give a name to this function, and call it right after defining it:
  #
  #     func() {
  #       ...
  #     }
  #     func
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
      # As a result, the while loop will never end.
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

