# Use emacs keybindings even if our EDITOR is set to vi.
# Warning:{{{
#
# Don't move this line after the `Sourcing` section.
# It would reset `fzf` key bindings.
#
# Don't move it after the `Abbreviations` section either.
# It would break them too (maybe because it removes the space key binding?).
#}}}
bindkey -e
# The previous command automatically installs a bunch of key bindings.
# This one is annoying, because we hit it by accident too often.  It's distracting.
bindkey -r '\eh'

# Why 131072?{{{
#
# I want a power of 2.
# In the past, I used 65536, but last time I needed a core file for a crash with
# Vim, the core needed more space; the next power of 2 is 131072, so that's what
# we use now.
#}}}
#   How much space does that stand for?{{{
#
# The limit  size for  a core  file must be  expressed as  a number  of 512-byte
# blocks; from `man zshbuiltins /ulimit/;/-c`:
#
# >    -c     512-byte blocks on the size of core dumps.
#
# So, 131072 should allow a core file up to 64 mebybytes (2^26 bytes).
#}}}
ulimit -c 131072

# disable XON/XOFF flow control
# Why?{{{
#
# By default, `C-s` and `C-q`  are interpreted by the terminal driver as
# “stop sending data“, “continue sending“.
#
# Explanations:
# http://unix.stackexchange.com/a/12108/125618
# http://unix.stackexchange.com/a/12146/125618
# http://unix.stackexchange.com/a/72092/125618
# https://en.wikipedia.org/wiki/Software_flow_control
#}}}
# alternative: stty -ixon
stty stop undef
stty start undef
# disable SIGQUIT signal
# Why?{{{
#
# By default, the terminal driver interprets `C-\` as the order to send the
# `SIGQUIT` signal to the foreground process.
# The latter can react to this signal however it wants; usually, it quits:
#
#     $ sleep 100
#     C-\
#     ^\[1]    28832 quit (core dumped)  sleep 100~
#
# We disable  this signal, because we could  use `C-\` as a key  binding in some
# application.
#}}}
stty quit undef

# prompt
# ------
# Our `prompt.zsh` script relies on the `add-zsh-hook` function.
# See:
# `man zshcontrib /Manipulating Hook Functions`
# `man zshmisc /SPECIAL FUNCTIONS/;/Hook Functions`
autoload -Uz add-zsh-hook
# And  it relies  on `PROMPT_SUBST`  being  set.  The  latter enables  parameter
# expansion, command substitution and arithmetic expansion inside the prompt.
setopt PROMPT_SUBST
# set the prompt
source "$HOME/bin/prompt.zsh"

# Why?{{{
#
# Named directories  are handy to  abbreviate the reference to  some directories
# with long paths.
#
# Here, as an example,  when I cd into `~/Downloads/XDCC`, I  want the prompt to
# print `~xdcc` instead of the full path.
#
# To do so, we need to:
#
#    1. create the named directory `~xdcc`
#    2. refer to it in a(ny) command
#}}}
hash -d xdcc=~/Downloads/XDCC/
hash -d tmp=/run/user/$UID/tmp

# What's `fpath`?{{{
#
# An array (colon separated list) of  directories specifying the search path for
# function definitions.
# This path is searched when a function with the `-u` attribute is referenced.
#}}}
# Why do I have to set `fpath` before invoking the `compinit` function?{{{
#
# Any change to `fpath` after `compinit` has been invoked won't have any effect.
#}}}
# Why do I have to put my completion functions at the very beginning of `fpath`?{{{
#
# To override any possible conflicting function (a default one, or coming from a
# third-party plugin).
#}}}
fpath=(
  ${HOME}/.zsh/my-completions
  # extra completion definitions, not available in a default installation, useful for virtualbox
  ${HOME}/.zsh/zsh-completions/src
  $fpath
  # completion for the `dasht` command: https://github.com/sunaku/dasht
  ${HOME}/Vcs/dasht/etc/zsh/completions
)

# Why loading this module?{{{
#
# We need it for:
#
#    - the `list-prompt` style to work
#    - the `menuselect` keymap to be available when we install key bindings.
#}}}
zmodload zsh/complist

# What's the purpose of these commands?{{{
#
# They  install  programmable completion  functions  for  the most  common  Unix
# commands.   They  also  enable  some  more  central  functionality,  on  which
# `zstyle`, for example, rely.
#}}}
# What's the equivalent in bash?{{{
#
#     $ . /etc/bash_completion
#}}}
# What's `autoload`?{{{
#
# `autoload` is equivalent to `functions -u`    (see `run-help autoload`)
#                                      │
#                                      └ autoload flag
#
# `functions` is equivalent to `typeset -f`     (see `run-help functions`)
#                                     │
#                                     └ the following name refers to a function
#                                       and not a parameter
#
# So:
#
#     autoload
#     ⇔
#     typeset -f -u
#
# Also, `typeset`  sets or displays  attributes and values for  shell parameters
# (see `run-help typeset`).
#}}}
# Why is `compinit` an autoloadable function, instead of a simple sourced script?{{{
#
# The behavior of a script could be altered by custom aliases.
# OTOH, a function can be made  autoloadable with `autoload` which can be passed
# the `-U` option, to suppress alias expansion.
#}}}
autoload -Uz compinit
#         ││{{{
#         │└ from `man zshbuiltins` (AUTOLOADING FUNCTIONS):
#         │      mark the function to be autoloaded using the zsh style,
#         │      as if the option KSH_AUTOLOAD was unset
#         │
#         │      i.e. the definition file contains the body of the function directly
#         │      (not `myfunc() {code}`, but just `code`)
#         │
#         └ from `man zshmisc`:
#               suppress usual alias expansion during reading
#}}}
compinit
# Is `compinit` slow?{{{
#
# The first time you start it, yes.
# If you've removed `~/.zcompdump`, yes.
#
# Otherwise, no.
#}}}

# What do these commands do?{{{
#
# A command of the form:
#
#     compdef foo=bar
#
# tells zsh to complete `foo` like it would complete `bar`.
#
# For more info, see:
# https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org#copying-completions-from-another-command
#}}}
compdef environ=kill
compdef ppa_what_have_i_installed=ppa_what_can_i_install
compdef surfraw=sr
# Why?{{{
#
# The virtualbox package provides different commands.
# Among them are:
#
#    - `vboxmanage` and `VBoxManage`
#    - `vboxheadless` and `VBoxHeadless`
#
# Thanks to the  `zsh-completions` plugin, we have completions  for the commands
# containing uppercase characters.
# But we don't have completions for the commands written exclusively in lowercase.
# So, we tell zsh to complete the  lowercase commands like it would complete the
# uppercase ones.
#}}}
compdef vboxmanage=VBoxManage
compdef vboxheadless=VBoxHeadless

# What's the purpose of these commands?{{{
#
# For some  commands, like `tldr`,  there's no easy  way to find/generate  a zsh
# completion function.  But there's one for bash.
# In this case, it can be useful to use the bash completion function.
# To do so, we need to install a compatibility layer to emulate `compgen` and `complete`.
#
# Source: `man zshcompsys`.
#}}}
# Will it always work as expected?{{{
#
# It depends on whether the bash completion  function you want to use needs only
# `compgen` and/or `complete`.
# If so, it should work, otherwise probably not.
#
# Source: https://unix.stackexchange.com/a/417143/289772
#}}}
autoload -Uz bashcompinit
bashcompinit

# Why removing the alias `run-help`?{{{
#
# By default, `run-help` is merely an alias for `man`.
# We want the `run-help` shell function  which, before printing a manpage, tries
# to find a help file in case the argument is a builtin command name.
#}}}
#   Why silently?{{{
#
# To avoid error messages when we reload zshrc.
#}}}
unalias run-help >/dev/null 2>&1
# Where is this `run-help` function?{{{
#
# It should be in:
#
#     /usr/share/zsh/functions/Misc/run-help
#
# Otherwise, have a look at:
#
#     $ dpkg -L zsh | grep /run-help$
#}}}
# What should I do if `run-help` doesn't work?{{{
#
# Its directory must be in `$fpath`.
# Make sure it is, and if it's not, add it.
#
# Also, the help pages must have been generated.
# They  should be  in  the default  value  given  to `HELPDIR`  in  the code  of
# `run-help`:
# Probably something like:
#
#     /usr/share/zsh/X.Y.Z-dev-0/help/
#
# If they are not in the directory, try to generate them.
# Download this perl script:
# https://github.com/zsh-users/zsh/blob/master/Util/helpfiles
#
# And use it:
#
#     perl /path/to/helpfiles  dest
#                              │
#                              └ where you want the helpfiles to be written
#
# Then, export  `HELPDIR` with the  value of  the directory where  you generated
# your helpfiles:
#
#     export HELPDIR=/path/to/dir
#}}}
autoload -Uz run-help
# Purpose:{{{
#
# Show me the help of `aptitude`, when I type `sudo aptitude` then press
# the key binding invoking `run-help`.
#
# By default, it's the help of `sudo` which would be shown.
#
# Note, that  `run-help` will  first show you  that `sudo` is  an alias  on your
# machine.  Press any key to get the manpage of `aptitude`.
#
# Do  the  same  thing for  various  other  commands  (if  you type  `git  add`,
# `run-help` should show you the help of `git-add`, ...).
#
# https://stackoverflow.com/a/32293317/9780968
#}}}
# Where did you find this list of functions?{{{
#
#     $ dpkg -L zsh | grep run-help
#}}}
autoload -Uz run-help-sudo \
             run-help-git \
             run-help-ip \
             run-help-openssl \
             run-help-sudo


# When we hit `C-w`, don't delete back to a space, but to a space *or* a slash.
# Useful to have more control over deletion on a filepath.
# http://stackoverflow.com/a/1438523
autoload -Uz select-word-style
select-word-style bash
# More flexible, easier solution (and more robust?):
# http://stackoverflow.com/a/11200998


# Enable the `cdr` function.{{{
#
# It lets you go back to previously visited directories.
# See: `man zshcontrib /REMEMBERING RECENT DIRECTORIES/;/Installation`
#}}}
autoload -Uz cdr

# Respect these principles for ordering the sections:{{{
#
# `Plugins` should be near the beginning because  we need to be able to override
# whatever interface they install.
#
# `Abbreviations` should be  right after `Key Bindings` because  it installs key
# bindings.
#
# `Syntax Highlighting` should  be at the end, because the  documentation of the
# plugin explains  that it must  be sourced after  all custom widgets  have been
# created (i.e., after all `zle -N` calls).
# Indeed, the plugin creates a wrapper around each widget.
# If we source it  before some custom widgets, it will still  work, but it won't
# be able to properly highlight the latters.
#}}}

# Options {{{1
# Never use `setopt` to unset an option.{{{
#
# Because, when you'll  search the option name in `man  zshoptions`, you'll lose
# time wondering why you can't find the name.
#
#     # ✔
#     unsetopt LIST_BEEP
#              ^^^^^^^^^ you can find this in `man zshoptions`
#
#     # ✘
#     setopt NOLIST_BEEP
#            ^^^^^^^^^^^ you can't find this in `man zshoptions`
#}}}

# Let us `cd` into a directory just by typing its name, without `cd`:{{{
#
#     my_dir/  ⇔  cd my_dir/
#
# Only works when `SHIN_STDIN` (SHell INput STanDard INput) is set, i.e. when the
# commands are being read from standard input, i.e. in interactive use.
#
# Works in combination with `CDPATH`:
#     $ cd /tmp
#     $ Downloads
#     $ pwd
#     ~/Downloads/
#
# Works with completion:
#     $ Do Tab
#     Documents/  Downloads/
#}}}
setopt AUTO_CD

# allow the expansion of `{a..z}` and `{1..9}`
setopt BRACE_CCL

# don't allow a `>` redirection to overwrite the contents of an existing file
# use `>|` to override the option
# setopt NO_CLOBBER

# Try to  correct the spelling  of commands.  The shell  variable CORRECT_IGNORE
# may  be set  to  a  pattern to  match  words that  will  never  be offered  as
# corrections.
setopt CORRECT

# Whenever a command  completion or spelling correction is  attempted, make sure
# the entire command path ($PATH?) is hashed first.
# This makes  the first completion slower  but avoids false reports  of spelling
# errors.
setopt HASH_LIST_ALL

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# allow comments even in interactive shells
setopt INTERACTIVE_COMMENTS

# never ring the bell on an ambiguous completion
unsetopt LIST_BEEP

# display PID when suspending processes as well
setopt LONG_LIST_JOBS

# Make zsh perform filename expansion on the command arguments of the form `var=val`.{{{
#
# zsh doesn't do it by default.
#
# MWE:
#     $ unsetopt MAGIC_EQUAL_SUBST
#     $ dd if=/dev/zero bs=1M count=1 of=~/test2
#                                        ^
#                                        ✘ not expanded into `/home/user`
#
#     $ echo foo=~/bar:~/baz
#          → foo=~/bar:~/baz
#                ^     ^
#                ✘     ✘
#
# This behavior differs from bash.
#}}}
# It also has the positive side effect of allowing filename completion.{{{
#
#     $ echo var=/us Tab
#}}}
setopt MAGIC_EQUAL_SUBST

# On an ambiguous completion, instead of listing possibilities,
# insert the first match immediately.
# This makes us enter the menu in a single Tab, instead of 2.
setopt MENU_COMPLETE

# Don't push multiple copies of the same directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS

# Allow us to include a single quote inside a single-quoted string, just by doubling it.{{{
#
#     echo 'foo''bar'
#     foo'bar~
#
# Like in vimscript.  This is more readable than `'\''`.
#
# Note that if your string is enclosed between `$'` and `'`, you can't include a
# single quote by writing `''`; you need to write `\'`.  See `man zshmisc /QUOTING`.
#}}}
setopt RC_QUOTES

# Do not query the user before executing `rm *` or `rm path/*`
setopt RM_STAR_SILENT

# Zstyles {{{1

# log up to 30 directories
zstyle ':chpwd:*' recent-dirs-max 30

# What does the 'format' style control?{{{
#
# The  appearance  of  a  description  for   each  list  of  matches,  when  you
# tab-complete a word on the command line.   Its value gives the format to print
# the message in.
#
# Example:
#
#                                      vvv    vvv
#     $ zstyle ':completion:*' format 'foo %d bar'
#     $ true Tab
#         → “foo no argument or option bar”
#            ^^^                       ^^^
#}}}
# How is the sequence '%d' expanded?{{{
#
# Into a description of the matches.
#
# For example:
#
#     $ echo SPC Tab
#       → file
#
#     $ true SPC Tab
#       → no argument or option
#}}}
# What about '%D'?{{{
#
# If there  are no matches, the  description mentions the name  of each expected
# list of matches.  `%d` separates those names with spaces, `%D` with newlines.
#
# Don't use `%D` for any context which is not tagged with 'warnings';
# it only works with 'warnings'.
#}}}
# How to print the text in bold?  In standout mode?  Underlined?{{{
#
# You can use the same escape sequences  you would use in a prompt, described at
# `man zshmisc /EXPANSION OF PROMPT SEQUENCES`:
#
#    ┌─────────┬───────────┐
#    │ %B...%b │ Bold      │
#    ├─────────┼───────────┤
#    │ %S...%s │ Standout  │
#    ├─────────┼───────────┤
#    │ %U...%u │ Underline │
#    └─────────┴───────────┘
#}}}
# How to start/stop using a new foreground color?  Background color?{{{
#
#    ┌──────────────┬──────────────────┐
#    │ %F{123}...%f │ Foreground color │
#    ├──────────────┼──────────────────┤
#    │ %K{123}...%k │ bacKground color │
#    └──────────────┴──────────────────┘
#}}}

# We set the 'format' style for some well-known tags.
# When does a completer tag the description of a list of matches with 'messages'?{{{
#
# When there can't be any completion:
#
#     $ true SPC Tab
#     no argument or option~
#}}}
#   What about 'descriptions'?{{{
#
# When there are matches:
#
#     $ true Tab
#     external command~
#     true~
#     builtin command~
#     true~
#     shell function~
#     truecolor~
#}}}
#   What about 'warnings'?{{{
#
# When there are no matches:
#
#     $ cat qqq Tab
#     No matches:~
#     file~
#     corrections~
#}}}
zstyle ':completion:*:messages'     format '%d'
zstyle ':completion:*:descriptions' format '%F{232}%K{230}%d%f%k'
zstyle ':completion:*:warnings'     format $'No matches:\n%D'

# What does `group-name` control?{{{
#
# It lets you group matches with the same tag.
# See `man zshcompsys /Standard Styles/;/group-name`
#}}}
#   Why do you set it to an empty string?{{{
#
# To let the completion system use the tag as the name of the group:
#
#    - external command
#    - builtin command
#    - shell function
#    - alias
#    - parameter
#    ...
#}}}
# How could I group the matches of command names (not shell functions, parameters, ...) together?{{{
#
#     zstyle ':completion:*:*:-command-:*:(commands|builtins|reserved-words|aliases)' group-name commands
#                             ├───────┘   ├────────────────────────────────────────┘
#                             │           └ zsh glob pattern matching several types of matches
#                             │
#                             └ Usually, we write the name of a command in this field.
#                               But  here, we  use  a  special name  `-command-`,
#                               which  restricts   the  style  to   a  completion
#                               triggered in command position.
#
# Alternatively, if  you couldn't  use the  glob pattern in  the tag  field, you
# could write this instead:
#
#     zstyle ':completion:*:*:-command-:*:commands'       group-name commands
#     zstyle ':completion:*:*:-command-:*:builtins'       group-name commands
#     zstyle ':completion:*:*:-command-:*:reserved-words' group-name commands
#     zstyle ':completion:*:*:-command-:*:aliases'        group-name commands
#                                                                    ├──────┘
#                                                                    └ arbitrary name for our group;
#                                                                      every type of matches in this group
#                                                                      would be printed in the same list
#}}}
zstyle ':completion:*' group-name ''
# What does `separate-sections` control?{{{
#
# It's used with the `manuals` tag when completing names of manual pages.
# When set,  zsh prints the different  sections of the manual  where the matches
# can be found.
#
# If the `group-name` style is also set to an empty string, pages from different
# sections will appear separately in different lists.
#}}}
# What about `insert-sections`?{{{
#
# It makes  zsh pass the  manual section to the  `man(1)` command even  when the
# `separate-sections` style is set.
# https://unix.stackexchange.com/a/604514/289772
#}}}
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*' insert-sections true

# Which style controls the printing of descriptions when completing command options?{{{
#
# 'verbose'
#
#     zstyle ':completion:*' verbose true
#
# Try it on this command:
#
#     $ typeset - Tab
#}}}
#   Why don't you set it?{{{
#
# It's already set to true by default.
#}}}
# What does the style `list-separator` control?{{{
#
# It defines the characters printed between a match and its description.
# By default, its value is `--`.
# I  prefer `  #`  as  it reminds  me  of a  shell  comment,  and separates  the
# description further from the match, which makes it more readable.
#}}}
zstyle ':completion:*' list-separator '  #'
# What does the style `auto-description` control?{{{
#
# It  defines  the  description  for  options that  are  not  described  by  the
# completion functions, but that have exactly one argument.
# The sequence `%d`  in the value will  be replaced by the  description for this
# argument.
#
# Example:
#
#     $ fetchmail --a Tab
#     option
#     --all         # retrieve old and new messages
#     --antispam    # ,   set antispam response values
#     --auth        # specify: authentication types
#                     ├───────┘├──────────────────┘
#                     │        └ added by the expansion of `%d`:
#                     │              description of the argument of `--auth`
#                     │
#                     └ added by the value of `auto-description`
#}}}
zstyle ':completion:*' auto-description 'specify: %d'

zstyle ':completion:*' list-prompt '%SAt %p%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"
#                                             ^^^^^^{{{
# `man zshexpn /PARAMETER EXPANSION/;/Parameter Expansion Flags/;/^\s*s:string:`
# Force field splitting at the separator string.
#}}}
# TODO: read this: https://unix.stackexchange.com/a/477527/289772
zstyle ':completion:*' list-colors ''

zstyle ':completion:*' completer '_expand' '_complete' '_correct' '_approximate'
# allow navigation in completion menu{{{
#
#     $ cat >/tmp/.zshrc <<'EOF'
#         mkdir /tmp/dir; touch /tmp/dir/file{1..2}
#         autoload -Uz compinit
#         compinit
#     EOF
#     ; ZDOTDIR=/tmp zsh
#
#     $ ls /tmp/dir/
#     # press:  Tab Tab Tab
#     # result:  the third Tab inserts "file1" but does not select the entry in the completion menu
#
#     $ zstyle ':completion:*' menu select
#     $ ls /tmp/dir/
#     # press:  Tab Tab Tab
#     # result:  the third Tab inserts "file1" *and* selects the entry in the completion menu
#}}}
zstyle ':completion:*' menu 'select'
# not sure, but the first part of the next command probably makes completion
# case-insensitive:    https://unix.stackexchange.com/q/185537/232487
# TODO: Sometimes, it doesn't work as I would want.{{{
#
# For   example,  suppose   I  have   the   directory  `lol/`   and  the   movie
# `The.Lego.Movie.2.1080p.HDRip.X264.AC3-EVO.mkv`:
#
#     $ mpv lego Tab
#     # result:  $ mpv lol
#
# However:
#
#     $ mpv the Tab
#     # result:  $ mpv The.Lego.Movie.2.1080p.HDRip.X264.AC3-EVO.mkv
#}}}
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' use-compctl 'false'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# This zstyle is important to make our `environ` function be completed with *all* the running processes.{{{
#
# And not just the processes running in the current shell.
# Found here: https://unix.stackexchange.com/a/281614/289772
#}}}
zstyle ':completion:*:processes' command 'ps -A'

# enable case-insensitive search (useful for the `zaw` plugin)
zstyle ':filter-select:*' case-insensitive yes
# Suggest us only video files when we tab complete `mpv(1)`.
#
# TODO: To explain.
# Source: https://github.com/mpv-player/mpv/wiki/Zsh-completion-customization
#
# `(#i)` is a globbing flag  which makes the following pattern case-insensitive.
# `(-.)`  is a  glob qualifier  restricting the  expansion to  regular files  or
# symlinks  pointing to  regular  files.  `(-/)` does  the  same  thing but  for
# directories.
zstyle ':completion:*:*:mpv:*' file-patterns \
  '*.(#i)(flv|mp4|webm|mkv|wmv|mov|avi|mp3|ogg|wma|flac|wav|aiff|m4a|m4b|m4v|gif|ifo)(-.) *(-/):directories' \
  '*:all-files'

# Plugins {{{1

# if we execute a non-existing command, suggest us some package(s),
# where we could find it (requires the deb package `command-not-found`)
[[ -f /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found

# download fasd
if [[ ! -f "${HOME}/bin/fasd" ]]; then
  curl -Ls 'https://raw.githubusercontent.com/clvv/fasd/master/fasd' -o "${HOME}/bin/fasd"
  chmod +x "${HOME}/bin/fasd"
fi

# When we start a shell, the fasd functions may slow the start up.
# As  a workaround,  we write  them in  a cache  (`~/.fasd-init-zsh`), which  we
# update when fasd is more recent.
fasd_cache="${HOME}/.fasd-init-zsh"
#     ┌ ~/bin/fasd is newer than the cache{{{
#     │                                           ┌ the cache doesn't exist, or it's empty
#     ├──────────────────────────────────────┐    ├──────────────────┐}}}
if [[ "$(command -v fasd)" -nt "${fasd_cache}" || ! -s "${fasd_cache}" ]]; then
  # What does it do?{{{
  #
  # It writes some code in a cache.
  # The code sets up:
  #
  #    - a command hook that executes on every command
  #    - an advanced tab completion
  #
  # The hook will  scan your commands' arguments and determine  if any of them
  # refer to existing files or directories.
  # If yes, fasd will add them to its database.
  #
  # See `man fasd` for more info.
  #}}}
  # Why caching the code?{{{
  #
  # We use `fasd` as an external binary.
  # Calling an external binary has some overhead.
  # OTOH, sourcing some file has no overhead.
  #}}}
  # Where did you find the command?{{{
  #
  # Read the output of:
  #
  #     $ fasd --init auto
  #
  # Note the presence of an `eval` in the code.
  # We don't use any `eval` to  avoid calling an external binary every time we
  # start a shell.
  # We source a cache instead.
  #}}}
  # What does each argument passed to `fasd` mean?{{{
  #
  #    ┌───────────────────┬──────────────────────────────────────────────────────┐
  #    │ posix-alias       │ define aliases that applies to all posix shells      │
  #    ├───────────────────┼──────────────────────────────────────────────────────┤
  #    │ zsh-hook          │ define _fasd_preexec and add it to zsh preexec array │
  #    ├───────────────────┼──────────────────────────────────────────────────────┤
  #    │ zsh-ccomp         │ zsh command mode completion definitions              │
  #    ├───────────────────┼──────────────────────────────────────────────────────┤
  #    │ zsh-ccomp-install │ setup command mode completion for zsh                │
  #    ├───────────────────┼──────────────────────────────────────────────────────┤
  #    │ zsh-wcomp         │ zsh word mode completion definitions                 │
  #    ├───────────────────┼──────────────────────────────────────────────────────┤
  #    │ zsh-wcomp-install │ setup word mode completion for zsh                   │
  #    └───────────────────┴──────────────────────────────────────────────────────┘
  #}}}
  fasd --init \
    posix-alias \
    zsh-hook \
    zsh-ccomp \
    zsh-ccomp-install \
    zsh-wcomp \
    zsh-wcomp-install >| "${fasd_cache}"
    #                 │{{{
    #                 └ >| word
    # From `man zshmisc`:
    #
    # > Same  as >,  except that  the file  is truncated  to zero  length if  it
    # > exists, even if CLOBBER is unset.
    #}}}
fi
source "${fasd_cache}"
unset fasd_cache
# TODO: delete the cache from time to time (once per day)?{{{
#
# Look at our warning comment before the global alias `V`.
# It describes an issue which may be solved by removing the fasd cache.
#
# More generally, maybe we should remove any cache from time to time.
#}}}

alias m='fasd -f -e mpv'
#                 │
#                 └ look for a file and open it with `mpv`

alias o='fasd -a -e xdg-open'
#                 │
#                 └ open with `xdg-open`

alias v='fasd -f -t -e vim -b viminfo'
#                 │  │      │
#                 │  │      └ use `viminfo` backend only (search only for files present in `viminfo`)
#                 │  └ open with vim
#                 └ match by recent access only

alias j='fasd_cd -d'
alias jj='fasd_cd -d -i'
unalias z zz

bindkey '^X^F' fasd-complete-f  # C-x C-f to do fasd-complete-f (only files)

# source fzf config
# Do NOT edit this line!{{{
#
# Not a single character.
# Otherwise, when you execute:
#
#     ~/.fzf/install
#
# manually or automatically, the installer will not recognize your line.
# It will then append this line at the end of your `~/.zshrc`:
#
#     [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#
# As a result, some of your zsh key bindings may be overridden.
# Including the `transpose-chars` command bound to `C-t`.
#}}}
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# https://github.com/zsh-users/zaw
#
# Usage:
#
#    1. Trigger zaw by pressing C-x ;
#    2. select source and press Enter
#    3. filter items with zsh patterns separated by spaces, use C-n, C-p and select one
#    4. press enter key to execute default action, or Meta-enter to write one
#
# TODO:
# Read the whole readme.  In particular the sections:
#
#     shortcut widgets
#     key binds and styles
#     making sources
[[ -f ${HOME}/.zsh/plugins/zaw/zaw.zsh ]] && source "${HOME}/.zsh/plugins/zaw/zaw.zsh"

# Why?{{{
#
# When we try to cd into a directory:
#
#    - the completion menu offered by this plugin is more readable
#      than the default one (a single column instead of several)
#
#    - we don't have to select an entry which could be far from our current position,
#      instead we can fuzzy search it via its name
#}}}
[[ -f ${HOME}/.zsh/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh ]] && \
source "${HOME}/.zsh/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh"
# TODO: It installs a keybinding on C-i (tab): zic-completion
# But doing so, it overwrites a key binding from fzf: fzf-completion
# Is it an issue?

# source our custom aliases and functions (common to bash and zsh) last
# so that they can override anything that could have been sourced before
[[ -f ${HOME}/.shrc ]] && source "${HOME}/.shrc"
# TODO: Remove this once we've removed `~/.shrc`.

# Functions {{{1
alias_is_it_free() { #{{{2
  emulate -L zsh

  # make sure the name hasn't been taken yet
  printf -- 'type %s:\n' "$1"
  type "$1"

  # make sure the name won't shadow a future command
  printf -- '\napt-file -x search "/%s$":\n' "$1"
  apt-file -x search "/$1$"
}

cc() { #{{{2
  emulate -L zsh
  # It's more convenient to type `cc` to invoke the `cdr` function, and to use fzf, to jump to a recent directory.
  # Wait.  Doesn't it conflict with our `cc` abbreviation?{{{
  #
  # No.  The abbreviation is meant to be used in the *middle* of the command-line.
  # This function is meant to be used at the *start* of the command-line.
  #}}}
  local dir
  dir="$(cdr -l | awk '{print $2}' | fzf -1 -0 --no-sort +m)"
  #           │                           │  │
  #           │                           │  └ exit immediately when there's no match
  #           │                           └ automatically select the only match
  #           └ lists the numbers and the corresponding directories in abbreviated form, one per line

  if [[ "$dir" =~ '^~' ]]; then
    # `${~name}` to expand `~/` and named directories{{{
    #
    # It's documented at: `man zshexpn /PARAMETER EXPANSION/;/${\~spec}`:
    #
    # >     Turn on the GLOB_SUBST option for the evaluation of spec; if the
    # >     `~`  is  doubled,  turn  it  off.   When this option is set, the
    # >     string resulting from the expansion will  be  interpreted  as  a
    # >     pattern anywhere that is possible, such as in filename expansion
    # >     and filename generation and pattern-matching contexts  like  the
    # >     right hand side of the `=` and `!=` operators in conditions.
    #}}}
    dir=${~dir}
  fi

  # if the directory does not exist anymore, remove it from the log file on which `cdr` relies
  # FIXME: `cd` fails to enter a directory containing a glob (e.g. `/tmp/a*b`){{{
  #
  #     $ mkdir /tmp/a\*b
  #     $ cd /tmp/a\*b && cd
  #     $ cc
  #     # select '/tmp/a\*b'
  #     cc:cd:36: no such file or directory: /tmp/a\*b~
  #
  # You get the same error if you pass the directory name to `cd` with quotes:
  #
  #     $ cd '/tmp/a\*b'
  #     cd: no such file or directory: /tmp/a\*b~
  #
  # But removing the quotes around `$dir` does not help.
  #
  #     if ! cd "$dir"; then
  #             ^    ^
  #}}}
  if ! cd "${dir}"; then
    cdr -P "$dir"
    return 1
  fi
}

cdt() { #{{{2
  emulate -L zsh
  cd "$(mktemp -d /tmp/.cdt.XXXXXXXXXX)"
}

chown2me() { #{{{2
  emulate -L zsh
  # Purpose:{{{
  #
  # Running this function  may be necessary before manually  compiling a program
  # which was installed via checkinstall.
  # }}}
  # Why don't you use a zsh snippet? {{{
  #
  # It's too easy to run the command by accident in the wrong directory.
  # We need some logic to make sure we're in the right kind of directory.
  # }}}
  if [[ ! "${PWD}" =~ "^${HOME}/Vcs" ]]; then
    printf -- "you need to be somewhere below ${HOME}/Vcs\n"
    return 64
  fi
  sudo chown -R $USER:$USER .
}

cs() { #{{{2
# Do *not* name the function `cheat`!{{{
#
# If you do, when you'll press Tab to get completions, a weird bug happens.
# Vim is not started properly, and you have to kill it with `$ kill vim Tab`.
# It's probably due to: `~/.zsh/zsh-completions/src/_cheat`
#
# Besides,  we'll probably read our  cheatsheets frequently, so the  shorter the
# name of the function the better.
#}}}
  emulate -L zsh
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
usage:    $0  <theme>
example:  $0  tmux
EOF
    return 64
  fi
  if [[ ! -f $HOME/wiki/cheat/$1 ]]; then
    printf -- 'no cheatsheet for %s\n' "$1"
    return
  fi
  vim +"Cs $1"
}

# cfg_* {{{2

#                                                        ┌ https://stackoverflow.com/a/7507068/9780968
#                                                        │
cfg_autostart() { "${=EDITOR}" "${HOME}/bin/autostartrc" ;}
cfg_bash() { "${=EDITOR}" -o "${HOME}/.bashrc" "${HOME}/.bashenv" "${HOME}/.bash_profile" ;}
cfg_conky() { "${=EDITOR}" "${HOME}/.config/conky/system.lua" "${HOME}/.config/conky/system_rings.lua" "${HOME}/.config/conky/time.lua" ;}
cfg_fasd() { "${=EDITOR}" "${HOME}/.fasdrc" ;}
cfg_fd() { "${=EDITOR}" "${HOME}/.fdignore" ;}
cfg_firefox() { "${=EDITOR}" ${HOME}/.mozilla/firefox/*.default/chrome/userContent.css ;}
cfg_git() { "${=EDITOR}" -o "${HOME}/.config/git/config" "${HOME}/.cvsignore" ;}
cfg_htop() { "${=EDITOR}" "${HOME}/.config/htop/htoprc" ;}
cfg_intersubs() { "${=EDITOR}" -o "${HOME}/.config/mpv/scripts/interSubs.lua" "${HOME}/.config/mpv/scripts/interSubs.py" "${HOME}/.config/mpv/scripts/interSubs_config.py" ;}
cfg_keyboard() { "${=EDITOR}" -o ${HOME}/.config/keyboard/* ;}
cfg_kitty() { "${=EDITOR}" "${HOME}/.config/kitty/kitty.conf" ;}
cfg_latexmk() { "${=EDITOR}" "${HOME}/.config/latexmk/latexmkrc" ;}
cfg_less() { "${=EDITOR}" "${HOME}/.config/lesskey" ;}
cfg_mpv() { "${=EDITOR}" -o "${HOME}/.config/mpv/input.conf" "${HOME}/.config/mpv/mpv.conf" ;}
cfg_newsboat() { "${=EDITOR}" -o "${HOME}/.config/newsboat/config" "${HOME}/.config/newsboat/urls" ;}
cfg_ranger() { "${=EDITOR}" "${HOME}/.config/ranger/rc.conf" ;}
cfg_readline() { "${=EDITOR}" "${HOME}/.inputrc" ;}
cfg_surfraw() { "${=EDITOR}" -o "${HOME}/.config/surfraw/bookmarks" "${HOME}/.config/surfraw/conf" ;}
cfg_tig() { "${=EDITOR}" "${HOME}/.config/tigrc" ;}
cfg_tmux() { "${=EDITOR}" "${HOME}/.config/tmux/tmux.conf" ;}
cfg_vim() { "${=EDITOR}" "${HOME}/.vim/vimrc" ;}
cfg_w3m() { "${=EDITOR}" "${HOME}/.w3m/config" ;}
cfg_weechat() { "${=EDITOR}" "${HOME}/.config/weechat/script/rc.conf" ;}
cfg_xbindkeys() { "${=EDITOR}" "${HOME}/.config/keyboard/xbindkeys.conf" ;}
cfg_xfce_terminal() { "${=EDITOR}" "${HOME}/.config/xfce4/terminal/terminalrc" ;}
cfg_zathura() { "${=EDITOR}" "${HOME}/.config/zathura/zathurarc" ;}
cfg_zsh() { "${=EDITOR}" -o "${HOME}/.zshrc" "${HOME}/.zshenv" ;}
cfg_zsh_snippets() { "${=EDITOR}" -o ${HOME}/.config/zsh-snippets/*.txt ;}
#                      │{{{
#                      └ Suppose that we export a value containing a whitespace:
#
#                            export EDITOR='env not_called_by_me=1 vim'
#
# This `export`  would cause  our functions  to fail,  because of the quotes
# which prevent zsh from doing field splitting.
# Besides, even  without the quotes,  zsh (contrary to  bash) does NOT  do field
# splitting on  variable expansion.
# So zsh would interpret the name of the command as `env ...`, instead of `vim`.
#
# Fortunately, we can force zsh to do field splitting using the `=` flag.
# For more info:
#
#     man zshexpn /${=spec}
#}}}

checkinstall_what_have_i_installed() { #{{{2
  emulate -L zsh
  aptitude search '?section(checkinstall)'
}

cmdfu() { #{{{2
  # Why don't you use the `-R` option anymore (`emulate -LR`)?{{{
  #
  # `emulate -R zsh` resets all the options to their default value, which can be
  # checked with:
  #
  #               ┌ current environment
  #               │         ┌ reset environment
  #               │         │
  #     vimdiff =(setopt) =(emulate -R zsh; setopt)
  #
  # It can be useful, but it can also have undesired effect:
  #
  #     https://unix.stackexchange.com/questions/372779/when-is-it-necessary-to-include-emulate-lr-zsh-in-a-function-invoked-by-a-zsh/372866#comment663732_372866
  #
  # Besides, most widgets shipped with zsh use `-L` instead of `-LR`.
  #}}}
  emulate -L zsh
  #        │{{{
  #        └ any option reset via `setopt` should be local to the current function,
  #          so that it doesn't affect the current shell
  #
  #          See:
  #              `man zshbuiltins`
  #              > SHELL BUILTIN COMMANDS
  #              > emulate
  #}}}

  if [[ $# -eq 0 ]]; then
    cat <<EOF >&2
  usage: $0 <keyword>
EOF
    return 64
  fi

  # Purpose: {{{
  #
  # Look up keywords on `www.commandlinefu.com`.
  #}}}

  # store our keywords in the variable `keywords`, replacing spaces with dashes
  keywords="$(sed 's/ /-/g' <<< "$@")"
  # store their base64 encoding in `encoding`
  # Could I replace `printf` with `<<<`?{{{
  #
  # No.
  #
  # Watch:
  #
  #         $ printf -- 'hello world' | base64
  #
  #             → aGVsbG8gd29ybGQ= (✔)
  #
  #         $ base64 <<< 'hello world'
  #         $ printf -- 'hello world\n' | base64
  #
  #             → aGVsbG8gd29ybGQK (✘)
  #
  # We can't use `<<<` because when the shell expands a “here string”:
  #
  #       The result is  supplied as a single string, WITH A  NEWLINE APPENDED, to the
  #       command on its standard input.
  #
  # The appended newline alters the encoding.
  #}}}
  encoding="$(printf -- "$@" | base64)"

  if highlight --syntax sh <<<test >/dev/null 2>&1; then
    # Alternative using `highlight`:{{{
    #
    #     curl -Ls "http://www.commandlinefu.com/commands/matching/${keywords}/${encoding}/sort-by-votes/plaintext" \
    #     | highlight -O xterm256 -S bash -s bright | less -iR
    #}}}
    #     ┌ download silently (no errors, no progression){{{
    #     │
    #     │┌ if the url page has changed, try the new address
    #     ││}}}
    curl -Ls "http://www.commandlinefu.com/commands/matching/${keywords}/${encoding}/sort-by-votes/plaintext" \
    | highlight --syntax sh -O truecolor --style seashell | less -iR
    #             │          │             │{{{
    #             │          │             └ we want the 'seashell' highlighting style
    #             │          │               (to get the list of available styles: `highligh -w`)
    #             │          │
    #             │          └ output the file for a truecolor terminal
    #             │            (you can use other formats: html, latex ...)
    #             │
    #             └ the syntax of the input file is bash
    #}}}
  else
      cat <<'EOF' >&2
Install `highlight` to get syntax highlighting.
EOF
    curl -Ls "http://www.commandlinefu.com/commands/matching/${keywords}/${encoding}/sort-by-votes/plaintext" \
    | less -iR
  fi
  #       ││{{{
  #       │└ --RAW-CONTROL-CHARS
  #       │
  #       │  don't display control characters used to set colors;
  #       │  send them instead to the terminal which will interpret them
  #       │  to colorize the text
  #       │
  #       └ --ignore-case
  #
  #        when we search for a  pattern (`/pat`), ignore the difference between
  #        uppercase and lowercase characters in the text
  #}}}
}

environ() { #{{{2
  emulate -L zsh
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
  purpose: print the environment variables of an arbitrary process
  usage: $0 PID
EOF
    return 64
  fi
  # https://serverfault.com/a/66366
  tr '\0' '\n' </proc/$1/environ
  # Alternative: `sed 's/\x0/\n/g' "/proc/$1/environ"`
}

expand_this() { #{{{2
  # Purpose?{{{
  #
  # Suppose you want to remove some files, and you pass a glob pattern to `rm`:
  #
  #     $ rm foo*bar
  #
  # You're afraid of removing important files, because you're not sure what the glob
  # expands into.
  # `expand_this` to the rescue:
  #
  #     $ expand_this foo*bar
  #}}}
  emulate -L zsh

  # Why not `$*`?{{{
  #
  # Because  it would  quote  the whole  expansion  of the  glob  passed to  the
  # function as a single argument.
  # As a result, the latter would be printed on a single line.
  #
  # I prefer the  expansion of the glob to be printed on  several lines: one per
  # file.
  #}}}
  if [[ $# -eq 0 ]]; then
    cat <<EOF >&2
usage:
    $0 <glob pattern>
    $0 <expansion parameter>

examples:
    $0 *
    $0 "\${path[@]}"
EOF

    return 64
  fi
  printf -- '%s\n' "$@"
}
# fasd_add  fasd_remove {{{2

# The benefit of this function over `$ fasd -A` is that you get an immediate feedback.
# You know whether the path was added to fasd's database.
#
# Don't try to shorten its name.
# Keep  the  `fasd`  prefix,  so  that  we see  the  function  when  we  try  to
# tab-complete `fasd(1)`; this may help us remembering its existence.
fasd_add() {
  emulate -L zsh
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
  usage: $0 <filepath to add in fasd's database>
EOF
    return 64
  fi

  fasd -A "$1"
  if fasd | grep -P "^\d*\.?\d*\s*$(realpath $1)$"; then
    echo "added $1"
  else
    echo "failed to add $1"
  fi
}

fasd_remove() {
  emulate -L zsh
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
  usage: $0 <filepath to remove from fasd's database>
EOF
    return 64
  fi

  fasd -D "$1"
  if ! fasd | grep -P "^\d*\.?\d*\s*$1$"; then
    echo "removed $1"
  else
    echo "failed to remove $1"
  fi
}
#}}}2

ff_audio_extract() { #{{{2
  emulate -L zsh
  if [[ $# -ne 3 ]]; then
    cat <<EOF >&2
usage:    $0  <video file>  <audio stream number>  <output extension>
example:  $0  file.mkv  0  mp3
info:     the streams are indexed from 0
EOF
    return 64
  fi

  local out="audio.$3"
  #       ┌ input file{{{
  #       │
  #       │       ┌ disable video recording (skip video)
  #       │       │
  #       │       │   ┌ copy the audio stream keeping the original codec
  #       │       │   │}}}
  ffmpeg -i "$1" -vn -c:a copy -map "0:a:$2" "${out}"
  #                             │{{{
  #                             └ select the N-th (:"$2") audio stream
  #                               of the first input file (0:)
  #}}}
  if [[ $? -eq 0 ]]; then
    printf -- "The audio stream has been extracted in:  '%s'\n" "${out}"
  fi
}

ff_video_extract() { #{{{2
  emulate -L zsh
  if [[ $# -ne 2 ]]; then
    cat <<EOF >&2
usage:    $0  <video file>  <video stream number>
example:  $0  file.mp4  0
info:     the streams are indexed from 0
EOF
    return 64
  fi

  # https://stackoverflow.com/a/965072/9780968
  local filename=$(basename -- "$1")
  local extension="${filename##*.}"
  local out="video.${extension}"

  #       ┌ input file{{{
  #       │
  #       │       ┌ disable audio recording (skip audio)
  #       │       │
  #       │       │   ┌ copy the video stream keeping the original codec
  #       │       │   │}}}
  ffmpeg -i "$1" -an -c:v copy -map "0:v:$2" "${out}"
  #                             │{{{
  #                             └ select the N-th (:"$2") video stream
  #                               of the first input file (0:)
  #}}}
  if [[ $? -eq 0 ]]; then
    printf -- "The video stream has been extracted in:  '%s'\n" "${out}"
  fi
}

ff_audio_record() { #{{{2
  emulate -L zsh
  local out='/tmp/rec.wav'
  ffmpeg -f pulse -i default -y "${out}"
  #       │ │        │        │{{{
  #       │ │        │        └ overwrite output files without asking
  #       │ │        │
  #       │ │        └  From `man ffmpeg-devices`:
  #       │ │
  #       │ │                  The filename to provide to the input device
  #       │ │                  is a source device or the string "default".
  #       │ │
  #       │ └ PulseAudio output device
  #       │
  #       │   See:
  #       │           man ffmpeg-devices
  #       │           /^\s*pulse$
  #       │
  #       └ -f fmt (input/output):
  #
  #             Force input or output file format.
  #             The format is normally auto detected for input files and guessed
  #             from the file extension for output  files, so this option is not
  #             needed in most cases.
  #}}}
  if [[ $? -eq 0 ]]; then
    printf -- "\nThe audio stream has been recorded in:  '%s'\n" "${out}"
  fi
}

ff_desktop_record() { #{{{2
  emulate -L zsh
  ffmpeg -draw_mouse 1                     \
         -f x11grab                        \
         -framerate 25                     \
         -video_size '1920x1080'           \
         -i :0.0                           \
         -y                                \
                /tmp/recording_desktop.mkv \
                >/dev/null 2>&1 &
}

ff_get_stream_info() { #{{{2
  emulate -L zsh
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
usage:    $0  <file>
EOF
    return 64
  fi

  ffprobe "$1" |& grep -i stream
}

ff_mux_video_and_audio() { #{{{2
  emulate -L zsh
  if [[ $# -ne 3 ]]; then
    cat <<EOF >&2
usage:    $0  <video file>  <audio file>  <name of the audio track>
example:  $0  file.mkv  audio.aac  eng
EOF
    return 64
  fi

  local out='out.mkv'

  # Broken down:{{{
  #
  # -c:v copy            = copy video stream using the same codec
  # -c:a                 = copy audio stream using aac codec
  # -strict experimental = allow experimental decoders and encoders
  # -map 0               = use all the streams of the first input file
  # -map 1:a:0           = use the first audio stream of the second input file
  #
  # -metadata:s:a:1 language=jpn    = give the title 'jpn' to the 2nd audio track of the muxed file
  #           ^
  #           per-stream (≈ local to a stream) metadata
  #           For more info, see `man ffmpeg`, and search for '-map_metadata'.
  #}}}
  ffmpeg -i "$1" \
         -i "$2" \
         -c:v copy \
         -c:a aac \
         -strict experimental \
         -map 0 \
         -map 1:a:0 \
         -metadata:s:a:1 language="$3" \
         "${out}"

  if [[ $? -eq 0 ]]; then
    printf -- "The streams have been muxed in:  '%s'\n" "${out}"
  fi
}

ff_sub_extract() { #{{{2
  emulate -L zsh
  if [[ $# -ne 2 ]]; then
    cat <<EOF >&2
usage:    $0  <video file>  [<subtitle number>]
EOF
    return 64
  fi

  # We're going to extract the subtitles as an `.srt` file.  But what if the file contains an `.ass` subtitle stream?{{{
  #
  # It doesn't matter.
  # `ffmpeg` will do the extraction AND the conversion.
  #}}}
  local out='sub.srt'
  ffmpeg -i "$1" -map "0:s:$2" "${out}"
  #                    │ │ │{{{
  #                    │ │ └ select the N-th one
  #                    │ │
  #                    │ └ select a subtitle
  #                    │
  #                    └ select the first input file
  #}}}
  if [[ $? -eq 0 ]]; then
    printf -- "The subtitles have been extracted in:  '%s'\n" "${out}"
  fi

  # In case of an issue, see: https://superuser.com/a/927507/913143
}

ff_video_to_gif() { #{{{2
  emulate -L zsh
  if [[ $# -ne 2 ]]; then
    cat <<EOF >&2
usage:    $0  <video file>  <output.gif>
EOF
    return 64
  fi
  gifenc "$1" "$2" >/dev/null 2>&1
}
#}}}2

find_pgm() { #{{{2
  emulate -L zsh
  # A failed filename generation makes zsh stop processing the function.{{{
  #
  # Because  of this,  and because  we  may have  a directory  in `$PATH`  which
  # doesn't contain any file (e.g.  `/usr/local/sbin/`), zsh will fail to expand
  # `$dir/*`, and when that happens, it will stop the function immediately.
  # As a result, we will be missing the programs in the directories afterwards.
  #}}}
  unsetopt NOMATCH

  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
usage: $0 <command name>
example: $0 edit
EOF
    return 64
  fi

  for dir in "${path[@]}"; do
    #          ┌ yes, you really need the quotes (if one of the directory name contains a path)
    #          │
    for cmd in "${dir}/"*; do
      if [[ -x "${cmd}" && ! -d "${cmd}" ]]; then
        echo "${cmd}"
      fi
    done
  done | sort | grep "$1"
}

fix() { #{{{2
  # If you want the terminal to be in an unsane state, to test the function:{{{
  #
  #     printf '\e(0'
  #}}}
  emulate -L zsh

  # For more info: https://unix.stackexchange.com/q/79684/289772
  reset

  stty sane
  # those settings come from the ouputof `stty(1)` in a non-broken terminal
  stty speed 38400
  stty quit undef
  stty start undef
  stty stop undef
  # breaks does *not* cause an interrupt signal
  stty -brkint
  stty -imaxbel
  # assume input characters are UTF-8 encoded
  stty iutf8

  # What's the `rs1` capability?{{{
  #
  # A Reset String.
  #
  #     man -Kw rs1
  #     man infocmp /rs1
  #     man tput /rs1
  #}}}
  tput rs1
  tput rs2
  tput rs3
  tput cnorm
  # make sure the cursor's shape is a steady block
  tput Se
  clear
  printf -- '\ec'
}
#}}}2

fzf_clipboard() { #{{{2
  emulate -L zsh
  # TODO:
  # Find a clipboard manager which you can configure to ignore some apps.
  # Greenclip doesn't allow  you to do that  (you can but, for  some reason, its
  # configuration is reset whenever you copy some text).
  #
  # See: https://wiki.archlinux.org/index.php/Clipboard#Managers
  # (clipster seems the least bad...)
  #
  # Also, see “rofi bangs”: https://www.youtube.com/watch?v=kxJClZIXSnM
  # It could be useful to have a central location from which we can fuzzy search
  # the clipboard history, start apps, launch websearches for various engines...

  # fuzzy find clipboard history
  #
  #     xsel -ib <<<"$(greenclip print | fzf)"
}

fzf_fasd() { #{{{2
  emulate -L zsh
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
usage:    $0  <command>
example:  $0  vim
EOF
    return 64
  fi

  local cmd="$1"
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    printf -- "%s is not a command\n" "${cmd}"
    return 65
  fi

  local chosen_path
  chosen_path="$(fasd -lR | fzf --no-sort --preview '{ highlight -O ansi {} || cat {} ;} 2>/dev/null')"
  if [[ "${chosen_path}" == '' ]]; then
    return
  fi

  "${cmd}" "${chosen_path}"
}

fzf_locate() { #{{{2
  emulate -L zsh
  if [[ $# -ne 2 ]]; then
    cat <<EOF >&2
usage:    $0  <command>  <pattern>
example:  $0  vim  vimrc
EOF
    return 64
  fi

  local cmd="$1"
  local pat="$2"

  if ! command -v "${cmd}" >/dev/null 2>&1; then
    printf -- "%s is not a command\n" "${cmd}"
    return 65
  fi

  # do *not* use the variable name `path`; it would conflict with the tied array `path`,
  # which would prevent the next `command` from working
  local chosen_path
  chosen_path="$(locate "${pat}" | fzf --preview '{ highlight -O ansi {} || cat {} ;} 2>/dev/null')"
  # Why?{{{
  #
  # It doesn't make sense to start a program if we don't provide it any path.
  #
  # ---
  #
  # Also, try this:
  #
  #     $ vim "$(locate vimrc | fzf)"
  #
  # Leave fzf by pressing Escape.
  # Vim will be started with a noname buffer.
  # Press `i` to enter insert mode.
  # It may not work because of this command in `vim-term`:
  #
  #     call timer_start(10, {-> execute('checktime %', 'silent!')})
  #                                                      ^^^^^^^
  #                                                      hides warning message
  #
  # There's a  warning message asking a  question, but because of  `silent!`, we
  # can't see it.
  #
  # Interestingly, the issue disappears if you remove the quotes around `$()`:
  #
  #     $ vim $(locate vimrc | fzf)
  #}}}
  if [[ "${chosen_path}" == '' ]]; then
    return
  fi

  "${cmd}" "${chosen_path}"
}
#}}}2

grep_pdf() { #{{{2
  # Purpose:{{{
  #
  # Grep a pattern in a set of pdf files.
  #}}}
  # Rationale:{{{
  #
  # We can't grep for a pattern in a set of files with any grep-like shell tool.
  #
  # You can in Vim, but you need to visit each buffer so that one of our autocmd
  # converts it from pdf to text.
  # This function takes care of all of that.
  #}}}
  # Tip:{{{
  #
  # You don't  need to re-invoke this  function when you're looking  for several
  # patterns in the SAME set of files.
  # After the function has been invoked  once, the pdfs will have been converted
  # to  text in  Vim buffers,  and you'll  be able  to grep  them as  usual with
  # `:vimgrep` from the current Vim instance.
  #}}}
  # Alternative: pdfgrep utility{{{
  #
  #     $ aptitude install pdfgrep
  #     $ find /path -iname '*.pdf' -exec pdfgrep pattern {} +
  #
  # The `+`  at the end prevents  `find` from executing a  `pdfgrep` command for
  # every file it finds.
  # Instead it  concatenates  them all  and  pass them  to  a single  `pdfgrep`
  # command:
  #
  #     pdfgrep pat file1
  #     pdfgrep pat file2
  #     ...
  #   →
  #     pdfgrep pat file1 file2 ...
  #
  # Source:
  #     https://unix.stackexchange.com/a/27517/289772
  #}}}
  emulate -L zsh
  if [[ $# -lt 2 ]]; then
    cat <<EOF >&2
usage:
    $0 'vim regex' file1.pdf file2.pdf ...
    $0 'vim regex' *.pdf
EOF
    return 64
  fi
  local pat="$1"
  # remove the first argument so that `$@` expands to the files,
  # without including the pattern
  # Why `:argdo`?{{{
  #
  # Before we can grep the buffers, they need to be converted to text.
  # We have an autocmd `filter_special_file` in our vimrc to do that.
  # It listens to `BufWinEnter`.
  # So we fire it for every buffer in the arglist.
  #
  # Note that you could use `BufReadPost` too.
  #}}}
  # Why not `:doautoall BufWinEnter` instead?{{{
  #
  # For some reason it doesn't work.
  #
  # According to `:h :doautoall`, the command  works only on loaded buffers; and
  # our pdf buffers, even though not converted yet, are immediately loaded.
  #
  # Also, the help mentions this:
  #
  #     Careful: Don't use this for autocommands that delete a
  #     buffer, change to another buffer or CHANGE THE
  #     CONTENTS OF A BUFFER; THE RESULT IS UNPREDICTABLE.
  #
  # It could explain why `:doautoall` fails.
  #}}}
  # Why `sil!` before `:vim`?{{{
  #
  # If the pattern is absent, I don't want any error message to be printed.
  #}}}
  shift 1
  vim \
  +'argdo do BufWinEnter' \
  +"sil! noa vim /${pat}/gj ## | cw" \
  "$@"
}

help() { #{{{2
  emulate -L zsh
  # Rationale:{{{
  #
  # In bash, the equivalent of `run-help` is `help`.
  # This is inconsistent.
  #
  # Also, `run-help` prints on the terminal.
  # I prefer a Vim buffer.
  #}}}
  run-help "$@" | vipe
}

in_fileA_but_not_in_fileB() { #{{{2
  emulate -L zsh
  if [[ $# -ne 2 ]]; then
    cat <<EOF >&2
usage:
    $0 <file_a> <file_b>
EOF
    return 64
  fi
  # http://unix.stackexchange.com/a/28159
  # Why `wc -l <file` instead of simply `wc -l file`?{{{
  #
  #     $ wc -l file
  #     5 file
  #
  #     $ wc -l < file
  #     5
  #
  # I think that when  you reconnect the input of `wc(1)`  like this, it doesn't
  # see  a file  anymore, only  its contents,  which removes  some noise  in the
  # output.
  #}}}
  diff -U $(wc -l <"$1") "$1" "$2" | grep '^-' | sed 's/^-//g'
}

gpg_key_check() { #{{{2
  emulate -L zsh
  if [[ $# -ne 2 ]]; then
    cat <<EOF >&2
  usage: $0 /path/to/key.asc <expected fingerprint>
EOF
    return 64
  fi

  [[ $(gpg --with-fingerprint "$1" \
    | awk 'BEGIN { FS = " = " }; /fingerprint/ { print $2 }') == "$2" ]] \
    && echo 'VALID' || echo 'NOT VALID'
}

loc() { #{{{2
  # Purpose:{{{
  #
  # Suppose you want to find all files containing `foo` and `bar` or `baz`:
  #
  #     $ locate -ir 'foo.*\(bar\|baz\)'
  #
  # With this function, the command is simpler:
  #
  #     $ loc 'foo (bar|baz)'
  #}}}

  emulate -L zsh
  #               ┌ 'foo bar' → 'foo.*bar'
  #               ├──────┐
  keywords=$(sed 's/ /.*/g' <<< "$@" | sed 's:(:\\(:g; s:|:\\|:g; s:):\\):g')
  locate -ir "${keywords}" | vim -R --not-a-term -
  #       ││
  #       │└ search for a basic regexp (not a literal string)
  #       │
  #       └ ignore the case
}

logout() { #{{{2
  # Note that  this function  shadows the  `logout` builtin,  but we  don't care
  # because it's a synonym for `exit`.
  emulate -L zsh
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
  usage: $0 session
         $0 reboot
         $0 poweroff
EOF
    return 64
  fi

  case $1 in
    session)
      # https://unix.stackexchange.com/a/321096/289772
      session="$(loginctl session-status | awk 'NR==1{print $1}')"
      loginctl terminate-session "${session}"
      ;;
    reboot)
      # Why not just `$ systemctl reboot`?{{{
      #
      # We have an issue which makes the OS hang when we reboot/poweroff.
      # It's related to the swap partition.
      # To avoid the issue, we need to disable it before rebooting.
      #
      # Also, if it fails or there's  another issue, having a debug shell during
      # a  reboot/poweroff can  be useful,  so we  also start  the `debug-shell`
      # service.
      # To access the debug shell, simply press `Ctrl-Alt-F9`.
      #
      # ---
      #
      # Try  to avoid  enabling the  `debug-shell` service;  it would  start the
      # debug  shell  permanently  which  is  a *security  hole*  as  it  allows
      # unauthenticated and  unrestricted root  access to  your computer  if you
      # forget to disable it.
      #
      # Source: /usr/share/doc/systemd/README.Debian.gz
      #}}}
      # TODO: Remove `swapoff -a` once our poweroff hanging issue is fixed.
      # I guess that'll be when you upgrade Ubuntu.
      # Keep `systemctl start debug-shell`; could still be useful.
      sudo systemctl start debug-shell && sudo swapoff -a && systemctl reboot
      ;;
    poweroff)
      sudo systemctl start debug-shell && sudo swapoff -a && systemctl poweroff
      ;;
  esac
}

man_pdf() { #{{{2
  emulate -L zsh
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
  usage: $0 <command name>
EOF
    return 64
  fi
  manpage="$(locate $1 | sed -n "\%share/man/man[^/]*/$1\.%p")"
  # There may be several pages:{{{
  #
  #     $ locate printf | sed -n "\%share/man/man[^/]*/printf\.%p"
  #     /usr/share/man/man1/printf.1.gz~
  #     /usr/share/man/man3/printf.3.gz~
  #
  # In that case, grab the first.
  #
  # This explains how to split a string where a newline is:
  # https://stackoverflow.com/a/19772067/9780968
  #}}}
  read manpage <<<"${manpage}"
  if [[ -z "${manpage}" ]]; then
    printf -- 'no manpage was found for %s\n' "$1"
    return 65
  fi
  # For the `--mode` option, see: https://unix.stackexchange.com/a/462383/289772
  groff -man -Tpdf <(zcat "${manpage}") | zathura --mode fullscreen -
  #      │{{{
  #      └ shorthand for `-m man`
  #        include the macro package `man`
  #}}}
}

man_zsh() { #{{{2
  emulate -L zsh
  # Purpose:{{{
  #
  # We often need to look up a word in the 16 zsh man pages.
  # This function  could be handy to  narrow down the few  pages containing this
  # word.
  #}}}
  man -s1 -Kw "$@" | grep zsh
  #   ├─┘
  #   └ drastically reduce the amount of time the search takes
}

mkcd() { #{{{2
  # create directory and cd into it right away
  emulate -L zsh
  mkdir "$*" && cd "$*"
}

mountp() { #{{{2
  emulate -L zsh

  # mount pretty ; fonction qui espace / rend plus jolie la sortie de la commande mount
  mount | awk '{ printf -- "%-11s %s %-26s %s %-15s %s\n", $1, $2, $3, $4, $5, $6 }' -
}

nstring() { #{{{2
  emulate -L zsh

  # Description:
  # count the nb of occurrences of a substring `sub` inside a string `foo`.
  #
  # Usage:    nstring sub str

  grep -o "$1" <<< "$2" | wc -l
  #     │       │
  #     │       └ redirection ; `grep` only accepts filepaths, not a string
  #     │
  #     └ --only-matching; print  only the matched (non-empty) parts of
  #                        a matching line, with each such part on a separate
  #                        output line
}

# number conversion between bases {{{2

# Source: http://user.it.uu.se/~embe8573/conf/.zsh/math {{{
#
# The link contains some errors.
# The output base should be expressed using the input base.
# This matters whenever the output base is bigger than the input base.
#}}}
change-base () {
    emulate -L zsh
    local from="$1"
    local to="$2"
    local value="$3"
    value="$(tr a-f A-F <<<"${value}")"

    bc <<<"ibase=${from}; obase=${to}; ${value}"
}

# To look for all the functions in this file defined without curly braces:
#
#     /^\s*\S*()\%(.*{\)\@!

# from binary
bin2oct() change-base 2 1000  "$1"
bin2dec() change-base 2 1010  "$1"
bin2hex() change-base 2 10000 "$1"

# from octal
oct2bin() change-base  8  2 "$1"
oct2dec() change-base  8 12 "$1"
oct2hex() change-base  8 20 "$1"

# from decimal
dec2bin() change-base 10  2 "$1"
dec2oct() change-base 10  8 "$1"
dec2hex() change-base 10 16 "$1"

# from hexadecimal
hex2bin() change-base 16  2 "$1"
hex2oct() change-base 16  8 "$1"
hex2dec() change-base 16  A "$1"

nv() { #{{{2
#    │
#    └ You want to prevent the  change of `IFS` from affecting the current shell?
# Ok.  Then, use `local IFS`.
# Do *not*  use parentheses to  surround the body of  the function and  create a
# subshell.  It could cause an issue when we suspend then restart Vim.
# https://unix.stackexchange.com/a/445192/289772

  emulate -L zsh

  local file pgm server
  server='VIM'

  # if no server is running, just start one
  # Why do you look for a server whose name is VIM?{{{
  #
  # By default, when you execute:
  #
  #     $ vim --remote file
  #
  # ... without `--servername`, Vim tries to open `file` in a Vim server
  # whose name is VIM.
  # So, we use this name for our default server.
  # This way, we won't have to specify the name of the server later.
  # }}}
  # Why the `-x` flag for `grep(1)`?{{{
  #
  # It stands for "eXact match".
  #
  # It's  necessary to  handle the  case where  gVim is  currently running;  the
  # latter becomes a server  whose name is GVIM.  Because of  this, if you don't
  # pass `-x` to `grep(1)`, you can't restart Vim (`SPC R`) while gVim is running.
  #}}}
  if ! vim --serverlist | grep -qx "$server"; then
    vim -w /tmp/.vimkeys --servername "$server" "$@"
    return
  fi

  # if no argument was given, just start a new Vim session
  if [[ $# -eq 0 ]]; then
    vim
    return
  fi

  # From now on, you can assume a server is running.

  # Save the tmux pane id of the Vim server now.  *Before* the other `--remote-*`.{{{
  #
  # Otherwise, there would  be a noticeable delay between the  moment the server
  # has executed/evaluated our command, and the moment it's focused.
  #}}}
  if [[ -n "$TMUX" ]]; then
    pane_id="$(vim --remote-expr "\$TMUX_PANE")"
  fi

  # if the 1st argumennt is `-b`, we want to edit binary files
  if [[ $1 == -b ]]; then
    # Get rid of `-b` before send the rest of the arguments to the server, by
    # shifting the arguments to the right.
    shift 1
    # Make sure that the shell uses a space, and only a space, to separate
    # 2 consecutive arguments, when it will expand the special parameter `$*`.
    local IFS=' '

    # send the filenames to the server
    vim --remote "$@" --servername "$server"
    # For each buffer in the arglist:{{{
    #
    #    - enable the 'binary' option.
    #      Among other things, il will prevent Vim from doing any kind of
    #      conversion, which could damage the files.
    #
    #    - set the filetype to `xxd` (to have syntax highlighting)
    #}}}
    vim --remote-send ":argdo setl binary ft=xxd<cr>" --servername "$server"
    # filter the contents of the binary buffer through `xxd`
    vim --remote-send ":argdo %!xxd<cr><cr>" --servername "$server"

  # if the 1st argument is `-d`, we want to compare files
  elif [[ $1 == -d ]]; then
    shift 1
    local IFS=' '
    # open a new tabpage
    vim --remote-send ":tabnew<cr>" --servername "$server"
    # send the files to the server
    vim --remote "$@" --servername "$server"
    # display the buffers of the arglist in a dedicated vertical split
    vim --remote-send ":argdo vsplit<cr>:q<cr>" --servername "$server"
    # execute `:diffthis` in each window
    vim --remote-send ":windo diffthis<cr>" --servername "$server"

  # if the 1st argument is `-o`, we want to open each file in a dedicated horizontal split
  elif [[ $1 == "-o" ]]; then
    shift 1
    local IFS=' '

    vim --remote-send ":split<cr>" --servername "$server"
    vim --remote "$@" --servername "$server"
    # Why `:q<cr>`?{{{
    #
    # To close the last window, because the last file is displayed twice, in 2
    # windows.
    #}}}
    vim --remote-send ":argdo split<cr>:q<cr><cr>" --servername "$server"

  # if the 1st argument is `-O`, we want to open each file in a dedicated vertical split
  elif [[ $1 == -O ]]; then
    shift 1
    local IFS=' '
    vim --remote-send ":vsplit<cr>" --servername "$server"
    vim --remote "$@" --servername "$server"
    vim --remote-send ":argdo vsplit<cr>:q<cr><cr>" --servername "$server"

  # if the 1st argument is `-p`, we want to open each file in a dedicated tab page
  elif [[ $1 == -p ]]; then
    shift 1
    local IFS=' '
    vim --remote-send ":tabnew<cr>" --servername "$server"
    vim --remote "$@" --servername "$server"
    vim --remote-send ":argdo tabedit<cr>:q<cr>" --servername "$server"

  # if the 1st argument is `-q`, we want to populate the qfl with the output of a shell command
  elif [[ $1 == -q ]]; then
    shift 1
    local IFS=' '

    # Why don't you just send the shell command to Vim, and make it execute via `:cexpr system()`?{{{
    #
    # It makes the code needlessly more complex:
    #
    #    - it causes Vim to start yet another shell (via `system()`)
    #
    #    - `system()`'s shell shell is run in Vim's cwd, instead of your original shell's cwd;
    #      if they're different, you may get unexpected results
    #}}}
    tmp="$(mktemp /tmp/.vim_quickfix.XXXXXXXXXX)"
    # let's write the command into the errorfile so that we can set the title of the qf window
    printf -- "$@\n" >"$tmp"
    # `${=name}` and `${~name}` to perform resp. word-splitting and globbing
    ${~${=@}} >>"$tmp" 2>/dev/null
    vim --remote-expr "qf#nv('$tmp')" --servername "$server"

  # if no option was used (`-[bdoOpq]`) we just want to send files to the server
  else
    vim --remote "$@" --servername "$server"
  fi

  # focus the Vim server
  if [[ -n "$TMUX" ]]; then
    tmux switchc -Z -t "$pane_id"
    # need to redraw if the tmux pane is zoomed
    vim --remote-send '<c-l>'
  fi
}

restarting_vim=
# Don't restart Vim directly from a trap!{{{
#
# If  you restart  Vim, then  suspend it,  you  won't be  able to  resume it  by
# executing `fg`.
#
#     # minimal zshrc
#     # shell function to start Vim in a custom way
#     nv() {
#       vim -Nu NONE
#     }
#     # trap to restart Vim
#     trap __catch_signal_usr1 USR1
#     __catch_signal_usr1() {
#       trap __catch_signal_usr1 USR1
#       clear
#       nv
#     }
#
#     # start Vim
#     $ nv
#     # restart Vim
#     :call system('kill -USR1 $(ps -p '..getpid()..' -o ppid=)')
#     :q
#     # suspend Vim
#     :stop
#     # bring back Vim
#     $ fg
#     fg: no current job~
#     ^^^^^^^^^^^^^^^^^^
#     don't understand; zsh seems to have lost the job
#
# Probably a zsh bug: https://unix.stackexchange.com/a/445192/289772
#}}}
# set a trap for when we send the signal `USR1` from our Vim mapping `SPC R`
trap __catch_signal_usr1 USR1
__catch_signal_usr1() {
  # reset a trap for next time
  trap __catch_signal_usr1 USR1
  # useful to get rid of error messages which were displayed during last Vim session
  clear
  restarting_vim=1
}

__restart_vim() {
  emulate -L zsh
  if [[ -n "$restarting_vim" ]]; then
    restarting_vim=
    nv
    # simulate a keypress on Enter
    # Why?{{{
    #
    # To make Vim restart  the second time we press `SPC R`  (and the third one,
    # fourth one, ...).
    #
    # Indeed, Vim is restarted the first time, but *not* the next times.
    # Not sure why.
    #
    # In any case, any executed command (even  an empty one) causes a new prompt
    # to be  displayed, precmd  functions to  be executed again,  and Vim  to be
    # finally restarted.
    #
    # ---
    #
    # The issue is not with the trap, nor  with the flag, because if we add some
    # command  after  `nv`  (ex:  `echo  'hello'`),  the  message  is  correctly
    # displayed even when Vim is not restarted, which means that this `if` block
    # is always correctly processed.
    #
    # Replacing `nv` with `vim` doesn't fix the issue.
    #}}}
    #   Is there an alternative?{{{
    #
    # You could  try to automatically suspend  Vim then `fg` it  back after each
    # restart; it works but it's ugly though...
    #}}}
    xdotool key KP_Enter
  fi
}

add-zsh-hook -Uz precmd __restart_vim

palette(){ #{{{2
  emulate -L zsh

  local i
  for i in {0..255} ; do
    printf -- '\e[48;5;%dm%3d\e[0m ' "$i" "$i"
    if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
      printf -- '\n'
    fi
  done
}

pdf_merge() { #{{{2
  emulate -L zsh
  if [[ $# -lt 2 ]]; then
    cat <<EOF >&2
  usage: $0 <output file> <input files>
  example: $0 output.pdf *.pdf
EOF
    return 64
  fi

  output_file="$1"
  shift 1

  # https://stackoverflow.com/a/19358402/9780968
  # TODO: Make it preserve hyperlinks.{{{
  #
  # For some people, the output pdf preserves the hyperlinks.
  # https://stackoverflow.com/questions/2507766/merge-convert-multiple-pdf-files-into-one-pdf/19358402#comment94073595_19358402
  #
  # Not for me.
  #}}}
  gs \
     -sDEVICE=pdfwrite \
     -dCompatibilityLevel=1.4 \
     -dPDFSETTINGS=/default \
     -dNOPAUSE \
     -dQUIET \
     -dBATCH \
     -dDetectDuplicateImages \
     -dCompressFonts=true \
     -r150 \
     -sOutputFile="$output_file" \
     $@
}
#}}}2

ppa_what_can_i_install() { #{{{2
  emulate -L zsh
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
usage:
    $0 /var/lib/apt/lists/fr.archive.ubuntu.com_ubuntu_dists_xenial_universe_binary-amd64_Packages
    $0 <Tab>
EOF
    return 64
  fi
  awk '$1 == "Package:" { if (a[$2]++ == 0) print $2 }' "$1"
}

ppa_what_have_i_installed() { #{{{2
  emulate -L zsh
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
usage:
    $0 /var/lib/apt/lists/fr.archive.ubuntu.com_ubuntu_dists_xenial_universe_binary-amd64_Packages
    $0 <Tab>
EOF
    return 64
  fi
  packages="$(awk '$1 == "Package:" { if (a[$2]++ == 0) print $2 }' "$1")"
  cat <<EOF
  The following packages are currently installed on your machine,
  and they can be installed from the PPA you provided.
  So, there's a good chance for them to have been installed from this PPA.
  However, they could also have been installed from somewhere else
  (e.g. your default repositories).
  To be sure, for each of them, execute this command:

      $ apt-cache policy <package>

EOF
  for package in ${=packages}; do
    if ! dpkg-query -W -f='${status}\n' "${package}" |& grep -E 'not-installed|deinstall|no packages found' >/dev/null 2>&1; then
    #                │  │{{{
    #                │  └ -f='<format>'
    #                │      You can select one or several fields, and format them
    #                │      however you want.
    #                │      For the full list of fields, see:
    #                │
    #                │         `man dpkg-query`
    #                │         > OPTIONS
    #                │         > /-f\>
    #                │
    #                └ -W [package-name-pattern...]
    #                      List all packages matching the given pattern.
    #                      The output can be  customized using the `-f` option.
    #                      `-W` is the long form of `--show`
    #                                                  ^}}}
      printf -- "${package}\n"
    fi
  done
}
#}}}2

# script variables {{{2
#
# No need to export  these variables, since you set them every  time you start a
# shell.
script_record_dest='/tmp/.script_record.log'
script_timing_dest='/tmp/.script_timing.log'
#}}}2
script_record() { #{{{2
  emulate -L zsh
  if [[ "$#" -eq 0 ]]; then
    # record interactive session
    script -q --timing=$script_timing_dest $script_record_dest
  else
    # record a specific (set of) command(s)
    script -q --timing=$script_timing_dest -c "$1" $script_record_dest
  fi
}

script_replay() { #{{{2
  emulate -L zsh
  if [[ ! -f $script_record_dest ]]; then
    cat <<EOF >&2
usage:

first invoke:
  \`script_record\` to record an interactive shell session
OR
  \`script_record 'cmd'\` to record a specific command

EOF
    return 64
  fi
  scriptreplay -s $script_record_dest -t $script_timing_dest
}
#}}}2

shellcheck_wiki() { #{{{2
  emulate -L zsh
  # Purpose: Get more information about an error found by shellcheck.
  xdg-open "https://github.com/koalaman/shellcheck/wiki/SC$1"
}

stream() { #{{{2
  emulate -L zsh
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
usage:    $0  <video url>
EOF
    return 64
  fi

  # watch a video stream with the local video player:
  #
  #     $ youtube-dl [-f best] 'url' ST
  youtube-dl "$1" -o -| mpv --cache=4096 -
  #                           │
  #                           └ sets the size of the cache to 4096kB
  #
  # Why is a cache important?{{{
  #
  # May be useful
  # When playing files from slow media, it's necessary, but  can also have negative
  # effects, especially  with file formats  that require a  lot of seeking,  such as
  # MP4.
  #}}}
  # Is there a downside to using a cache?{{{
  #
  # Yes.
  #}}}
  # Why giving the value '4096'?{{{
  #
  # The default value of the 'cache' option is 'auto', which means that `mpv` will
  # decide depending on the media whether it must cache data.
  # Also,  `--cache=auto` implies  that  the size  of  the cache  will  be set  by
  # '--cache-default', whose default value is '75000kB'.
  # It's too much according to this:
  #
  #     https://streamlink.github.io/issues.html#issues-player-caching
  #
  # They recommend using between '1024' and '8192', so we take the middle value.

  # Note that half the cache size will be used to allow fast seeking back.
  # This is also the reason why a full cache is usually not reported as 100% full.
  # The cache  fill display  does not  include the  part of  the cache  reserved for
  # seeking back.
  # The actual  maximum percentage will usually  be the ratio between  readahead and
  # backbuffer sizes.
  #}}}
}

tor() { #{{{2
  emulate -L zsh
  # Why `cd ...`?  Why not running the desktop file with an absolute path?{{{
  #
  # Here's the shebang of the `.desktop` file:
  #
  #     #!/usr/bin/env ./Browser/execdesktop
  #
  # It will run a script with a relative path.
  # So the current  directory matters; it must be where  we've installed the Tor
  # browser.
  #}}}
  # If you want to add the tor browser to the application menu, run:{{{
  #
  #     $ cd ~/.local/bin/tor-browser_en-US/
  #     $ ./start-tor-browser.desktop --register-app
  #}}}
  cd "$HOME/.local/bin/tor-browser_en-US/"
  ./start-tor-browser.desktop
  cd - >/dev/null
}

truecolor() { #{{{2
  emulate -L zsh
  # How to interpret the output?{{{
  #
  # You should see either
  #
  #    - cells randomly|non- colored,
  #      (the terminal doesn't support true color)
  #
  #    - colors from red to blue, with a *non*-smooth gradient
  #      (the terminal partially supports true color)
  #
  #    - colors from red to blue, with a smooth gradient
  #      (the terminal fully supports true color)
  #}}}

  local i r g b

  # What's `r`, `g` and `b`?{{{
  #
  # The quantities of red (r), green (g) and blue (b) for each color we're going to test.}}}
  # How do we make them evolve?{{{
  #
  # To produce a specrum of colors,  they need to evolve in completely different
  # ways.  So, we make:
  #
  #    - `r` decrease from 255  (to make the specrum begin from very red)
  #                 to     0  (to get most shades of red)
  #
  #    - `b` increase from   0
  #                 to   255
  #
  #    - `g`    increase from 0   to 255  (but faster than blue so that we produce more various colors)
  #      then decrease from 255 to 0    (via `if (g > 255) g = 2*255 - g;`)
  #
  # Summary:
  #
  #     r:  255 → 0
  #     g:  0   → 255 → 0
  #     b:  0   → 255
  #}}}
  # Why 79?{{{
  #
  # By default terminals have 80 columns.
  #}}}
  for ((i = 0; i <= 79; i++)); do
    b=$((i*255/79))
    g=$((2*b))
    r=$((255-b))
    if [[ $g -gt 255 ]]; then
      g=$((2*255 - g))
    fi
    printf -- '\e[48;2;%d;%d;%dm \e[0m' "$r" "$g" "$b"
  done
  printf -- '\n'
}

var_what_have_you() { #{{{2
  emulate -L zsh
  # Purpose:{{{
  #
  # Useful to check the contents of a value of an environment variable:
  #
  #     var_what_have_you $IFS
  #
  # The number which is displayed in the lower right corner seems to be a weight
  # in bytes.
  #}}}
  var="$1"
  printf -- '%s' "${var}" | od -t c
  #                         ├┘ ├┘ │{{{
  #                         │  │  └ format = printable character or backslash escape
  #                         │  └ select output format
  #                         └ dump stdin in another format
  #}}}
}
#}}}2

vim_fix_vimrc() { #{{{2
  emulate -L zsh
  # Purpose:{{{
  #
  # Sometimes, you write something in your  vimrc which causes an issue, and you
  # can't start  Vim with your  config anymore (e.g.  an autocmd which  is fired
  # very often and runs a buggy command).
  #
  # When that happens, you need to edit your vimrc with no config:
  #
  #     $ vim -Nu NONE
  #
  # But  doing so  will make  you lose  the undo  history (unless  the vimrc  is
  # currently loaded in your Vim session).
  # To avoid this, you need to set `'undofile'` and `'undodir'` appropriately.
  #}}}
  vim -Nu NONE --cmd 'set udf udir=$HOME/.vim/tmp/undo' "${HOME}/.vim/vimrc"
}

vim_prof() { #{{{2
  emulate -L zsh
  local tmp
  tmp="$(mktemp /tmp/.vim_profile.XXXXXXXXXX)"
  vim --cmd "prof start ${tmp}" --cmd 'prof! file ~/.vim/vimrc' -cq
  vim "${tmp}" -c 'syn off' -c 'norm +tiE' -c 'update'
}

vim_read_plugin_help() { #{{{2
  emulate -L zsh
  # Purpose:{{{
  #
  # Read the help of a plugin which you don't want to install yet.
  #}}}
  # Usage example:{{{
  #
  #     $ git clone https://github.com/AndrewRadev/splitjoin.vim
  #     $ cd splitjoin.vim
  #     $ vim_read_plugin_help
  #     :h splitjoin
  #}}}
  vim +"set rtp+=$PWD|sil! helpt ALL"
}

vim_recover() { #{{{2
  emulate -L zsh
  local file
  file="$(basename "$1")"
  # recover swapfile
  vim -r "$1" +"w /tmp/.${file}.recovered | e! | diffsp /tmp/.${file}.recovered"
  # If the recovered version of the file looks good, you still have to do this:
  #
  #     $ mv recovered_file original_file
}

vim_startup() { #{{{2
  emulate -L zsh
  local tmp
  tmp="$(mktemp /tmp/.vim_startup.XXXXXXXXXX)"
  vim --startuptime "$tmp" \
      +'q' startup_vim_file \
      && vim +'setl bt=nofile nobl bh=wipe noswf | set ft=' \
      +'sil 7,$!sort -rnk2' \
      "$tmp"
}
#}}}2

whichcomp() { #{{{2
  emulate -L zsh
  # Ask zsh where a particular completion is being sourced from.
  # Where did you find the code?{{{
  #
  # Go to the irc channel `#zsh` and run the command `!whichcomp`.
  # A bot will print the code.
  #}}}
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
  usage: $0 <command name>
  example: $0 ls
EOF
    return 64
  fi
  # TODO: Document how the code works.
  for 1; do
    (print -raC 2 -- $^fpath/${_comps[$1]:?unknown command}(NP*$1*))
  done
}

xev_terse() { #{{{2
  emulate -L zsh
  # Purpose:{{{
  #
  # Filter  the output  of  `xev` so  that it  contains  only information  about
  # KeyPress events, and not about the other ones (like KeyRelease).
  #}}}
  xev | sed -n '/^KeyPress/,/^$/p'
  #             ├───────────────┘
  #             └ print every line between a line beginning with `KeyPress` and an empty line
}

xev_terse_terse() { #{{{2
  emulate -L zsh
  # Purpose:{{{
  #
  # Filter the  output of  `xev` so that  it contains only  the keycode  and the
  # keysym of the pressed keys.
  #}}}
  # What does `-A2` do?{{{
  #
  # The keycode and the keysym of a pressed key are printed 2 lines below
  # the line matching `^KeyPress`.
  # So, we ask `grep` to print 2 lines of trailing context after a line matching
  # `^KeyPress`.
  #
  # Mnemonics: `-A` for After
  #}}}
  # What does `--line-buffered` do?{{{
  #
  # When the output of grep is connected to a pipe, it's buffered into a 4K block.
  # That is, `grep` doesn't write anything on the pipe, until it has filled a 4K
  # buffer.
  # Because of this,  when we press a  key, `sed` doesn't receive  the output of
  # grep immediately.
  # We have to press several keys (22?) before `sed` prints something.
  # This is confusing.
  # We want `sed` to print something as soon as we press a key.
  # `--line-buffered` asks `grep` to limit the size of its buffer to a single line.
  # IOW, as soon as it has a line, it writes it to the pipe.
  #}}}
  # Is there an alternative to `--line-buffered`?{{{
  #
  # Yes, you can use the `stdbuf` command, included in the coreutils package:
  #
  #     xev |
  #     stdbuf -oL grep -A2 '^KeyPress' |
  #     sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'
  #
  # Here, we use `stdbuf`  to execute `grep` and limit the  size of its internal
  # buffer to a single line, by passing the option `-oL`.
  # `-o` = `--output`, and `L` = line.
  #
  # For more info about `stdbuf`:
  #     https://unix.stackexchange.com/a/25378/289772
  #}}}
  # Source: https://wiki.xfce.org/faq
  xev |
  grep -A2 --line-buffered '^KeyPress' |
  sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'
  #       ├─────────┘            ├────────┘   │    ├────┘{{{
  #       │                      │            │    └ capture the keysym (backref `\2`)
  #       │                      │            │
  #       │                      │            └ this is not a capturing group
  #       │                      │              this is a literal opening parenthesis
  #       │                      │
  #       │                      └ capture the keycode
  #       │                        so that we can refer to it later with the backref `\1`
  #       │
  #       └ operate a substitution on any line matching `keycode `
  #}}}
}
#}}}2

xt() { #{{{2
  # Purpose:{{{
  #
  # Extract an archive using the `atool` command.
  # Then, cd into the directory where the contents of the archive was extracted.
  # The code is taken from `:Man atool`.
  #}}}
  emulate -L zsh

  local tmp
  tmp="$(mktemp /tmp/xt.XXXXXXXXXX)"
  #      │                  │
  #      │                  └ template for the filename, the `X` will be
  #      │                    randomly replaced with characters matched
  #      │                    by the regex `[0-9a-zA-Z]`
  #      │
  #      └ create a temporary file and store its path into `tmp`

  atool -x --save-outdir="${tmp}" "$@"
  #          │
  #          └ write the name of the folder in which the files have been
  #            extracted inside the temporary file

  # Assign the name of the extraction folder inside to the variable `dir`.
  local dir
  dir="$(cat "${tmp}")"
  [[ -d "${dir}" && "${dir}" != "" ]] && cd "${dir}"
  #  ├─────────┘    ├────────────┘       ├─────────┘
  #  │              │                    │
  #  │              │                    └ enter it
  #  │              │
  #  │              └ and if its name is not empty
  #  │
  #  └ if the directory `dir` exists

  # Delete temporary file.
  rm "${tmp}"
}

zsh_sourced_files() { #{{{2
  emulate -L zsh
  local logfile='zsh_log'
  script -c 'zsh -o SOURCE_TRACE' "$logfile"
  # FIXME: How to exit the subshell started by `script(1)`?{{{
  #
  # If I execute `exit` here, not only  will the subshell be terminated, but the
  # current function too.
  #}}}
  sed -i '/^+/!d' "$logfile"
  "$EDITOR" "$logfile"
}
#}}}2

_fzf_compgen_dir() { #{{{2
  emulate -L zsh
  # Use `fd`  instead of  the default  `find` command to  generate the  list for
  # directory completion.
  #    - `$1` is the base path to start traversal
  #    - see `~/.fzf/shell/completion.zsh` for the details
  fd --hidden --follow --type d . "$1"
}

_fzf_compgen_path() { #{{{2
  emulate -L zsh
  # Use `fd` instead of the default `find` command for listing path candidates.
  fd --hidden --follow . "$1"
}
# }}}1
# Aliases {{{1
#   Do *not* install global aliases!{{{
#
# They are dangerous.
# It's  too   easy  to  accidentally   use  them  without  realizing   it,  with
# unpredictable consequences.
# In  the past, we've often  seen zsh run  commands we didn't expect  because of
# global aliases.
#
# Besides, not seeing what is run can be misleading, and sometimes also prevents
# us  from memorizing  the  expanded command,  which could  be  useful in  other
# contexts.
#
# Use abbreviations instead.
#}}}
#   *Always* backslash a command whose name is also used as an alias name.{{{
#
# Otherwise,  when you  expand  the  alias, you  may  have  an undesired  double
# expansion.
#
#     alias foo='echo foo'
#     alias bar='echo bar; foo'
#
#     $ echo bar
#     M-e
#     $ echo bar; echo foo~
#                 ^^^^^^^^
#
#     alias foo='echo foo'
#     alias bar='echo bar; \foo'
#                          ^
#
#     $ echo bar
#     M-e
#     $ echo bar; foo~
#                 ^^^
#}}}

# TODO: Invoke `less(1)` whenever the output of a command doesn't fit on a single screen.{{{
#
# Take the habit  of invoking `less(1)`, every time you  write an alias/function
# whose goal is  to print some info which  can be very long, and  require you to
# scroll back with tmux copy mode.
#
# Example:
#
#     ✘
#     alias pss='\ps xfo pid,tty=TTY,stat=STATE,args'
#     ✔
#     alias pss='\ps xfo pid,tty=TTY,stat=STATE,args | less'
#                                                    ^^^^^^
#}}}

# TODO: regular aliases seem really shitty.  Convert as many of them as possible into functions.

# regular {{{2
# apt {{{3

alias api='\sudo aptitude install'
alias app='\sudo aptitude purge'
alias aps='aptitude show'

alias afs='apt-file search'

# awk {{{3

alias rawk='rlwrap awk'

# bc {{{3

alias bc='\bc -q -l'
#              │  │
#              │  └ load standard math library (to get more accuracy, and some functions)
#              │
#              └ do not print the welcome message

# cd {{{3

alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'

# config {{{3

# FIXME: `config_push` is highlighted in red.{{{
#
# Here is what *I think* is a MWE:
#
#     alias e='echo'
#     alias ee='e one; e two'
#
# ---
#
# Same issue with the `fm` and `sh` aliases.
#
# ---
#
# Also, it seems the zsh syntax highlighting plugin doesn't like you to override
# any default command with an alias.
#
#     alias bash='foobar'
#}}}

# TODO: add file completion to `config`

# Usage:{{{
#
#     $ config status
#     $ config add /path/to/file
#     $ config commit -m 'my message'
#     $ config push
#}}}
alias config='/usr/bin/git --git-dir="${HOME}/.cfg/" --work-tree="${HOME}"'
alias config_push='config add -u && config commit -m "update" && config push'
#                             ├┘{{{
#                             └ All tracked files in the entire working tree are updated.
#
# This removes as well as modifies index  entries to match the working tree, but
# adds no new files.
# It's easier and more reliable to use `-u`, than to manually add every modified
# file, and remove every deleted file:
#
#     $ git add -u
#   ⇔
#     $ git add file1 ... && git rm file2 ...
#}}}

# df {{{3

# I want colors too!{{{
#
# Use `dfc(1)`.
#}}}
alias df='\df -h -x tmpfs -T'
#              │  ├─────┘  │{{{
#              │  │        └ print filesystem type (e.g. ext4)
#              │  └ exclude filesystems of type devtmpfs
#              └ human-readable sizes
#}}}

# dirs {{{3

alias dirs='\dirs -v'

# dl {{{3

# Do *not* remove `--restrict-filenames`!{{{
#
# If the filename contains spaces, we  want them to be replaced with underscores
# automatically.
# Otherwise, when  you read  a file  containing spaces  with `mpv(1)`,  it's not
# logged by  fasd (unless you  quote it,  but we always  forget to quote  such a
# file).
#}}}
alias dl_mp3='youtube-dl --restrict-filenames -x --audio-format mp3 -o "%(title)s.%(ext)s"'
alias dl_pl='youtube-dl --restrict-filenames --write-sub --sub-lang en,fr --write-auto-sub -o "%(autonumber)02d - %(title)s.%(ext)s"'

alias dl_sub_en='subliminal download -l en'
alias dl_sub_fr='subliminal download -l fr'

alias dl_video='youtube-dl --restrict-filenames --write-sub --sub-lang en,fr --write-auto-sub -o "%(title)s.%(ext)s"'

# free {{{3

alias free='\free -mt'
#                  ││
#                  │└ display a line showing the column totals
#                  └ display the amount of memory in megabytes (easier to read)

# gdb {{{3

# Don't print the introductory and copyright messages.
# Could I set this in `~/.gdbinit`?{{{
#
# It seems that no, you can't:
# https://stackoverflow.com/a/34201975/9780968
#}}}
alias gdb='\gdb -q'

# git {{{3

alias g='git'

# grep {{{3

alias grep='\grep --color=auto'

# grml {{{3

alias grml='vim =(curl -Ls https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc)'

# iconv {{{3

# What's `iconv`?{{{
#
# A utility to convert a text from one encoding (-f ...) to another (-t ...).
#}}}
# What's `ascii//TRANSLIT`?{{{
#
# An encoding similar to `ascii`.
# The difference is that characters are transliterated when needed and possible.
#
# This means that when a character cannot be represented in the target character
# set, it should be approximated through one or several similar looking characters.
# Characters that cannot be transliterated are replaced with a question mark (?).
#}}}
alias iconv_no_accent='iconv -f utf8 -t ascii//TRANSLIT'

# info {{{3

# `--vi-keys` = use vi-like and less-like key bindings.
# `--init-file` = Read key bindings and variable settings from INIT-FILE
# instead of the .infokey file in your home directory.
# https://www.gnu.org/software/texinfo/manual/info-stnd/html_node/Invoking-Info.html#g_t_002d_002dinit_002dfile
alias info='\info --vi-keys --init-file=~/.config/infokey'

# iotop {{{3

# `iotop` monitors which process(es) access our disk to read/write it:
alias iotop='\iotop -o -P'
#                    │  │
#                    │  └ no threads
#                    │
#                    └ only active processes

# jobs {{{3

alias jobs='\jobs -l'
#                  │
#                  └ print the pids

# lessh {{{3

# We can have syntax highlighting in the less pager:{{{
#
#     $ sudo aptitude install source-highlight
#     $ cp /usr/share/source-highlight/src-hilite-lesspipe.sh ~/bin/src-hilite-lesspipe
#     $ alias lessh='LESSOPEN="| ~/bin/src-hilite-lesspipe %s" less'
#     $ lessh ~/Vcs/ranger/ranger.py
#
# Source: https://unix.stackexchange.com/a/139787/289772
#}}}
alias lessh='LESSOPEN="| ~/bin/src-hilite-lesspipe %s" less'

# ls {{{3

alias ls='\ls --color=auto'
alias l=ls++

# lua {{{3

alias lua='lua5.3'

# man_ascii {{{3

#                                 ┌ print 20 lines of trailing context,{{{
#                                 │ i.e. the 20 lines following the line where 'Tables' was matched
#                                 ├───┐}}}
alias man_ascii='man ascii | grep -A 20 Tables'
alias man_ascii_long='man ascii | grep -A 67 Oct | less'

# mpv {{{3

# watch a video in a virtual console
alias mpv_console='mpv -vo drm'

# start `mpv` in “keybindings testing mode”
alias mpv_test_keybinding='mpv --input-test --force-window --idle'
#                                │            │              │{{{
#                                │            │              └ don't quit immediately,
#                                │            │                even though there's no file to play
#                                │            │
#                                │            └ create a video output window even if there is no video
#                                │
#                                └ when I press a key, don't execute the bound command,
#                                instead, display the name of the key on the OSD;
#                                useful when you're crafting a key binding
#}}}

# nb {{{3

# Warning:{{{
#
# This alias shadows the `nb` binary installed by the `nanoblogger` package.
#}}}
alias nb='newsboat -q'

# nethogs {{{3

# `nethogs` is a utility showing  which processes are consuming bandwidth on our
# network interface.
alias net_watch='nethogs enp3s0'

# ps {{{3

# display only our processes, and with a minimum of noise
alias pss='\ps xfo pid,tty=TTY,stat=STATE,args | less'
# For some reason, the last character of the `TTY` and `STATE` column headers is
# omitted, so we set those two column headers explicitly.

# http://0pointer.de/blog/projects/systemd-for-admins-2.html
alias psc='\ps axfo pid,user,cgroup,args | less'

# qmv {{{3

alias qmv='\qmv --format=destination-only'
#                 │
#                 └ -f, --format=FORMAT
#
# Change edit format of text file.
# Available edit formats are:
#
#     `single-column`       (or `sc`)
#     `dual-column`         (or `dc`)
#     `destination-only`    (or `do`)
#
# The default format is dual-column.

# ranger {{{3

alias fm='[[ -n "${TMUX}" ]] && [[ $(\tmux display -p "#W") == "zsh" ]] && \tmux rename-window fm; ranger'

# sh {{{3

# Purpose:{{{
#
# We can't use readline key bindings when using sh/dash.
# When we need to test some command, it's annoying.
# This alias enables some readline-like key bindings.
#}}}
# Why don't you use the default `dash`? Why `$HOME/.local/bin/dash`?{{{
#
# The default one has not been  compiled with `--with-libedit`, so you can't use
# any editing key binding.
#}}}
#   Ok, how do I get this binary?{{{
#
#     $ git clone https://git.kernel.org/pub/scm/utils/dash/dash.git
#     $ cd dash
#     $ git checkout vX.Y.Z
#     $ ./autogen.sh
#     $ sudo aptitude install libedit-dev
#     $ ./configure --with-libedit
#     $ make
#     $ cp src/dash ~/.local/bin/
#}}}
#     Why don't you install it with checkinstall?{{{
#
# It will try to overwrite the default sh, and will fail.
# As a  result, sh will be  broken, which in  turn will break several  things on
# your system (e.g. your M-j and M-k  key bindings, and your ixquick search from
# Vim).
#
# You could try to  install it in a different directory,  but you would probably
# also need to change the name of the package (mydash ?).
# And even then, I'm concerned by a script whose shebang would be:
#
#     #!/usr/bin/env sh
#
# Does such a script exist on our system?
# If it does, what would happen? Would it use our custom sh, or the default one?
# If it uses our custom one, would it break?
# Too many questions, too much uncertainty.
#
# If you  nevertheless fuck up  sh, you'll need  to downgrade it  to the old  version, but
# `apt-get` will fail, presumably because it relies on a working sh.
# In that case, run:
#
#     $ sudo ln -s /bin/bash /bin/sh
#     $ sudo apt-get install dash=<old version given by `$ apt-cache policy`
#}}}
alias sh='$HOME/.local/bin/dash -E'
#                                │
#                                └ Enable the built-in emacs(1) command line editor

# sudo {{{3

# Why `-E`?{{{
#
# Suppose you run:
#
#     $ sudo vim /path/to/file/owned/by/root
#
# *Yeah, I know, we should use `sudoedit` instead, but in that case the cwd would be*
# *`/var/tmp` which would prevent us from visiting neighbor files with vim-dirvish*.
#
# Press `got` to make tmux split the window; instead, a new terminal will be opened.
# Indeed, our Vimscript  code will think we're outside tmux,  because `$TMUX` is
# empty (sudo probably resets it).
# Besides, the new shell will be started  as root, which is not necessarily what
# you want:
#
#     $ sudo zsh
#     zsh compinit: insecure directories and files, run compaudit for list.~
#     Ignore insecure directories and files and continue [y] or abort compinit [n]?~
#
# To fix this, we use this alias to always pass `-E` to sudo.
#}}}
# Why `env "PATH=$PATH"`?{{{
#
# Suppose your file  contains a vimscript function; you position  your cursor in
# it, and press `gl` to count how many lines it contains.
# Atm,   it   will   fail,   because  `cloc`   is   `/home/user/bin/cloc`,   and
# `/home/user/bin` is not in root's PATH.
# So, we need to tell sudo to also preserve PATH (`-E` doesn't preserve it).
#
# You may wonder why `-E` doesn't preserve PATH.
# It's because of the value given to `secure_path` in `/etc/sudoers`:
#
#     "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
#
# It overrides our PATH.
# This is confirmed by the fact that PATH  is one of the few variables listed at
# `man sudo /ENVIRONMENT`.
# Also, if you add `/home/user/bin` to `secure_path`, you don't need `env` anymore.
#}}}
#   Couldn't we just use `PATH=$PATH`?{{{
#
# It's  a special syntax  (usually variable  assignments are written  before the
# command name), but yes, sudo can be followed by `VAR=value`.
# From `man sudo /DESCRIPTION/;/VAR=value`:
#
# >     Environment variables to be set for the command may also be passed on the
# >     command line in the form of VAR=value, e.g.
# >     LD_LIBRARY_PATH=/usr/local/pkg/lib.  Variables passed on the command line
# >     are subject to restrictions imposed by the security policy plugin.
#}}}
#     So why don't you use it?  Why `env`?{{{
#
# `env` runs an arbitrary command in a modified environment.
# If we didn't use `env`:
#
#     $ sudo "PATH=$PATH" command
#
# Our PATH  would be copied into  the environment of `command`,  but sudo itself
# would not look into it to find `command`.
# This is an issue if `command` is not in `secure_path`.
# For example, suppose your `cloc` binary is in `/home/user/bin/cloc`:
#
#     $ \sudo "PATH=$PATH" cloc .
#     sudo: cloc: command not found~
#
#     $ \sudo env "PATH=$PATH" cloc .
#     434 text files.~
#     413 unique files.~
#     217 files ignored.~
#     ...~
#
# In  the  first command,  `PATH=$PATH`  is  meant to  copy  our  PATH into  the
# environment of `cloc`.
# But since `cloc` is not in `secure_path`, sudo fails to run it.
#
# In the second command, sudo doesn't run `cloc` directly; it runs `env`.
# And the latter runs in a modified environment in which it should find `cloc`.
# In  conclusion, sudo  finds  `env`  because it's  in  `/usr/bin`  which is  in
# `secure_path`, and `env` finds `cloc` because we reset its PATH with ours.
#
# Source: https://unix.stackexchange.com/a/83194/289772
#}}}
# Why the trailing space?{{{
#
#     $ sudo ls /root
#     ✘ the listing is not colored~
#
# The shell doesn't check  for an alias beyond the first word,  so it didn't use
# our `ls` alias (`ls` is only the second word, not the first).
# The solution is given at `man zshbuiltins /^\s*alias`:
#
# >     A trailing space in value causes the next word to be checked for alias expansion.
#}}}
alias sudo='\sudo -E env "PATH=$PATH" '
#                                    ^
# FIXME: This breaks `$ sudo -i`.
#
#     env: ‘-i’: No such file or directory

# systemd {{{3

alias sc='systemctl'
alias jc='journalctl'

# Purpose: print the status of all services.
# Mnemonic: SystemCtl List services
# Tip: If you want only the running services, expand the alias and remove `--all`.
alias scl='systemctl list-units --type service --all'

# tldr {{{3

# TODO: Replace this alias with a function invoking: `$ vim +"Tldr $1"`.
# Take inspiration from what we did with `cs`.
alias 'td=tldr'

# tlmgr_gui {{{3

alias tlmgr_gui='tlmgr gui -font "helvetica 20" -geometry=1920x1080-0+0 >/dev/null 2>&1 &!'
#                                                                                       ├┘
#                                                                                       └ ⇔ & disown

# top {{{3

alias top='htop'

# trash {{{3

alias te='trash-empty'

alias tl='trash-list'

alias tp='trash-put'

# TRash Restore
alias trr='rlwrap trash-restore'

# ubuntu-code-name {{{3

alias ubuntu-code-name='lsb_release -sc'
#                                    ││
#                                    │└ --codename
#                                    └ --short

# ubuntu-version {{{3

alias ubuntu-version='cat /etc/issue'

# vi {{{3

alias vi='vim -Nu NONE -S /tmp/t.vim'

# VirtualBox {{{3

alias vb='VBoxManage'

# Useful to access the settings of a VM, from the GUI, while it's shut down.
alias vb_start='virtualbox &!'

# website_cwd {{{3

# Usage:{{{
#
#     $ website_cwd
#
# In your browser, visit 0.0.0.0:8000, and you'll get access to all the files in
# your cwd.
# This is useful when  you create a website, and you need to  view how your html
# files are rendered, without having to manually open each of them with C-o.
#}}}
# Source:{{{
#
#     https://www.commandlinefu.com/commands/view/71/serve-current-directory-tree-at-httphostname8000#comment
#     https://www.commandlinefu.com/commands/view/7338/python-version-3-serve-current-directory-tree-at-httphostname8000
#}}}
alias website_cwd='{ python3 -m http.server >/dev/null 2>&1 & ;} && disown %'

# what_is_my_ip {{{3

alias what_is_my_ip='curl ifconfig.me'

# zsh_options {{{3

# To know how all options are currently set, you can simply run `set -o`.
# But this  alias gives  you extra info;  it tells you  which options  have been
# reset from their default value.
alias zsh_options='vim -O =(setopt) =(unsetopt) +"call myfuncs#zshoptions()"'

# zsh_sourcetrace {{{3

# get the list of files sourced by zsh
alias zsh_sourcetrace='zsh -o sourcetrace'
#                           ├────────────┘
#                           └ start a new zsh shell, enabling the 'sourcetrace' option
#                             see `man zshoptions` for a description of the option

# zsh_startup {{{3

alias zsh_startup='repeat 10 time zsh -i -c exit'
# }}}2
# suffix {{{2

# automatically open a file with the right program, according to its extension

alias -s {avi,flv,mkv,mp4,mpeg,mpg,ogv,wmv,flac,mp3,ogg,wav}=mpv
alias -s {avi.part,flv.part,mkv.part,mp4.part,mpeg.part,mpg.part,ogv.part,wmv.part,flac.part,mp3.part,ogg.part,wav.part}=mpv
alias -s {jpg,png}=feh
alias -s gif=ristretto
alias -s {epub,mobi}=zathura
alias -s {md,markdown,txt,html,css}=vim
alias -s odt=libreoffice
alias -s pdf="${PDFVIEWER}"
# }}}1
# Hooks {{{1

# What's a hook function?{{{
#
# A function which is run automatically at a specific point during shell execution.
#}}}
# How to list all of them?{{{
#
#     $ add-zsh-hook -L
#}}}

# What's this `chpwd_recent_dirs` function?{{{
#
# A hook function which logs the most recent directories you've visited into a file.
# The `cdr` function relies on this log to do its job.
#}}}
autoload -Uz chpwd_recent_dirs
# What's this `chpwd`?{{{
#
# A hook which is triggered whenever you change the shell's cwd interactively.
#}}}
add-zsh-hook -Uz chpwd chpwd_recent_dirs

# synchronize Vim's local cwd with the shell's one
if [[ -n "$VIM_TERMINAL" ]]; then
  add-zsh-hook -Uz chpwd _vim_lcd
  _vim_lcd() {
    # in Vim, see `:h terminal-api`
    printf -- '\033]51;["call", "Tapi_exe", "lcd %q"]\007' "$(pwd)"
  }
fi

# Exclude some commands from the history.{{{
#
# Solution: Use the `zshaddhistory` hook to exclude undesirable commands.
# Any function it runs is passed the command name as the first argument.
# For the command to be ignored, the function must return a non-zero value.
# More specifically, it must return either:
#
#    - `1` = the command is removed from  the history of the session, as soon as
#      you execute another command
#
#    - `2`  = the command  is still  in the history  of the session,  even after
#      executing another command, so you can retrieve it by pressing `M-p` or `C-p`
#
# Note: Contrary to bash, there's no `HISTIGNORE` option in zsh.
#}}}
add-zsh-hook -Uz zshaddhistory _ignore_comments
add-zsh-hook -Uz zshaddhistory _ignore_short_or_failed_cmds
add-zsh-hook -Uz zshaddhistory _ignore_these_cmds

_ignore_comments() {
  emulate -L zsh
  if [[ $1 =~ ^# ]]; then
    return 2
  else
    return 0
  fi
}

_ignore_short_or_failed_cmds() {
  emulate -L zsh
  # ignore commands which are shorter than 5 characters
  # Why `-le 6` instead of `-le 5`?{{{
  #
  # Because zsh sends a newline at the end of the command.
  #}}}
  #                            ┌ ignore non-recognized commands
  #                            ├─────────┐
  if [[ "${#1}" -le 6 ]] || [[ "$?" == 127 ]]; then
    return 2
  else
    return 0
  fi
}

_ignore_these_cmds() {
  emulate -L zsh
  local first_word
  # zsh passes the command line to this function via $1
  # we extract the first word on the line
  # Source: https://unix.stackexchange.com/a/273277/289772
  first_word=${${(z)1}[1]}
  # What's the effect of this `z` flag in the expansion of the `$1` parameter?{{{
  #
  # It splits the result of the expansion into words.
  #
  # Example:
  #
  #     $ sentence='Hello jane, how are you!'
  #
  #     $ printf -- '%s\n' ${sentence}
  #         Hello jane, how are you!
  #
  #     $ printf -- '%s\n' ${(z)sentence}
  #         Hello
  #         jane,
  #         how
  #         are
  #         you!
  #
  #     $ printf -- '%s\n' ${${(z)sentence}[2]}
  #         jane,
  #
  # For more info, see:
  #
  #     man zshexpn /PARAMETER EXPANSION/;/Parameter Expansion Flags
  #}}}

  # now we check whether it's somewhere in our array of commands to ignore
  # https://unix.stackexchange.com/a/411331/289772
  if ((${_cmds_to_ignore_in_history[(I)$first_word]})); then
    return 2
  else
    return 0
  fi
}

# The shell allows newlines to separate array elements.
# So,  an array  assignment can  be split  over multiple  lines without  putting
# backslashes on the end of the line.
_cmds_to_ignore_in_history=(
  api
  app
  aps
  bg
  cd
  clear
  config
  dl_video
  exit
  fg
  imv
  j
  jobs
  ls
  man
  mv
  reset
  rm
  rmdir
  sleep
  tldr
  touch
  tp
  vimdiff
  web
)

# Key Bindings {{{1
# How to bind a function to a key sequence using both the meta and control modifiers?{{{
#
# This is how you would do it for `M-C-z`:
#
#     bindkey '\e^z' your_function
#                 │
#                 └ replace 'z' with the key you want
#}}}
# How to set the position of the cursor in a key binding using the `-s` flag (`bindkey -s`)?{{{
#
# Write `\e123^B` at  the end of the rhs, to position  the cursor 123 characters
# before the end of the line.
#
# Example:
#
#     bindkey -s '^Xr' '^A^Kfor f in *; do echo mv \"$f\" \"${f}\";done\e7^B'
#}}}

# TODO: Should we prefix every built-in widget name with a dot?{{{
#
# From `man zshzle /\.'`:
#
# >     Each built-in widget has two names: its normal canonical name,
# >     and  the same name preceded by a '.'.  The '.' name is special:
# >     it can't be rebound to a different widget.  This makes the widget
# >     available even when its usual name has been redefined.
#
# Would it make our code more reliable?
#
# Look for the  pattern `zle\%( -N\)\@!` in this file,  and *consider* this kind
# of refactoring:
#
#     zle list-choices
#     →
#     zle .list-choices
#         ^
#}}}

# fzf {{{2
# How can I rebind the fzf widget to fuzzy search the history of commands:{{{
#
#     bindkey -r '^R'
#     bindkey 'your key' fzf-history-widget
#}}}

# The default key binding to jump in a child directory is `M-c`.
# Too hard to type; let's try `M-j` instead.
bindkey -r '\ec'
bindkey '\ej' fzf-cd-widget

# The default key binding to complete a file under the current directory is `C-t`.
# It overrides the shell `transpose-chars` function.
bindkey '^X^T' fzf-file-widget
bindkey '^T' transpose-chars

# Delete {{{2

# The delete key doesn't work in zsh.  Let's fix it.
# The sequence is hard-coded.  I don't like that, because it may not be portable across different environments.{{{
#
# If you want sth more portable, you could try this:
#
#     autoload zkbd
#     [[ ! -f "${HOME}/.zkbd/${TERM}" ]] && zkbd
#     . "${HOME}/.zkbd/${TERM}"
#     [[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
#
# This calls the zkbd utility – documented at `man zshcontrib /zkbd`.
#
# The first time the code  is run in a new terminal, it will  ask you to press a
# few keys.
#
# If you  can't find  one of the  key that  it asks, don't  worry; it  will just
# ignore this key in the next generated file.
# After that, it will generate the file `~/.zkbd/YOUR_TERM-:0.0`.
# Rename it in `~/.zkbd/YOUR_TERM`.
#
# The next times the code is run, it will simply source the generated file.
# You may then use `${key[Delete]}` to reference the Delete key in a bindkey command.
#
# Problem: How to reliably detect the identity of the terminal?
# In tmux, `$TERM` always contains `tmux-256color`.
# You could use `$COLORTERM`, but there's no guarantee it will work for any terminal.
# For example, gnome-terminal, st, and xterm do not set this variable.
#}}}
bindkey '\e[3~' delete-char

# The previous key binding is enough to fix the delete key in most terminals.
# But not in st.  For the latter, we also need this:
if [[ -n "${DISPLAY}" ]]; then
  zle-line-init() { echoti smkx }
  zle-line-finish() { echoti rmkx }
  zle -N zle-line-init
  zle -N zle-line-finish
fi
# What does it do?{{{
#
# It temporarily turns on the “application” mode.
#
# See:
# >     3.8: Why do the cursor (arrow) keys not work? (And other terminal oddities.)
# http://zsh.sourceforge.net/FAQ/zshfaq03.html
#}}}
#   What's that application mode?{{{
#
# The terminal is in “normal mode” when you are on the shell's command-line, and
# in “application mode” when you are in a TUI application such as Vim.
# Depending on the mode you're in, a function key (performing an action, and not
# associated to any glyph) sends a different escape sequence.
#
# The Vim's help and the terminfo documentation use another terminology.
# They   call   the  application   mode,   resp.   keypad  transmit   mode   and
# keyboard_transmit mode.
#
# For more info:
# http://invisible-island.net/xterm/xterm.faq.html#xterm_arrows
# http://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h2-PC-Style-Function-Keys
#
# See also:
#
#     man terminfo /smkx
#     :h t_ks
#}}}
#     When I inspect the escape sequence sent by a function key, it's the same in both modes!{{{
#
# It doesn't change because of our custom configuration.
# To see a difference:
#
#    - if you're in zsh, comment out the four previous lines
#    - if you're in bash, comment out the following line in `~/.inputrc`:
#
#         set enable-keypad on
#}}}

# Why the guard?{{{
#
# A virtual console has no `smkx` capability:
#
#     $ infocmp -1 linux | grep smkx
#     ''~
#
# So, the code would raise this error:
#
#     zle-line-init:echoti: no such terminfo capability: smkx~
#}}}

# Why do we need this for st, but not for the other terminals?{{{
#
# When  you press  the  delete key,  most  terminals  react as  if  you were  in
# application mode.   That is,  they emit  the string  stored in  the capability
# `kdch1` (Keyboard Delete 1 CHaracter).
#
#     $ infocmp -1x | grep kdch1
#     ... kdch1=\E[3~,~
#               ^^^^^
#
# I don't  know why  they do  that, because,  as I  understand it,  the terminal
# should not be in  application mode when you press the delete  key outside of a
# TUI application.
#
# Anyway, st is different.
# It  correctly emits `kdch1`  *iff* you're  in application mode;  otherwise, it
# emits `dch1`.
#
# ---
#
# Here's how you can check this.
# In urxvt:
#
#     $ cat
#     SUPPR
#     ^[[3~~
#     C-c
#
#     $ tput smkx
#     $ cat
#     SUPPR
#     ^[[3~~
#     C-c
#
#     $ tput rmkx
#
# In st:
#
#     $ cat
#     SUPPR
#     ^[[P~
#     C-c
#
#     $ tput smkx
#     $ cat
#     SUPPR
#     ^[[3~~
#     C-c
#
#     $ tput rmkx
#}}}
# What are these `zle-line-init()` and `zle-init-finish()` functions?{{{
#
# The first function is executed every time the line editor is started to read a
# new line of input.
# The  second function  is  executed every  time the  line  editor has  finished
# reading a new line of input.
#
# See `man zshzle /zle-line-init`
#}}}

# S-Tab {{{2

# use S-Tab to cycle backward during a completion
bindkey '\e[Z' reverse-menu-complete
#        ├──┘
#        └ the shell doesn't seem to recognize the keysym "S-Tab"
#          but when we press "S-Tab", the terminal sends the sequence "Esc [ Z"
#          so we use it in the lhs of our key binding

# TODO: To document.
#
# Source: https://unix.stackexchange.com/a/32426/232487
#
# Idea: improve the function so that it opens the completion menu,
# this way we could cd into any directory (without `cd`, thanks to `AUTOCD`).
__reverse_menu_complete_or_list_files() {
  emulate -L zsh
  if [[ $#BUFFER == 0 ]]; then
    BUFFER="ls "
    CURSOR=3
    zle list-choices
    zle backward-kill-word
  else
    # FIXME: why doesn't `s-tab` cycle backward?{{{
    #
    # MWE:
    #
    #     autoload -Uz compinit
    #     compinit
    #     zstyle ':completion:*' menu select
    #     __reverse_menu_complete_or_list_files() {
    #       emulate -L zsh
    #       if [[ $#BUFFER == 0 ]]; then
    #         BUFFER="ls "
    #         CURSOR=3
    #         zle list-choices
    #         zle backward-kill-word
    #       else
    #         zle reverse-menu-complete
    #       fi
    #     }
    #     zle -N __reverse_menu_complete_or_list_files
    #     bindkey '\e[Z' __reverse_menu_complete_or_list_files
    #
    # If I replace `reverse-menu-complete` with `backward-kill-word`,
    # `zle` deletes the previous word as expected, so why doesn't
    # `reverse-menu-complete` work as expected?
    #
    # It  seems that  `reverse-menu-complete` is  unable to  detect that  a menu
    # completion is opened.  Therefore, it  simply tries to *complete* the entry
    # selected in the menu, instead of cycling backward.
    #}}}
    zle reverse-menu-complete
  fi
}

# bind `__reverse_menu_complete_or_list_files` to s-tab
# Why is it commented?{{{
#
# Currently,  this key  binding breaks  the behavior  of `s-tab`  when we  cycle
# through the candidates of a completion menu.  See the previous fix_me.
#}}}
#     zle -N __reverse_menu_complete_or_list_files
#     bindkey '\e[Z' __reverse_menu_complete_or_list_files

# Ctrl {{{2
# C-SPC      set-mark-command {{{3

bindkey '^ ' set-mark-command

# C-^        previous_directory {{{3
# cycle between current dir and old dir
__previous_directory() {
  emulate -L zsh
  # contrary to bash, zsh sets `$OLDPWD` immediately when we start a shell
  # so, no need to check it's not empty
  cd -
  # refresh the prompt so that it reflects the new working directory
  zle reset-prompt
}
zle -N __previous_directory
bindkey '^^' __previous_directory

# C-d        delete-char-or-list {{{3

# Purpose:{{{
#
# Don't  display all  possible shell  commands when  I press  `C-d` on  an empty
# command-line which only contains whitespace; just close the shell.
#
# Also, don't terminate the shell in a Vim popup terminal.
# It could lead to many issues; look for `IGNORE_EOF` in `~/.zshenv`.
#}}}
__delete-char-or-list() {
  # we're in a Vim terminal
  if [[ -n "$VIM_TERMINAL" ]]; then
    if [[ "$BUFFER" =~ '^\s*$' ]]; then
      :
    else
      zle delete-char-or-list
    fi
  # we're in a regular terminal
  elif [[ "$BUFFER" =~ '^\s+$' ]]; then
    exit
  else
    zle delete-char-or-list
  fi
}
zle -N __delete-char-or-list
bindkey '^D' __delete-char-or-list

# C-g        (prefix) {{{3

# To use `C-g` as a prefix, we need to remove the function to which it's bound by default.
# Otherwise, when  we press `C-g  C-<key>`, if we  aren't quick enough  to press
# `C-<key>`, zsh would simply cancel the command.
bindkey -r '^G'

# C-g C-g    snippets {{{4

# TODO: fully understand/comment the code

# Adapted From: https://github.com/liangguohuan/fzf-marker
# Itself Inspired By: https://github.com/pindexis/marker.git

# Usage:
# Press `C-g C-g` to choose a snippet if there's no `{{` on the cmdline.
# Press `C-g C-g` to jump to the first tabstop and remove its default value.
# Press `C-g  g` to  jump to the  first tabstop and  “reveal” its  default value
# (remove the `{{` and `}}`).
#
# ---
#
# We could replace our code with this program:
# https://github.com/denisidoro/navi
#
# It looks much more powerful, but there are a few things which annoy me.
# It seems we don't see the final command which is executed.
# Also: https://github.com/denisidoro/navi/issues/320
#
# Besides, the program is written in rust, so it's harder to tweak.
# I'm pretty sure most of its  interesting features could be re-implemented with
# fzf/zsh/awk.  Do it.

FZF_SNIPPET_COMMAND_COLOR='\x1b[38;5;33m'
FZF_SNIPPET_COMMENT_COLOR='\x1b[38;5;35m'

# snippet selection
_fzf_snippet_main_widget() {
  emulate -L zsh
  if grep -q '{{' <<<"$BUFFER"; then
    _fzf_snippet_placeholder
  else
    local selected
    if selected=$(cat ${HOME}/.config/zsh-snippets/*.txt |
      sed "/^$\|^§/d
           s/\(^[a-zA-Z0-9_-]\+\)\s/${FZF_SNIPPET_COMMAND_COLOR}\1\x1b[0m /
           s/\s*\(§\+\)\(.*\)/${FZF_SNIPPET_COMMENT_COLOR}  \1\2\x1b[0m/" |
      fzf --height=${FZF_TMUX_HEIGHT:-40%} --reverse --ansi -q "${LBUFFER}"); then
      LBUFFER=$(sed 's/\s*§.*//' <<<"${selected}")
    fi
    zle redisplay
  fi
}

_fzf_snippet_placeholder() {
  emulate -L zsh
  local strp pos placeholder
  # What's `+?`?{{{
  #
  # A non-greedy `+` quantifier.
  # It's the equivalent of `\{-}` in Vim.
  # We can  use it here thanks  to grep's `-P` option  which lets us use  a PCRE
  # regex.
  #}}}
  strp=$(grep -Z -P -b -o "\{\{.+?\}\}" <<<"$BUFFER")
  strp=$(head -1 <<<"$strp")
  pos=$(cut -d ":" -f1 <<<"$strp")
  placeholder=${strp#*:}
  if [[ -n "$1" ]]; then
    BUFFER=$(echo -E $BUFFER | sed 's/{{//; s/}}//')
    CURSOR=$((${pos} + ${#placeholder} - 4))
  else
    # What's `A`?{{{
    #
    # A variable storing the delimiter used in the next sed command.
    #}}}
    #   Which value do you assign it?{{{
    #
    # A literal ‘C-a’.
    #}}}
    #     Why this particular value?{{{
    #
    # We don't know what will be in the placeholder.
    # It will contain user data, i.e. whatever  we write in the placeholder of a
    # snippet.
    # If it contains a slash, then we can't use a slash for the delimiter.
    # `C-a` should never appear in a snippet, therefore we can safely use it here.
    #}}}
    # Why don't you use this simpler assignment `A="\001"`?{{{
    #
    # It wouldn't work.
    # The sequence of characters `\001` would not be translated into a literal ‘C-a’.
    #
    # MWE:
    #
    #     func() {
    #       A="\001"
    #       echo "s${A}bar${A}${A}" | od -t c
    #       sed "s${A}bar${A}${A}" <<<'foo bar baz'
    #     }
    #     $ func
    #     0000000   s   \   0   0   1   b   a   r   \   0   0   1   \   0   0   1~
    #     0000020  \n~
    #     0000021~
    #     foo bar baz~
    #
    #     func() {
    #       A="$(tr 'x' '\001' <<<'x')"
    #       echo "s${A}bar${A}${A}" | od -t c
    #       sed "s${A}bar${A}${A}" <<<'foo bar baz'
    #     }
    #     $ func
    #     0000000   s 001   b   a   r 001 001  \n~
    #     0000010~
    #     foo  baz~
    #}}}
    A="$(tr 'x' '\001' <<<'x')"
    # don't interpret a special character like `*` as a metacharacter in the next substitution;
    # we want the text in the placeholder to be parsed literally (like with `\V` in Vim)
    placeholder=$(sed 's/[$*.]/[&]/g' <<<"$placeholder")
    BUFFER=$(echo -E $BUFFER | sed "s${A}${placeholder}${A}${A}")
    CURSOR=pos
  fi
}

_fzf_snippet_placeholder_widget() { _fzf_snippet_placeholder "defval" }

zle -N _fzf_snippet_main_widget
zle -N _fzf_snippet_placeholder_widget
bindkey '^G^G' _fzf_snippet_main_widget
bindkey '^Gg' _fzf_snippet_placeholder_widget
# }}}3
# C-k        kill_line_or_region {{{3

__kill_line_or_region() {
  emulate -L zsh
  if (( $REGION_ACTIVE )); then
    zle kill-region
  else
    zle kill-line
  fi
}
zle -N __kill_line_or_region
bindkey '^K' __kill_line_or_region

# C-x C-k    kill-buffer {{{3

# We can already press `C-e C-u` to clear a command-line.  What's the point?{{{
#
# The command-line could contain several lines of code (e.g. heredoc).
# In that case, `C-e C-u` would only clear the current line, not the other ones.
#
# Also, we need `kill-buffer`  to be bound to some key so that  we can invoke it
# via tmux in `vim-tmux`.
#
# For more info, see `man zshzle /kill-buffer`.
#}}}
bindkey '^X^K' kill-buffer

# C-q        quote_word_or_region {{{3

# useful to quote a url which contains special characters
__quote_word_or_region() {
  emulate -L zsh
    if (( $REGION_ACTIVE )); then
      zle quote-region
    else
      # Alternative:{{{
      #
      #     RBUFFER+="'"
      #     zle vi-backward-blank-word
      #     LBUFFER+="'"
      #     zle vi-forward-blank-word
      #}}}
      zle set-mark-command
      zle vi-backward-blank-word
      zle quote-region
    fi
}
zle -N __quote_word_or_region
#    │
#    └ -N widget [ function ]
# Create a user-defined widget.  When the  new widget is invoked from within the
# editor, the specified shell function is called.
# If no function name is specified, it defaults to the same name as the widget.
bindkey '^Q' __quote_word_or_region

# C-u        backward-kill-line {{{3

# By default, C-u deletes the whole line (kill-whole-line).
# I prefer the behavior of readline which deletes only from the cursor till the
# beginning of the line.
bindkey '^U' backward-kill-line

# C-x        (prefix) {{{3

# NOTE: It  seems  we  can't  bind  anything to  `C-x  C-c`,  because  `C-c`  is
# interpreted as an interrupt signal sent  to kill the foreground process.  Even
# if hit after `C-x`.
#
# It's probably done  by the terminal driver.  Maybe we  could disable this with
# `stty` (the  output of  `stty -a` contains  `intr = ^C`),  but it  wouldn't be
# wise, because it's too important.
# We would need to find a way to disable it only after `C-x`.

# C-x C-?         __complete_debug {{{4

# What's the purpose of the `_complete_debug` widget?{{{
#
# It performs ordinary  completion, but captures in a temporary  file a trace of
# the shell commands executed by the completion system.
# Each completion attempt gets its own file.
# A command to view each of these files is pushed onto the editor buffer stack.
#}}}
# Why do you create a wrapper around the default widget `_complete_debug`?{{{
#
# After invoking the `_complete_debug` widget, you'll see sth like:
#
#     Trace output left in /tmp/zsh6028echo1 (up-history to view)
#                                             ^^^^^^^^^^^^^^^^^^
# If you invoke  `up-history` (for us `C-p`  is bound to sth  similar because of
# `bindkey  -e`), in  theory zsh  should populate  the command  line with  a vim
# command to read the trace file.
# In practice, it won't happen because you've enabled 'MENU_COMPLETE'.
# Because of this, after pressing Tab, you've already entered the menu,
# and `C-p` will simply select the above match in the menu.
#
# MWE:
#
#     autoload -Uz compinit
#     compinit
#     setopt MENU_COMPLETE
#     bindkey '^X?' _complete_debug
#     bindkey '^P' up-history
#
# So, to conveniently read the trace  file, we make sure that 'MENU_COMPLETE' is
# temporarily reset.
#}}}
__complete_debug() {
  emulate -L zsh
  unsetopt MENU_COMPLETE
  zle _complete_debug
  # no need to restore the option, the change is local to the function
  # thanks to `emulate -L zsh`
}
zle -N __complete_debug
bindkey '^X?' __complete_debug

# C-x C-d         end-of-list {{{4

# Purpose:{{{
#
# `end-of-list` lets you make a list of matches persistent.
#
#     $ echo $HO C-d
#         → parameter
#           HOME  HOST    # this list may be erased if you repress C-d later
#
#     $ echo $HO C-x C-d D
#         → parameter
#           HOME  HOST    # this list is printed forever
#     $ echo $HO          # new prompt automatically populated with the previous command
#}}}
bindkey '^X^D' end-of-list

# C-x C-e         edit-command-line {{{4

autoload -Uz edit-command-line
zle -N edit-command-line

# Why this wrapper function around the `vim(1)` command?{{{
#
# It lets us customize the environment.
#
# Atm, we simply add an autocmd to remove the leading dollar in front of a shell
# command, which  we often  paste when  we copy some  code from  the web  or our
# notes.
# We also remove a possible indentation in front of `EOF`.
# In the future, we could do more advanced things...
#
# ---
#
# Also:
#
#     C-x C-e
#     :sp
#     C-k
#     C-j
#
# The last key should move the focus to the window below but it doesn't.
# This is  because zle  doesn't properly  restore stty settings  when it  runs a
# command from within command line edition:
#
# https://unix.stackexchange.com/q/484764/289772
#
# More specifically, it doesn't remove the terminal line setting `inlcr`.
# Here's how you can check this:
#
#     local VISUAL='__sane_vim'
#     →
#     local VISUAL='func'
#
#     func() {
#       stty -a >/tmp/stty_zle
#     }
#
#     C-x C-e
#
#     $ stty -a >/tmp/stty
#
#     $ vimdiff /tmp/stty /tmp/stty_zle
#               ├───────┘ ├───────────┘
#               │         └ contains 'inlcr'
#               │
#               └ contains '-inlcr'
#
# Solution 1:
# Create this wrapper function around `edit-command-line()`.
#
# Solution 2:
# Copy `/usr/share/zsh/functions/Zle/edit-command-line` inside `~/.zsh/`.
# Then edit the copy to include one of those lines:
#
#     STTY=sane
#     STTY=-inlcr
#
# You would lose the possible future updates of the original function:
# https://sourceforge.net/p/zsh/code/ci/ef20425381e83ebd5a10c2ab270a347018371162/log/?path=/Functions/Zle/edit-command-line
#
# Source: https://unix.stackexchange.com/a/485467/289772
#}}}
# Why `$@`?{{{
#
# It's necessary for the temporary filename to be passed.
#}}}

#            ┌  `man zshparam /PARAMETERS USED BY THE SHELL`{{{
#            │
#            │ Run `stty sane` in order to set up the terminal before executing `vim`.
#            │ The effect of `stty sane` is local to the `vim` command, and is reset when Vim
#            │ finishes or is suspended.
#            │
#            ├───────┐}}}
__sane_vim() STTY=sane command vim +'au TextChanged,InsertLeave <buffer> sil! call source#fixShellCmd()' "$@"

sane-edit-command-line() {
  emulate -L zsh
  # Do *not* replace `VISUAL` with `EDITOR`.{{{
  #
  # To  determine   which  editor   to  invoke,   `edit-command-line`  evaluates
  # `${VISUAL:-${EDITOR:-vi}}`:
  #
  #     /usr/share/zsh/functions/Zle/edit-command-line:20
  #
  # This gives the priority to `VISUAL` over `EDITOR`.
  # So, if you don't set `VISUAL` (only `EDITOR`), the latter will be used.
  # We've set it with the value `vim`, so `vim(1)` will be invoked.
  # But that's not what we want; we want `__sane_vim` to be invoked.
  #}}}
  local VISUAL='__sane_vim'
  # TODO: Find a way to prevent the status code `1` from being printed in the shell's prompt.{{{
  #
  # It's noise.
  # It's due to `zle send-break`:
  #
  #     /usr/share/zsh/functions/Zle/edit-command-line:37
  #
  # I tried to edit the script like so:
  #
  #     zle send-break || :
  #                    ^^^^
  #
  # Didn't work.
  #}}}
  zle edit-command-line
}
zle -N sane-edit-command-line

bindkey '^X^E' sane-edit-command-line
#              ^---^
#              wrapper function around the `edit-command-line()` function

# C-x C-h         complete-help {{{4

# TODO:
# This shows tags when we're at a certain  point of a command line where we want
# to customize the completion system.
# Explain what tags are, and how to read the output of `_complete_help`.
#
# See:
#     man zshcompsys /COMPLETION SYSTEM CONFIGURATION/;/Overview
#     man zshcompsys /BINDABLE COMMANDS
bindkey '^X^H' _complete_help

# The  `_complete_help` widget  shows all  the contexts  and tags  available for
# completion at a particular point.
# This provides an easy way of finding information for tag-order and other styles.
#
# This  widget displays information about  the context names, the  tags, and the
# completion functions used when completing at the current cursor position.
# If given a  numeric argument other than  1 (as in `ESC-2 ^Xh'),  then the styles
# used and the contexts for which they are used will be shown, too.
#
# Note that  the information about styles  may be incomplete; it  depends on the
# information available  from the  completion functions called,  which in  turn is
# determined by the user's own styles and other settings.

# C-x C-r         re-source zshrc {{{4

__reread_zshrc() {
  emulate -L zsh
  source "${HOME}/.zshrc" 2>/dev/null
  #                       ├─────────┘
  #                       └ “stty: 'standard input': Inappropriate ioctl for device”
#
# In case of an issue, this may help:
#
# https://unix.stackexchange.com/a/370506/232487
# https://github.com/zsh-users/zsh/commit/4d007e269d1892e45e44ff92b6b9a1a205ff64d5#diff-c47c7c7383225ab55ff591cb59c41e6b
}
zle -N __reread_zshrc
bindkey '^X^R' __reread_zshrc

# C-x H           run-help {{{4

my-run-help() {
  # Why running `__expand_aliases`?{{{
  #
  # If the first word on the line is an alias, `run-alias` will be run twice.
  # I don't like that, it's confusing.
  #
  # MWE:
  #
  #     $ unalias ls
  #     $ run-help ls
  #     # `run-help` is run only once
  #
  #     $ alias ls='\ls --color=auto'
  #     $ run-help ls
  #     # `run-help` is run twice
  #}}}
  zle __expand_aliases
  # What's this “run-help”?{{{
  #
  # From `type run-help`:
  #
  # > run-help is an autoload shell function
  #}}}
  #   What does it do?{{{
  #
  # It:
  #
  #    1. pushes the current buffer (command line) onto the buffer stack
  #    2. looks for a help page for the command name on the current command line (in case it's a builtin)
  #    3. if it doesn't find one, it invokes `man(1)`
  #
  # For more info, see `$ man zshzle /run-help`.
  #}}}
  zle run-help
}
zle -N my-run-help
bindkey '^XH' my-run-help

# C-x h           describe-key-briefly {{{4

# Usage:{{{
#
# Press `C-x H`,  then some key combination  for which you want the  name of the
# zle function which is invoked, like `M-!`, and you'll see something like:
#
#     "^[!" is _bash_complete-word
#}}}
bindkey '^Xh' describe-key-briefly
# }}}3
# C-z        ctrl_z {{{3

# Foreground the last job or temporarily discard the current command line.
# Inspiration:
# https://unix.stackexchange.com/a/10851/232487
# https://www.youtube.com/watch?v=SW-dKIO3IOI
__ctrl_z() {
  emulate -L zsh

  # if the current line is empty ...
  if [[ $#BUFFER -eq 0 ]]; then
  #     │
  #     └ size of the buffer

    # Why don't you just run `fg` directly?{{{
    #
    # The code would not work as expected the fourth time you press `C-z` consecutively.
    # It should resume Vim, but it would not.
    #
    # MWE:
    #
    #     # minimal zshrc
    #     nv() {
    #       vim -Nu NONE
    #     }
    #     ctrl_z() {
    #       if [[ $#BUFFER -eq 0 ]]; then
    #         fg
    #       else
    #         zle push-input
    #       fi
    #     }
    #     zle -N ctrl_z
    #     bindkey '^Z' ctrl_z
    #
    #     $ nv
    #     " press: C-z
    #     # press: C-z
    #     " press: C-z
    #     # press: C-z
    #       ctrl_z:fg:2: no current job~
    #
    # Besides, when the command-line is empty, there would be an annoying message:
    #
    #     # if there's a paused job
    #     [1]    continued  sleep 100~
    #
    #     # if there's no paused job
    #     __ctrl_z:bg:18: no current job~
    #
    # To get rid of it, you would need to run this command:
    #
    #     zle redisplay
    #}}}
    BUFFER=fg; zle accept-line
  else
    # Push the entire current multiline construct onto the buffer stack.{{{
    #
    # If it's only a single line, this is exactly like `push-line`.
    # Next time the editor starts up or is popped with `get-line`, the construct
    # will be popped off the top of the buffer stack and loaded into the editing
    # buffer.
    #}}}
    zle push-input
  fi
}
# This key binding won't prevent us to put a foreground process in the background.{{{
#
# When we  hit `C-z`  while a process  is in the  foreground, it's  probably the
# terminal  driver which  intercepts the  keystroke and  sends a  signal to  the
# process  to pause  it.  In  other words,  `C-z` should  reach zsh  only if  no
# process has the control of the terminal.
#}}}
zle -N __ctrl_z
bindkey '^Z' __ctrl_z
# }}}2
# Meta {{{2
# M-[!$/@~]    _bash_complete-word {{{3

# What's this “unnamed” function?{{{
#
# An anonymous function.
# See `man zshmisc` for more info.
#}}}
# Why such a function?{{{
#
# It's automatically executed after being defined, then removed.
#}}}
# Why do you use a function?{{{
#
# To make the `key` variable local, and not pollute the shell environment.
#}}}
# Where did you find the code for the for loop?{{{
#
#     /usr/share/zsh/functions/Completion/Base/_bash_completions
#}}}
() {
  emulate -L zsh
  local key
  for key in '!' '$' '@' '/' '~'; do
    # What do these key bindings do? {{{
    #
    # They emulate what `M-!`, `M-$`, ..., `C-x !`, `C-x $`, ... do in bash.
    #
    # In bash, when  you press these keys,  you always end up  invoking the same
    # completion  function, which  seems  to inspect  the last  key  of the  key
    # binding which was pressed, to decide which kind of completion to use.
    #
    #     ! = command names
    #     $ = variable names
    #     / = file names
    #     @ = host names
    #     ~ = user names (or named directories)
    #
    #     M- = opens the completion menu
    #     C-x = prints the list of matches
    # }}}
    # Do some of them shadow a builtin zsh command?{{{
    #
    # Yes.
    # By default, `M-!` is bound to `spell-word`.
    # And `M-$` to `history-expansion`.
    #
    # I don't care  about any of them, because  it seems that Tab is  able to do
    # the same:
    #
    #     % echoz Tab
    #         → echo
    #
    #     % !! !! !! Tab
    #         → last command, 3 times
    #}}}
    if [[ "${key}" != '$' ]]; then
      bindkey "\e${key}" _bash_complete-word
    fi
    bindkey "^X${key}" _bash_list-choices
  done
}

# TODO: bash also provides `complete-in-braces`, bound by default to `M-{`.{{{
#
# Try  it in  bash; press  `M-AltGr-4` (not  `M-AltGr-x`, the  terminal wouldn't
# receive anything).
# It dumps on the command line a file pattern which can be expanded into all the
# filenames of  the current  directory whose  name matches  the text  before the
# cursor:
#
#     $ D M-{
#         → D{esktop,o{cuments,wnloads},ropbox}
#
# Unfortunately, it's not supported by `_bash_complete-word`.
# Try and find a way to re-implement it in zsh.
#}}}
# TODO: When we press `M-~`, our terminal doesn't receive anything. {{{
#
# This is a Xorg issue.
# For some reason, pressing `Alt AltGr key` doesn't work for some keys (i, u, x, ...).
# Run `xev_terse_terse`, then press `Alt AltGr`:
#
#     64 Alt_L~
#     108 ISO_Level3_Shift~
#
# Now press and release `a`:
#
#     24 bar~
#
# Next press `i`: nothing happens.
# This is unexpected.  Why?
#
# Finally release `i`:
#
#     64 Alt_L~
#     108 ISO_Level3_Shift~
#
# This is also unexpected.  Why?
#
# Temporary Solution:
# Make another additional key generate `~`.
# This works because the issue doesn't apply to all physical keys, only these ones:
#
#    - F1, F2, F3, F5
#    - PgDown
#    - 1, 6, 8
#    - k_3, k_7, k_8 (`k_` = keypad)
#    - Tab, u, i, o
#    - Capslock, d, f, g, j
#    - greater/lower than sign, w, x, v, b
#
# ... out of around 98 (?) keys which can be combined with Meta + AltGr.
# Why those 25 keys?
# https://0x0.st/zpOa.txt
#
# Update:
# If you go into the keyboard settings and choose the English layout (move it to
# the top), then repeat the experiment with `xev(1)`, the issue persists, except
# this time, you'll see AltL and AltR:
#
#     (our custom layout)
#     64 Alt_L~
#     108 ISO_Level3_Shift~
#
#     (default english layout)
#     64 Alt_L~
#     68 Alt_R~
#
# Does this mean that the issue is in the kernel and not in Xorg?
# Not necessarily, it could simply be that our custom layout and the english one
# share the same “deficiencies”.
#
# Although, I can reproduce the issue in the console, where Xorg has no influence.
# So, I start thinking the issue is in the kernel...
#}}}

# M-#           pound-insert {{{3

bindkey '\e#' pound-insert

# M-,           copy-earlier-word {{{3

# Purpose:{{{
#
# `M-.` is useful to get the last argument of a previous command.
# But what if you want the last but one argument?
# Or the last but two.
#
# That's where the `copy-earlier-word` widget comes in.
#}}}
# usage:{{{
#
# Press `M-.` to insert the last argument of a previous command.
# Repeat until you reach the line of the history you're interested in.
#
# Then, press `M-,` to insert the last but one argument.
# Repeat to insert the last but two argument, etc.
#}}}
# How to cycle back to the last word of the command line?{{{
#
# Remove the inserted argument, and repeat the process:
#     `M-.` ...
#     `M-,` ...
#}}}
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey '\e,' copy-earlier-word

# M-;           insert-last-word-forward {{{3

# Purpose:{{{
#
# This key binding is  useful when you press `M-.` too many  times, and you want
# to go back to the next history event (instead of the previous one).
#
# https://unix.stackexchange.com/a/481714/289772
#}}}
# What does the `1` argument passed to `insert-last-word` mean?{{{
#
# From `man zshzle`:
#
#     When called from a shell function  invoked from a user-defined widget, the
#     command can take  one to three arguments.
#     The first argument specifies a  history offset which applies to successive
#     calls to this widget: if it is -1, the default behaviour is used, while if
#     it is 1, successive calls will move forwards through the history.
#}}}
# Where is it documented that it is allowed to omit braces around a function's body?{{{
#
#     man zshmisc /COMPLEX COMMANDS/;/\Vword ... () [ term ] command
#}}}
insert-last-word-forward() zle insert-last-word 1
zle -N insert-last-word-forward
bindkey '\e;' insert-last-word-forward

# M-[io]        capitalize-word  down-case-word  {{{3

# zle provides several functions to modify the case of a word:
#
#    * m-c    capitalize
#    * m-l    downcase
#    * m-u    upcase
#
# But we can't use `M-l` nor `M-c`, because they're already used by tmux / fzf.

bindkey '\ei' capitalize-word
bindkey '\eo' down-case-word

# Alternative: Use `M-u` as a prefix, and create a submode in which you don't need the prefix.{{{
#
# For example, this code lets you enter a submode by pressing `M-u`.
# In this submode, you can change the case of a word by pressing `u`, `i` or `o`.
# The submode is quit automatically after a few seconds.
#
#     TMOUT=6
#     trap __catch_signal_alrm ALRM
#     __catch_signal_alrm() {
#       M_U_SUBMODE=0
#     }
#
#     __enter-m-u-submode() {
#       M_U_SUBMODE=1
#     }
#     zle -N __enter-m-u-submode
#     bindkey '\eu' __enter-m-u-submode
#
#     __insert-u-or-up-case-word() {
#       if [[ $M_U_SUBMODE -eq 1 ]]; then
#         zle up-case-word
#       else
#         zle self-insert u
#       fi
#     }
#     zle -N __insert-u-or-up-case-word
#     bindkey 'u' __insert-u-or-up-case-word
#
#     __insert-i-or-capitalize-word() {
#       if [[ $M_U_SUBMODE -eq 1 ]]; then
#         zle capitalize-word
#       else
#         zle self-insert i
#       fi
#     }
#     zle -N __insert-i-or-capitalize-word
#     bindkey 'i' __insert-i-or-capitalize-word
#
#     __insert-o-or-down-case-word() {
#       if [[ $M_U_SUBMODE -eq 1 ]]; then
#         zle down-case-word
#       else
#         zle self-insert o
#       fi
#     }
#     zle -N __insert-o-or-down-case-word
#     bindkey 'o' __insert-o-or-down-case-word
#}}}

# M-e         __expand_aliases {{{3

# TODO:
# fully explain the `expand_aliases` function
#
#     https://unix.stackexchange.com/a/150737/232487
#     https://unix.stackexchange.com/a/372865/232487
#     man zshexpn     →  PARAMETER EXPANSION       →  ${+name}
#     man zshmodules  →  THE ZSH/PARAMETER MODULE  →  functions
#
# functions
#
#        This  associative  array  maps names of enabled functions to their
#        definitions.  Setting a key in it is like defining a function with the
#        name given by the key and the body given by the value.  Unsetting  a
#        key removes the definition for the function named by the key.

__expand_aliases() {
  emulate -L zsh
  unset 'functions[___expand_aliases]'
  # We put the current command line into `functions[___expand_aliases]`
  functions[___expand_aliases]=$BUFFER
  #     alias ls='ls --color=auto'
  #     alias -g V='|vipe'
  #     functions[___expand_aliases]='ls V'
  #     echo $functions[___expand_aliases]          →  ls --color=auto | vipe
  #     echo $+functions[___expand_aliases]         →  1
  #    (($+functions[___expand_aliases])); echo $?  →  0

  # this command does 3 things, and stops as soon as one of them fails:
  #     check the command is syntactically valid
  #     set the buffer
  #     set the position of the cursor
  (($+functions[___expand_aliases])) &&
    BUFFER=${functions[___expand_aliases]#$'\t'} &&
    CURSOR=$#BUFFER
}

zle -N __expand_aliases
bindkey '\ee' __expand_aliases

# FIXME:
#
#     $ alias foo='virtualbox &!'
#     # insert 'foo'
#     # press `M-e`
#     $ virtualbox &|~
#                   ^
#                   ✘
#                             v
#     $ alias foo='virtualbox \&!'
#     # insert 'foo'
#     # press `M-e`
#     $ virtualbox \&!~
#                  ^ ^
#                  ? ✔

# M-m           normalize_command_line {{{3

# TODO:
# Explain how it works.
# Also,   what's   the   difference   between   `__normalize_command_line`   and
# `__expand_aliases`?
# They  seem to  do  the same  thing.   If that's  so, then  remove  one of  the
# functions and key bindings.
__normalize_command_line() {
  functions[__normalize_command_line_tmp]=$BUFFER
  BUFFER=${${functions[__normalize_command_line_tmp]#$'\t'}//$'\n\t'/$'\n'}
  ((CURSOR == 0 || CURSOR == $#BUFFER))
  unset 'functions[__normalize_command_line_tmp]'
}
zle -N __normalize_command_line
bindkey '\em' __normalize_command_line

# M-[pn]        {up|down}-line-or-beginning-search {{{3

# Rationale:{{{
#
# By default,  `M-p` and `M-n` are  bound to `history-beginning-search-backward`
# and `history-beginning-search-forward`.
# Those widgets search for a line which begins with the *first word* on the line.
# We want to search for a line which begins with the *whole current line*, up to
# the current cursor position.
#
# See:
#
#     man zshcontrib /up-line-or-beginning-search
#     /usr/share/zsh/functions/Zle/up-line-or-beginning-search
#     /usr/share/zsh/functions/Zle/down-line-or-beginning-search
#}}}
# TODO: Sometimes, I can't access a previous command!{{{
#
# It seems  that as soon  as you edit an  old command, it's  temporarily removed
# from the set of commands in which `up-line-or-beginning-search` searches.
#
#     $ zsh -f
#
#     $ autoload -Uz up-line-or-beginning-search ; autoload -Uz down-line-or-beginning-search
#     $ zle -N up-line-or-beginning-search ; zle -N down-line-or-beginning-search
#     $ bindkey '\ep' up-line-or-beginning-search ; bindkey '\en' down-line-or-beginning-search
#
#     $ echo 1
#     $ echo 2
#     $ echo 3
#
#     $ echo M-p
#     3~
#     M-p
#     2~
#     C-u
#     ''~
#     echo M-p (stay on the current prompt)
#     1~
#     M-n
#     3~
#
# ---
#
# For  the moment, the only  solution I know is  to start a new  command-line by
# pressing `C-c` or `M-#`.
#
# Try to improve the code in:
#
#     /usr/share/zsh/functions/Zle/up-line-or-beginning-search
#     /usr/share/zsh/functions/Zle/down-line-or-beginning-search
#}}}
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '\ep' up-line-or-beginning-search
bindkey '\en' down-line-or-beginning-search

# M-Y           copy-region-as-kill {{{3

# By default, `copy-region-as-kill` is bound to `M-w` and `M-W`.
# It seems too hard to type.
# Let's try `M-Y`.
bindkey -r '\ew'
bindkey -r '\eW'
bindkey '\eY' copy-region-as-kill

# }}}2
# Menuselect {{{2

bindkey -M menuselect '^J' down-line-or-history
#        │{{{
#        └ selects the "menuselect" keymap
#
#           "bindkey -l" lists all the keymap names
#            for more info: man zshzle
#}}}
bindkey -M menuselect '^K' up-line-or-history

bindkey -M menuselect '^H' backward-char
bindkey -M menuselect '^L' forward-char

# Why do I need these 2 intermediate key bindings?{{{
#
# The alternative would be sth like this:
#
#     fast-down-line-or-history() {
#         zle down-line-or-history -n 5
#     }
#     zle -N fast-down-line-or-history
#     bindkey -M menuselect '^D' fast-down-line-or-history
#
#     fast-up-line-or-history() {
#         zle up-line-or-history -n 5
#     }
#     zle -N fast-up-line-or-history
#     bindkey -M menuselect '^U' fast-up-line-or-history
#
# But it wouldn't work because:
#
# >     Note  that  the following  always  perform  the  same  task within  the  menu
# >     selection map and cannot be replaced by user defined widgets, nor can the set
# >     of functions be extended:
#
# IOW, you can't bind any custom widget in the `menuselect` keymap.
#
# See:
#
#   - `man zshmodules /THE ZSH\/COMPLIST MODULE/;/Menu selection`
#   - https://unix.stackexchange.com/a/588002/289772
#}}}
bindkey -M menuselect '\ej' down-line-or-history
bindkey -M menuselect '\ek' up-line-or-history
bindkey -M menuselect -s '^D' '\ej\ej\ej\ej\ej'
bindkey -M menuselect -s '^U' '\ek\ek\ek\ek\ek'

# move the mark to the first line of the next/previous group of matches
bindkey -M menuselect '\ed' vi-forward-blank-word
bindkey -M menuselect '\eu' vi-backward-blank-word

bindkey -M menuselect '^O' accept-and-menu-complete
#                          │
#                          └ insert the selected match on the command line,
#                            but don't close the menu
# TODO:
# By default `M-a` is bound to `accept-and-hold` which does the same thing.
# `fzf.vim` seems to use `M-a` to do something vaguely similar: selecting
# multiple entries in a menu.
# Should we get rid of this `C-o` key binding and prefer `M-a`?

# In Vim we quit the completion menu with `C-q` (custom).
# We want to do the same in zsh (by default it's `C-g` in zsh).
bindkey -M menuselect '^Q' send-break
# }}}1
# Abbreviations {{{1

# http://zshwiki.org/home/examples/zleiab

typeset -Ag abbrev
#        ││
#        │└ don't restrict to local scope
#        └ `abbrev` refer to an associative array parameter

# How to prevent the expansion of an abbreviation?{{{
#
# Quote it:
#
#     $ echo 'V' some text
#
# Or insert the next space literally, by pressing `C-v SPC`:
#
#     $ echo V C-v SPC some text
#}}}
abbrev=(
  # Grep (and ignore the `grep(1)` process if we grep the output of `ps(1)`)
  'G' '| grep -v grep | grep'
  'L' '2>&1 | less'
  # Warning: If `cmd V` opens an empty buffer,{{{
  # then later opens the right buffer  (the one containing the output of `cmd`),
  # try to delete `~/.fasd-init-zsh`, and restart the shell.
  #
  # It worked in the past.
  # The issue came from:
  #
  #     ~/.fasd-init-zsh:22
  #     { eval "fasd --proc $(fasd --sanitize $1)"; } >> "/dev/null" 2>&1
  #                                            ^
  #                                            ✘ if you replace it with 2, the issue disappears
  #
  # Maybe  the issue  came  from  having installed  fasd  from  the official  repo
  # (instead of github)...
  #}}}
  'V' '2>&1 | vipe >/dev/null'
  #                │
  #                └ don't write on the terminal, the Vim buffer is enough

  # Align Columns
  'ac' '| column -t'
  # ring the BelL
  'bl' '; tput bel'

  # Cd into most reCent directory (useful after cloning a repo)
  'cc' '&& cd *(/oc[1])'
  #           │ │├┘├─┘{{{
  #           │ ││ └ first directory in the list
  #           │ │└ sort by the time of the last inode change
  #           │ └ only the directories
  #           └ all files/directories in the current directory
  #
  # For more info:
  #
  #     man zshexpn /FILENAME GENERATION/;/Glob Qualifiers/;/^\s*\Coc\s
  #     https://unix.stackexchange.com/a/550640/289772
  #}}}

  # printf FieLd
  'fl' "| awk '{ print $"

  # No Errors
  'ne' '2>/dev/null'
  'pf' "printf -- '"

  # silence!
  'sl' '>/dev/null 2>&1'
  #     ├────────┘ ├──┘{{{
  #     │          └ same thing for errors
  #     └ redirect output to /dev/null
  #}}}

  # Do *not* use `T`; it would be expanded when you try to (un)bind a tmux key binding:
  #     $ tmux bind -T ...
  'tl' '| tail -20'
)

# If you don't like the `cc` abbreviation, have a look at:{{{
#
#     man zshcontrib /Manipulating Hook Functions
#     man zshmisc /SPECIAL FUNCTIONS
#
# https://unix.stackexchange.com/a/276472/289772
# https://unix.stackexchange.com/questions/97920/how-to-cd-automatically-after-git-clone/276472#comment972969_276472
#}}}

__abbrev_expand() {
  emulate -L zsh
  # In addition to the characters `*(|<[?`, we also want `#` to be regarded as a
  # pattern for filename generation.
  setopt EXTENDED_GLOB

  # make the `MATCH` parameter local to this function; otherwise, it would pollute
  # the shell environment with the last word before hitting the last space
  local MATCH

  LBUFFER=${LBUFFER%%(#m)[a-zA-Z]#}
  #                ├┘├──┘        │{{{
  #                │ │           └ matches 0 or more of the previous pattern (word character)
  #                │ │             See: `man zshexpn /^\s*x#\s`
  #                │ │
  #                │ └ populate `$MATCH` with the suffix removed by `%%`
  #                │   See: `man zshexpn /\C^\s*m\s*Set`
  #                │
  #                └ remove longest suffix matching the following pattern
  #                  See: `man zshexpn /%%pat`
  #}}}

  # Only trigger abbreviation if the previous character is a space.{{{
  #
  # Useful, for example, to not trigger an abbreviation right after a hyphen:
  #
  #     $ dpkg -L foo
  #     $ awk -V | head -n1
  #}}}
  if [[ "${LBUFFER: -1}" == ' ' ]]; then
  #                │{{{
  #                └ `man zshexpn /${name:offset}`
  #
  # > If offset  is negative, the  - may not appear  immediately after the  : as
  # > this indicates the ${name:-word} form of substitution.
  # > Instead,  a  space  may  be inserted before the -.
  #}}}
    LBUFFER+=${(e)abbrev[$MATCH]:-$MATCH}
    #        │  │{{{
    #        │  └ lets us use an abbreviation whose rhs contains parameter expansion flags
    #        │    for example, thanks to `(e)`, you could use this abbreviation:
    #        │
    #        │        'cc' '&& cd ${${${${(z)BUFFER}[3]}##*/}%%.*}'
    #        │
    #        │    Warning: because of this, you may need to quote special characters in your abbreviations
    #        │
    #        │    For more info:
    #        │
    #        │        `man zshexpn /PARAMETER EXPANSION/;/Parameter Expansion Flags/;/^\s*\Ce\s`
    #        │        https://unix.stackexchange.com/a/550640/289772
    #        │
    #        └ expands into `abbrev[$MATCH]` if the latter is set, `$MATCH` otherwise
    #          See: `man zshexpn /${name:-word}`
    #}}}

    # Append some text for some abbreviations.{{{
    #
    # Atm only for:
    #
    #     'fl'   "| awk '{ print $"
    #     'pf'    "printf -- '"
    #}}}
    if [[ $MATCH = 'fl' ]]; then
      RBUFFER="}'"
      # FIXME: we want the cursor to be right after the `$` sign in:
      #
      #     awk '{ print $ }'
      #
      # but zsh inserts a space before the cursor, no matter the value we give
      # to `CURSOR`.  How to avoid this?
      # CURSOR=$(($#LBUFFER))
      # NOTE: by default, CURSOR=$#LBUFFER
    elif [[ $MATCH = 'pf' ]]; then
      RBUFFER="\n'"
    fi

  else
    LBUFFER+=$MATCH
  fi

  # we need to insert the key we've just typed (here space), otherwise,
  # we wouldn't be able to insert a space anymore
  zle self-insert
  #   │
  #   └ run the `self-insert` widget to insert a character into the buffer at
  #     the cursor position (`man zshzle`)
}

# define a widget to expand when inserting a space
zle -N __abbrev_expand
# bind it to the space key
bindkey ' ' __abbrev_expand

# When searching in the history with default `C-r` or `C-s`, we don't want
# a space to expand an abbreviation, just to insert itself.
# We don't have this problem because we use `fzf` which rebinds those keys.
# However, we still disable abbreviation expansion in a search:
bindkey -M isearch ' ' self-insert
#        │
#        └ man zshzle: this key binding will only take effect in a search
#
# NOTE:
# To test the influence of this key binding, uncomment next key binding, and
# move it at the end of `~/.zshrc`:
#
#     bindkey "^R" history-incremental-search-backward
#
# It restores default `C-r`.
#
# Without the previous:
#
#     bindkey -M isearch " " self-insert
#
# ... as soon as you would type a  space in a search, you would leave the latter
# and go back to the regular command line.

# Variables {{{1
# WARNING: Make sure this `Variables` section is always after `Functions`.{{{
#
# Because  if  you  refer  to  a  function in  the  value  of  a  variable  (ex:
# `precmd_functions`), and it doesn't exist yet, it may raise an error.
#}}}

# What's `$TERM` inside a terminal, by default?{{{
#
# In many terminals, including xfce-terminal, guake, konsole:
#
#     $TERM = xterm
#
# Yeah, they lie about their identity to the programs they run.
#
# In urxvt:
#
#     $TERM = rxvt-unicode-256color
#
# urxvt tells the truth.
#}}}
# Where is the configuration file for a terminal?{{{
#
# xfce-terminal and guake don't seem to have one.
# However, you may find a way to  configure how they advertise themselves to the
# programs they run, like this:
#
#    1. right-click
#    2. preferences
#    3. compatibility
#
# urxvt uses `~/.Xresources`.
#}}}
# Why do we, on some conditions, reassign `xterm-256color` to `$TERM`?{{{
#
# For the color  schemes of programs to be displayed  correctly in the terminal,
# `$TERM` must contain '-256color'.
# Otherwise, the programs  will assume the terminal is only  able to interpret a
# limited amount  of escape  sequences used  to encode 8  colors, and  they will
# restrict themselves to a limited palette.
#}}}
#   Ok, but why do it in this file?{{{
#
# The configuration  of `$TERM` should  happen only in a  terminal configuration
# file.  But for xfce4-terminal, I haven't found one.  So, we must try to detect
# the identity of the terminal from here.
#}}}
# How to detect we're in an xfce terminal?{{{
#
# If you look at  the output of `env` and search for  'terminal' or 'xfce4', you
# should find `COLORTERM` whose value is set to 'xfce4-terminal'.
# We're going to use it to detect an xfce4 terminal.
#}}}
#   Is it enough?{{{
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
# We must *not* reset `$TERM` when the  terminal is connecting to a running tmux
# server.  Because the  latter will already have set  `$TERM` to 'tmux-256color'
# (thanks to the option 'default-terminal' in  `tmux.conf`), which is one of the
# few valid value ({screen|tmux}[-256color]).
#
# One way to be sure that we're not connected to tmux , is to check that `$TERM`
# is set to 'xterm'.  That's the default value set by xfce4-terminal.
#
# ---
#
# Update:
# The reason given earlier is not valid anymore.
# Since tmux 2.1, `default-terminal` is a server option.
# The reason was valid before that, when `default-terminal` was a session option.
#
# Still, I  think it's a  good idea to set  `$TERM` to `xterm-256color`  only if
# it's currently set to `xterm`.
#}}}
# Why don't you export it in `~/.zshenv`?{{{
#
# It  worked in  the past,  but it  doesn't work  anymore in  an xfce  terminal,
# because when `~/.zshenv` is sourced, `TERM` and `COLORTERM` are not set yet.
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
if [[ "${TERM}" == 'xterm' ]]; then
  if [[ "${COLORTERM}" == 'xfce4-terminal' || -n "${KONSOLE_PROFILE_NAME}" ]]; then
  #                                           ├──────────────────────────┘{{{
  #                                           └ to also detect the Konsole terminal}}}
    export TERM=xterm-256color
  fi
fi
# }}}1

# TODO: Try to customize the theme for the linux console (then remove `[[ -n "$DISPLAY" ]]`).
if [[ -n "$DISPLAY" ]]; then
  source "${HOME}/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  source "${HOME}/.zsh/syntax_highlighting.zsh"
fi

# noa vim //gj ~/Dropbox/conf/bin/**/*.sh ~/.shrc ~/.bashrc ~/.zshrc ~/.zshenv ~/.vim/plugged/vim-snippets/UltiSnips/sh.snippets | cw
#         ^
#         put whatever pattern you want to refactor
#
# TODO: maybe integrate the previous command in one of our cycles.

# TODO:
# Currently we have several lines in this file which must appear before or after
# a certain point to avoid being overridden/overriding sth.
# It feels brittle.
# One day we could move them in the wrong order.
# Find a better way of organizing this file.
# Or write at the top of the  file that some sections must be sourced before/after
# others.

